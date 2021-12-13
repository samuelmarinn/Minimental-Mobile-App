import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:demo/additional/constants.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';

void toast(message){
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
    backgroundColor: Colors.cyan,
    textColor: Colors.white,
    fontSize: 20
  );
}
class VideoRecorderExample extends StatefulWidget {
  final String a;
  final Function(String) callback;
  final String questionName;
  VideoRecorderExample(this.a, this.callback,this.questionName);

  @override
  _VideoRecorderExampleState createState() {
    return _VideoRecorderExampleState();
  }
}

class _VideoRecorderExampleState extends State<VideoRecorderExample> {
  CameraController? controller;
  String videoPath = " ";
  FirebaseStorage storage = FirebaseStorage.instance;

  List<CameraDescription> cameras = [CameraDescription(name: "name", lensDirection: CameraLensDirection.front, sensorOrientation: 0)];
  int selectedCameraIdx = 0;

  @override
  void initState() {
    super.initState();

    // Get the listonNewCameraSelected of available cameras.
    // Then set the first camera as selected.
    availableCameras()
        .then((availableCameras) {
      cameras = availableCameras;

      if (cameras.length > 0) {
        setState(() {
          selectedCameraIdx = 1;
        });

        _onCameraSwitched(cameras[selectedCameraIdx]).then((void v) {});
      }
    })
        .catchError((err) {
      print('Error: $err.code\nError Message: $err.message');
    });
  }

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Camera example'),
      ),
      body: Column(
        children: <Widget>[
          /*Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Center(
                  child: _cameraPreviewWidget(),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: controller != null && controller.value.isRecordingVideo
                      ? Colors.redAccent
                      : Colors.grey,
                  width: 3.0,
                ),
              ),
            ),
          ),*/
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                //_cameraTogglesRowWidget(),
                _captureControlRowWidget(),
                Expanded(
                  child: SizedBox(),
                ),
              ],
            ),
          ),
        ],
      ),
    );*/

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          /*Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Center(
                  child: _cameraPreviewWidget(),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: controller != null && controller.value.isRecordingVideo
                      ? Colors.redAccent
                      : Colors.grey,
                  width: 3.0,
                ),
              ),
            ),
          ),*/
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _captureControlRowWidget(),
              ],
            ),
          ),
        ],
    );
  }

  IconData _getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
      default:
        return Icons.device_unknown;
    }
  }

  // Display 'Loading' text when the camera is still loading.
  // NO BORRAR
  /*Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
    );
  }*/

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  /*Widget _cameraTogglesRowWidget() {
    if (cameras == []) {
      return Row();
    }

    CameraDescription selectedCamera = cameras[selectedCameraIdx];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: ElevatedButton.icon(
            onPressed: _onSwitchCamera,
            icon: Icon(
                _getCameraLensIcon(lensDirection)
            ),
            label: Text("${lensDirection.toString()
                .substring(lensDirection.toString().indexOf('.')+1)}")
        ),
      ),
    );
  }*/

  /// Display the control bar with buttons to record videos.
  Widget _captureControlRowWidget() {
    if (cameras == []) {
      return Row();
    }

    return Expanded(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Ink(
              decoration: const ShapeDecoration(
              color: Colors.green,
              shape: RoundedRectangleBorder(),
              ),
              child: IconButton(
                icon: const Icon(Icons.videocam),
                color: Colors.white60,
                iconSize: 45,
                onPressed: controller != null &&
                    controller!.value.isInitialized &&
                    !controller!.value.isRecordingVideo
                    ? _onRecordButtonPressed
                    : null,
              ),
            ),
            SizedBox(width: 10),
            Ink(
              decoration: const ShapeDecoration(
              color: Colors.red,
              shape: RoundedRectangleBorder(),
              ),
              child: IconButton(
                icon: const Icon(Icons.stop),
                color: Colors.white60,
                iconSize: 48,
                onPressed: controller != null &&
                    controller!.value.isInitialized &&
                    controller!.value.isRecordingVideo
                    ? _onStopButtonPressed
                    : null,
              )
            ),
          ],
        ),
      ),
    );
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<void> _onCameraSwitched(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller!.dispose();
    }

    controller = CameraController(cameraDescription, ResolutionPreset.high);

    // If the controller is updated then update the UI.
    controller!.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller!.value.hasError) {
        toast('Error en la cámara: ${controller!.value.errorDescription}');
      }
    });

    try {
      await controller!.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  /*void _onSwitchCamera() {
    selectedCameraIdx = selectedCameraIdx < cameras.length - 1
        ? selectedCameraIdx + 1
        : 0;
    CameraDescription selectedCamera = cameras[selectedCameraIdx];

    _onCameraSwitched(selectedCamera);

    setState(() {
      selectedCameraIdx = selectedCameraIdx;
    });
  }*/

  void _onRecordButtonPressed() {
    _startVideoRecording().then((String filePath) {
      if (filePath != "") {
        toast('Respuesta siendo grabada',);
      }
    });
  }

  void _onStopButtonPressed() {
    /*_stopVideoRecording().then((_) {
      if (mounted) setState(() {});
      toast('Respuesta grabada');
    });*/
    _stopVideoRecording();
  }

  Future<String> _startVideoRecording() async {
    if (!controller!.value.isInitialized) {
      toast('Por favor espere' );
      return "";
    }

    // Do nothing if a recording is on progress
    if (controller!.value.isRecordingVideo) {
      return "";
    }

    try {
      await controller!.startVideoRecording();
      //videoPath = filePath;
    } on CameraException catch (e) {
      _showCameraException(e);
      return "";
    }

    return widget.questionName;
  }

  Future<void> _stopVideoRecording() async {
    if (!controller!.value.isRecordingVideo) {
      return null;
    }

    try {
      toast("Respuesta siendo procesada. Por favor espere",);
      XFile vid =await controller!.stopVideoRecording();
      videoPath = vid.path;
      //await GallerySaver.saveVideo(vid.path);
      final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
      String filePathWav = videoPath.substring(0, videoPath.length - 4) + ".aac";
      String command = "-i " + vid.path + " -vn -acodec copy " + filePathWav;
      int rc = await _flutterFFmpeg.execute(command);
      print("FFmpeg process exited with rc $rc");
      //convertir a wav
      String wavePath = videoPath.substring(0, filePathWav.length - 4) + ".wav";
      command = "-i " + filePathWav + " " + wavePath;
      rc = await _flutterFFmpeg.execute(command);
      print("FFmpeg process exited with rc $rc");
      File(filePathWav).deleteSync();
      //enviar al servidor flask
      var uri = Uri.parse('http://speechrec.pythonanywhere.com/speechrec');
      var req = http.MultipartRequest('POST', uri);
      var multipartFile = await http.MultipartFile.fromPath("file", wavePath);
      req.files.add(multipartFile);
      req.headers["Content-Type"] = 'multipart/form-data';
      var response = await req.send();
      if(response.reasonPhrase != "INTERNAL SERVER ERROR"){
        //enviar grabación obtenida a un servidor, acá se usa el nombre obtenido por widget
        var up = Uri.parse('http://storagemm.pythonanywhere.com/uploadvideo');
        var req = http.MultipartRequest('POST', up);
        var multipartFile = await http.MultipartFile.fromPath("file", videoPath);
        req.files.add(multipartFile);
        req.headers["Content-Type"] = 'multipart/form-data';
        req.fields["namefile"]=widget.questionName;
        await req.send();
        File(vid.path).deleteSync();
        var strres= await response.stream.bytesToString();
        Map<String, dynamic> map = jsonDecode(strres);
        toast("respuesta registrada");
        String name = map['response'];
        widget.callback(name);
      }
      else {
        toast('Error. Por favor intentar de nuevo');
      }
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;

    }
  }

  void _showCameraException(CameraException e) {
    String errorText = 'Error: ${e.code}\nError Message: ${e.description}';
    print(errorText);

    toast('Error: ${e.code}\n${e.description}');
  }
}