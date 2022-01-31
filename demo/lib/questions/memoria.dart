import 'package:demo/additional/constants.dart';
import 'package:demo/additional/otherfunctions.dart';
import 'package:demo/components/tts.dart';
import 'package:demo/questions/ojos.dart';
import 'package:flutter/material.dart';
import 'package:demo/components/camera_video.dart';

class MemoryQ extends StatefulWidget {
  final String pregunta;
  final List<String> wordss;
  final String num;
  final String resultsname;

  MemoryQ(this.pregunta,this.wordss,this.num,this.resultsname);
  @override
  _MemoryQState createState() => _MemoryQState();
}

class _MemoryQState extends State<MemoryQ> {
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
    int points =0;
    var words = answer.split(" ");
    var words2 = words.toSet().toList();
    for(var i=0;i<words2.length;i++){
      if (widget.wordss.contains(words2[i])){
        points= points +1;
      }
    }

    uploadPoints("memoria",widget.resultsname,points);
  }

  void linkNext (){
    sw.stop();
    int timeanswer =sw.elapsedMilliseconds;
    updatedf(widget.resultsname,"memoria",timeanswer);
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => EyesQ("HAGA CLICK, Y CIERRE LOS OJOS, CUANDO EL CONTADOR, LLEGUE A 0","PREGUNTA N°15",widget.resultsname)),
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
            VideoRecorderExample(answer, callback,"memoria"),
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
                uploadPoints("memoria",widget.resultsname,0); 
                linkNext();
              },
            ),
          ],
        ),
      ),
    );
  }
}