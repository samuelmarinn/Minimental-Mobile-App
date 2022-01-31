import 'package:demo/additional/constants.dart';
import 'package:demo/additional/otherfunctions.dart';
import 'package:demo/components/tts.dart';
import 'package:demo/questions/oracion.dart';
import 'package:flutter/material.dart'; 
import 'package:quiver/async.dart';

//se darán 15 segundos por inutrucción

class VerbalQ extends StatefulWidget {
  final String pregunta;
  final String num;
  final String resultsname;
  VerbalQ(this.pregunta,this.num,this.resultsname);
  @override
  _VerbalQState createState() => _VerbalQState();
}

class _VerbalQState extends State<VerbalQ> {
  bool gonext= false;
  Stopwatch sw = new Stopwatch();
  String answer="";
  List<String> instructions =["horizontal","tocar","vertical"];
  var activated=false;
  int points=0;
  String currenttask="";
  bool notActive=false;

  int _start = 30;
  bool timerstarted=false;

  void evaluateAnswer() {
    setState((){
      currenttask=instructions[0];
    });
    bool frist=false;

    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _start),
      new Duration(seconds: 1),
    );
    var sub = countDownTimer.listen(null);
    if (timerstarted==true){
      sub.cancel();
    }
    sub.onData((duration) {

      if (duration.elapsed.inSeconds==0){
        setState(() { 
          timerstarted=true;
        });
      }
      if ((duration.elapsed.inSeconds>=0 && duration.elapsed.inSeconds<20) && (currenttask==instructions[0])){
        Orientation currentOrientation = MediaQuery.of(context).orientation;
        if(currentOrientation == Orientation.landscape && !notActive){
          setState(() {
            points++;
            frist=true;
            currenttask=instructions[1];
          });
        }
      }
      else if ((duration.elapsed.inSeconds>=20 && duration.elapsed.inSeconds<30) || (currenttask==instructions[1]) &&!notActive ){
        setState(() {
          activated=true;
        });
      }
      else if (((duration.elapsed.inSeconds>=30 && duration.elapsed.inSeconds<40) || (currenttask==instructions[2])) && frist ){
        setState(() {
          activated=false;
        });
        Orientation currentOrientation = MediaQuery.of(context).orientation;
        if(currentOrientation == Orientation.portrait && !notActive){
          setState(() {
            points++;
            if (!notActive){
              uploadPoints("instrucción verbal",widget.resultsname,points);
              linkNext();
            }
          });
        }
      }
    });

    sub.onDone(() {
      sub.cancel();
      //enviar puntaje
      if (!notActive){
        uploadPoints("instrucción verbal",widget.resultsname,points);
        linkNext();
      }
    });

  }

  @override
  void initState() {
    super.initState();
    sw.start();
    evaluateAnswer();
  }

  callback(recanswer) {
    setState(() {
      answer = recanswer;
    });
  }


  void linkNext (){ 
    setState(() {
      notActive=true;
    });
    sw.stop();
    int timeanswer =sw.elapsedMilliseconds;
    updatedf(widget.resultsname,"instrucción verbal",timeanswer);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SentenceQ("ESCRIBA, UNA ORACIÓN, SOBRE EL TEMA, QUE USTED QUIERA","PREGUNTA N°17",widget.resultsname)),
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
            GestureDetector(
                onTap: activated == true ? () {
                  setState(() {
                    points++;
                    currenttask=instructions[2];
                  });
                } : null,
                child: Center(
                  child: Container(
                    color: kPrimaryColor,
                    width: 205*wratio,
                    height: 205*ratio,
                    child: Text("") 
                  )
                ),
            ),
            SizedBox(height: 30*ratio),
            TextButton(
              child: Text("Saltar",style: skipButtom),
              onPressed: (){  
                setState(() {
                  notActive=true;
                });
                uploadPoints("instrucción verbal",widget.resultsname,0);
                linkNext();
              },
            ),
          ],
        ),
      ),
    );
  }
}