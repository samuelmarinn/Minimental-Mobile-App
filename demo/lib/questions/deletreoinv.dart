import 'package:demo/additional/constants.dart';
import 'package:demo/additional/otherfunctions.dart';
import 'package:demo/components/tts.dart';
import 'package:demo/questions/memoria.dart';
import 'package:flutter/material.dart';
import 'package:demo/components/camera_video.dart';

class SpeQ extends StatefulWidget {
  final String pregunta;
  final int pointssub;
  final List<String> ws;
  String num;
  final String resultsname;
  SpeQ(this.pregunta,this.pointssub,this.ws,this.num,this.resultsname);
  @override
  _SpeQState createState() => _SpeQState();
}

class _SpeQState extends State<SpeQ> {
  String answer ="";
  Stopwatch sw = new Stopwatch();
  List<String> phrase = ["O","D","N","U","M"];

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
    var validation= answer.split(" ");
    for ( var i = 0 ; i <= validation.length; i++){
      if (validation[i].length==1 && validation[i]==phrase[i]){
        setState((){
          points++;
        });
      }
    }
    uploadPoints("deletreo inverso",widget.resultsname,points);
  }

  void linkNext (){
    sw.stop();
    int timeanswer =sw.elapsedMilliseconds;
    updatedf(widget.resultsname,"deletreo inverso",timeanswer);
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => MemoryQ("REPITA, LAS PALABRAS, QUE MEMORIZÓ, ANTES: ",widget.ws,"PREGUNTA N°14",widget.resultsname)),
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
            SizedBox(height: 30),
            Teteese(widget.pregunta,kPrimaryColor),
            SizedBox(height: 30),
            VideoRecorderExample(answer, callback,"deletreo inverso"),
            SizedBox(height: 30),
            ElevatedButton(
            child: Text("Continuar",style: continueButtom),
              onPressed: ((){
                sw.stop();
                evaluateAnswer();
                linkNext(); 
              }),
              style: ElevatedButton.styleFrom(
                primary:kPrimaryColor,
                fixedSize: const Size(140, 50),
              ),
            ),
            SizedBox(height: 15),
            TextButton(
              child: Text("Saltar",style: skipButtom),
              onPressed: (){     
                uploadPoints("deletreo inverso",widget.resultsname,0); 
                linkNext();
              },
            ),
          ],
        ),
      ),
    );
  }
}