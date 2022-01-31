import 'dart:math';
import 'package:demo/additional/constants.dart';
import 'package:demo/additional/otherfunctions.dart';
import 'package:demo/components/tts.dart';
import 'package:demo/questions/deletreoinv.dart';
import 'package:flutter/material.dart';
import 'package:demo/components/camera_video.dart';

class SubQ extends StatefulWidget {
  final String pregunta;
  final List<String> wordsmemory;
  final String num;
  final String resultsname;
  SubQ(this.pregunta,this.wordsmemory,this.num,this.resultsname);
  @override
  _SubQState createState() => _SubQState();
}

class _SubQState extends State<SubQ> {
  String answer ="";
  Stopwatch sw = new Stopwatch();
  int sta=0;
  int betw =0;
  int cont=0;
  int tp1=0;

  @override
  void initState() {
    super.initState();
    var rng = new Random();
    sta= 70 + rng.nextInt(29);
    betw= rng.nextInt(9);
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
    String aStr = answer.replaceAll(new RegExp(r'[^0-9]'),'');
    if ((sta-betw).toString()==aStr){
      setState((){
        tp1 = tp1 +1;
      });
    }
    setState(() {
      sta = int.parse(answer);
      cont = cont + 1;
      answer="";
    });
    if (cont==5){
      uploadPoints("resta",widget.resultsname,tp1);
      sw.stop();
      int timeanswer =sw.elapsedMilliseconds; 
      updatedf(widget.resultsname,"resta$cont",timeanswer);
      linkNext();
    }
    else {
      sw.stop();
      int timeanswer =sw.elapsedMilliseconds;
      updatedf(widget.resultsname,"resta$cont",timeanswer);
      sw.start();
    }
  }

  void linkNext (){
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SpeQ("DELE TRE E, LA PALABRA, MUNDO, AL RE VEZ",tp1,widget.wordsmemory,"PREGUNTA N°13",widget.resultsname)),
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
            Teteese(widget.pregunta+"\n" + "$sta"+ " menos "+ "$betw",kPrimaryColor),
            SizedBox(height: 30*ratio),
            VideoRecorderExample(answer, callback,"resta $cont"),
            SizedBox(height: 30*ratio),
            ElevatedButton(
            child: Text("Ingresar Respuesta",style: continueButtom),
              onPressed: ((){
                sw.stop();
                evaluateAnswer();
              }),
              style: ElevatedButton.styleFrom(
                primary:kPrimaryColor,
                fixedSize: Size(250*wratio, 50*ratio),
              ),
            ),
            SizedBox(height: 15*ratio),
            TextButton(
              child: Text("Saltar",style: skipButtom),
              onPressed: (){     
                uploadPoints("resta",widget.resultsname,tp1); 
                linkNext();
              },
            ),
          ],
        ),
      ),
    );
  }
}