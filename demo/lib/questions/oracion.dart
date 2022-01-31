import 'package:camera/camera.dart';
import 'package:demo/additional/constants.dart';
import 'package:demo/additional/otherfunctions.dart';
import 'package:demo/components/camera_pic.dart';
import 'package:demo/components/tts.dart';
import 'package:demo/questions/reporacion.dart';
import 'package:flutter/material.dart';

//ir restando de a uno, hasta llegar a las 5 que se piden, se va añadiendo y se va comparando

class SentenceQ extends StatefulWidget {
  final String pregunta;
  final String num;
  final String resultsname;

  SentenceQ(this.pregunta,this.num,this.resultsname);
  @override
  _SentenceQState createState() => _SentenceQState();
}

class _SentenceQState extends State<SentenceQ> {
  Stopwatch sw = new Stopwatch();
    String answer= "";

  @override
  void initState() {
    super.initState();
    sw.start();
  }

  callback(recanswer) {
    setState(() {
      answer = recanswer;
    });
  }

  void getAnswer(String a) {
    setState(() {
      answer=a;
    });
  }

  void linkNext (){
    sw.stop();
    int timeanswer =sw.elapsedMilliseconds;
    updatedf(widget.resultsname,"escritura de oración",timeanswer);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RepsenQ("REPITA, LA SIGUIENTE, ORACIÓN: No hay ni sí, ni no, ni pero","PREGUNTA N° 18",widget.resultsname)),
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
              child: Text("Tomar Foto",style: continueButtom),
              onPressed: () async { 
                final cameras = await availableCameras();
                final firstCamera = cameras[0];    
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TakePicScr(st: sw,camera: firstCamera,q: "escritura de oraciones",resultsname: widget.resultsname,)),
                ); 
              },
              style: ElevatedButton.styleFrom(
                primary:kPrimaryColor,
                fixedSize: Size(160*wratio, 50*ratio),
              ),
            ),
            SizedBox(height: 15*ratio),
            TextButton(
              child: Text("Saltar",style: skipButtom,),
              onPressed: (){    
                uploadPoints("escritura de oración",widget.resultsname,0); 
                linkNext();
              },
            ),
          ],
        ),
      ),
    );
  }
}