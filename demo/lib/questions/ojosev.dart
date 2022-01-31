import 'dart:io';
import 'package:camera/camera.dart';
import 'package:demo/additional/constants.dart';
import 'package:demo/additional/otherfunctions.dart';
import 'package:demo/components/camera_automatic.dart';
import 'package:demo/questions/verbal.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class EyesEv extends StatefulWidget {
  final XFile image;
  final Stopwatch stw;
  final String resultsname;
  EyesEv(this.image,this.stw,this.resultsname);
  @override
  _EyesEvState createState() => _EyesEvState();
}

class _EyesEvState extends State<EyesEv> {

final faceDetector = GoogleMlKit.vision.faceDetector(FaceDetectorOptions(
    enableContours: true,
    enableClassification: true,
  ));

  @override
  void initState() {
    super.initState();
  }

  Future<void> evaluateAnswer() async {
    widget.stw.stop();
    int points =0;
    var f = File(widget.image.path.toString());
    var inputImage = InputImage.fromFile(f);
    final List<Face> faces = await faceDetector.processImage(inputImage);
    var leftprob = faces[0].leftEyeOpenProbability;
    var rightprob = faces[0].rightEyeOpenProbability;
    if (leftprob!<0.2 && rightprob! < 0.2){
      points =1;
    }
    //envir puntaje
    uploadPoints("instrucción escrita",widget.resultsname,points);
    linkNext();
  }

  void linkNext (){
    widget.stw.stop();
    int timeanswer =widget.stw.elapsedMilliseconds;
    updatedf(widget.resultsname,"instrucción escrita",timeanswer);
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) 
    => VerbalQ("REALICE LO SIGUIENTE: PONGA EL CELULAR EN HORIZONTAL, LUEGO, HAGA CLICK EN EL CUADRADO, UNA VEZ, Y PONGA EL CELULAR EN VERTICAL","PREGUNTA N°16",widget.resultsname)),
    ); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 300*wratio,
              height: 400*ratio,
              child: Image.file(File(widget.image.path), fit: BoxFit.cover),
            ),
            SizedBox(height: 30*ratio),
            ElevatedButton(
              child: Text("Ingrsar Respuesta",style: continueButtom),
              onPressed: (){  
                evaluateAnswer(); 
              },
              style: ElevatedButton.styleFrom(
                primary:kPrimaryColor,
                fixedSize: Size(250*wratio, 50*ratio),
              ),
            ),
            SizedBox(height: 15*ratio),
            TextButton(
              child: Text("Volver",style: skipButtom),
              onPressed: () async {     
                final cameras = await availableCameras();
                final firstCamera = cameras[1];
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TakePictureScreen(st: widget.stw,camera: firstCamera,resultsname: widget.resultsname)),
                ); 
              },
            ),
          ],
        ),
      ),
    );
  }
}