import 'package:camera/camera.dart';
import 'package:demo/additional/constants.dart';
import 'package:demo/additional/otherfunctions.dart';
import 'package:demo/components/camera_automatic.dart';
import 'package:demo/components/tts.dart';
import 'package:demo/questions/verbal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class EyesQ extends StatefulWidget {
  final String pregunta;
  final String num;
  final String resultsname;

  EyesQ(this.pregunta,this.num,this.resultsname);
  @override
  _EyesQState createState() => _EyesQState();
}

class _EyesQState extends State<EyesQ> {
  Stopwatch sw = new Stopwatch();
  Stopwatch takepic = new Stopwatch();
  final FlutterTts tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    sw.start();
    tts.setLanguage('es');
    tts.setSpeechRate(0.3);
  }

  Future<void> linkNext () async {
    final cameras = await availableCameras();
    final firstCamera = cameras[1];

    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => TakePictureScreen(st: sw,camera: firstCamera,resultsname: widget.resultsname,)),
    ); 
  }
  Future<void> linkNext2 () async {
    sw.stop();
    int timeanswer =sw.elapsedMilliseconds;
    updatedf(widget.resultsname,"instrucción escrita",timeanswer);
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) 
    => VerbalQ("REALICE LO SIGUIENTE: PONGA EL CELULAR EN HORIZONTAL, LUEGO, HAGA CLICK EN EL CUADRADO, 1 VEZ, Y PONGA EL CELULAR EN VERTICAL","PREGUNTA N°16",widget.resultsname)),
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
              child: Text(
                widget.num,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: questionTitle,
              ),
            ),
            SizedBox(height: 30*ratio),
            Teteese(widget.pregunta,kPrimaryColor),
            SizedBox(height: 30*ratio),
            ElevatedButton(
              child: Text("Continuar",style: continueButtom),
              onPressed: (){     
                linkNext();
              },
              style: ElevatedButton.styleFrom(
                primary:kPrimaryColor,
                fixedSize: Size(140*wratio, 50*ratio),
              ),
            ),
            SizedBox(height: 15*wratio),
            TextButton(
              child: Text("Saltar",style: skipButtom),
              onPressed: (){ 
                uploadPoints("instrucción escrita",widget.resultsname,0);    
                linkNext2();
              },
            ),
          ],
        ),
      ),
    );
  }
}