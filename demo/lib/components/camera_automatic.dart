import 'dart:async';
import 'package:camera/camera.dart';
import 'package:demo/questions/ojosev.dart';
import 'package:flutter/material.dart';
import 'package:quiver/async.dart';

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;
  final  Stopwatch st;
  final String resultsname;

  const TakePictureScreen({Key? key, required this.st,required this.camera,required this.resultsname}) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  int _start = 11;
  int showing=10;
  int _current = 11;
  bool timerstarted=false;

  void startTimer() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _start),
      new Duration(seconds: 1),
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() { 
        _current = _start - duration.elapsed.inSeconds; 
        showing=_current--;
        timerstarted=true;
      });
    });

    sub.onDone(() {
      sub.cancel();
      takepic();
    });
  }


    Future<void> takepic() async {
    var xFile = await _controller.takePicture();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EyesEv(xFile,widget.st,widget.resultsname)),
    ); 
  }

  @override
  void initState() {
    //SystemChrome.setEnabledSystemUIMode();
    super.initState();
    // Para visualizar la salida actual de la cámara, es necesario 
    // crear un CameraController.
    _controller = CameraController(
      // Obtén una cámara específica de la lista de cámaras disponibles
      widget.camera,
      // Define la resolución a utilizar
      ResolutionPreset.high,
    );

    // A continuación, debes inicializar el controlador. Esto devuelve un Future!
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Asegúrate de deshacerte del controlador cuando se deshaga del Widget.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children:[
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                //final size = MediaQuery.of(context).size;
                //final deviceRatio = size.width / size.height;
                //final xScale = 1.0;
                // Modify the yScale if you are in Landscape
                //final yScale = 1.0;
                if (timerstarted==false) {
                  startTimer();
                }
                return CameraPreview(_controller);
              } else {
                // De lo contrario, muestra un indicador de carga
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          Center(
            child: Container(
              color: Colors.black87,
              width: double.infinity,
              height: 105,
              child: _current>1 ? Text("Cierre Los ojos en" + "\n" + "$showing" + "\n" + "segundos"
              ,style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold
              ,height: 1, fontSize: 43),textAlign: TextAlign.center,) 
              : Text("Cierre los ojos ahora"
              ,style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold
              ,height: 1, fontSize: 43),textAlign: TextAlign.center,) 
            )
          ),
        ],
      ),
    );
  }
}
