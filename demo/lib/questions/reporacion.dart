import 'package:demo/additional/constants.dart';
import 'package:demo/additional/otherfunctions.dart';
import 'package:demo/components/tts.dart';
import 'package:demo/questions/denominacion.dart';
import 'package:flutter/material.dart';
import 'package:demo/components/camera_video.dart';

class RepsenQ extends StatefulWidget {
  final String pregunta;
  final String num;
  final String resultsname;
  RepsenQ(this.pregunta,this.num,this.resultsname);
  @override
  _RepsenQState createState() => _RepsenQState();
}

class _RepsenQState extends State<RepsenQ> {
  String answer ="";
  Stopwatch sw = new Stopwatch();

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

  Future<void> evaluateAnswer() async {
    int points=0;
    if (answer==sentence){
      points=1;
    }
    //enviar puntaje
    uploadPoints("repetición de oración",widget.resultsname,points);
  }

  void linkNext (){
    sw.stop();
    int timeanswer =sw.elapsedMilliseconds;
    updatedf(widget.resultsname,"repetición de oración",timeanswer);
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ImageQ("DIGA QUÉ ES, CADA UNA, DE LAS IMÁGENES, QUE VE EN LA PANTALLA","PREGUNTA N°19",widget.resultsname)),
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
                widget.num ,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: questionTitle,
              ),
            ),
            SizedBox(height: 30*ratio),
            Teteese(widget.pregunta,kPrimaryColor),
            SizedBox(height: 30*ratio),
            VideoRecorderExample(answer, callback,"repetición de oración"),
            SizedBox(height: 30*ratio),
            ElevatedButton(
            child: Text("Continuar",style: continueButtom),
              onPressed: ((){
                sw.stop();
                evaluateAnswer();
                linkNext(); 
              }),
              style: ElevatedButton.styleFrom(
                primary:kPrimaryColor,
                fixedSize: Size(140*wratio, 50*ratio),
              ),
            ),
            SizedBox(height: 15*ratio),
            TextButton(
              child: Text("Saltar",style: skipButtom),
              onPressed: (){     
                uploadPoints("repetición de oración",widget.resultsname,0); 
                linkNext();
              },
            ),
          ],
        ),
      ),
    );
  }
}