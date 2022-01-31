import 'package:demo/additional/constants.dart';
import 'package:demo/components/tts.dart';
import 'package:demo/questions/resta.dart';
import 'package:flutter/material.dart';
import 'package:demo/components/camera_video.dart';
import 'package:demo/additional/otherfunctions.dart';

class RepetitionQ extends StatefulWidget {
  final String pregunta;
  final String num;
  final String resultsname;
  RepetitionQ(this.pregunta,this.num,this.resultsname);
  @override
  _RepetitionQState createState() => _RepetitionQState();
}

class _RepetitionQState extends State<RepetitionQ> {
  String answer ="";
  List <int> wordsindex= diffrandoms(3,repwords.length);
  List <String> question = [];
  bool gonext= false;
  int tries=0;
  int firsttotal=0;
  Stopwatch sw = new Stopwatch();

  @override
  void initState() {
    super.initState();
    question= [repwords[wordsindex[0]],repwords[wordsindex[1]],repwords[wordsindex[2]]];
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

  incorrectDialog(BuildContext context) {

    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () { 
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Aviso"),
      content: Text("Por favor responder de nuevo"),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> evaluateAnswer() async {
    tries = tries + 1;
    int points =0;
    var words = answer.split(" ");
    var words2 = words.toSet().toList();
    for(var i=0;i<words2.length;i++){
      if (question.contains(words2[i])){
        points= points +1;
      }
    }
    if (points ==3 || tries==3){
      gonext = true;
      linkNext();

    }
    else {
      //desplegar pantalla diciendo que debe repetirse
      incorrectDialog(context);
    }
    if (tries ==1) {
      firsttotal=points;
    }
    //enviar puntos y respuesta a un servidor
    uploadPoints("repetición $tries",widget.resultsname,points);

    setState(() {
      answer = "";
    });
  }

  void linkNext (){
    sw.stop();
    int timeanswer =sw.elapsedMilliseconds;
    updatedf(widget.resultsname,"repetición",timeanswer);
    updatedf(widget.resultsname,"vecesrepeticion",tries);
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SubQ("RESTE: ",question,"PREGUNTA N°12",widget.resultsname)),
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
            Teteese(widget.pregunta+"..." +question[0] + ", "+ question[1] + ", " + question[2],kPrimaryColor),
            SizedBox(height: 30*ratio),
            VideoRecorderExample(answer, callback,"repetición $tries"),
            SizedBox(height: 30*ratio),
            ElevatedButton(
            child: Text("Ingresar Respuesta",style: continueButtom),
              onPressed: ((){
                evaluateAnswer(); 
              }),
              style: ElevatedButton.styleFrom(
                primary:kPrimaryColor,
                fixedSize:  Size(250*wratio, 50*ratio),
              ),
            ),
            SizedBox(height: 15*ratio),
            TextButton(
              child: Text("Saltar",style: skipButtom),
              onPressed: (){     
                uploadPoints("repetición 1",widget.resultsname,firsttotal); 
                linkNext();
              },
            ),
          ],
        ),
      ),
    );
  }
}