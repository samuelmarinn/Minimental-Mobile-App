import 'package:demo/additional/constants.dart';
import 'package:demo/additional/otherfunctions.dart';
import 'package:demo/components/tts.dart';
import 'package:demo/questions/dibujo.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:demo/components/camera_video.dart';

class ImageQ extends StatefulWidget {
  final String pregunta;
  final String num;
  final String resultsname;
  ImageQ(this.pregunta,this.num,this.resultsname);
  @override
  _ImageQState createState() => _ImageQState();
}

class _ImageQState extends State<ImageQ> {
  String answer ="";
  var urlclock;
  var urlpen;
  Stopwatch sw = new Stopwatch();
  final FirebaseStorage fb = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    sw.start();
    loadImage("lapiz.png");
    loadImage("reloj.png");
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
    if (answer.contains("lápiz")){
      points++;
    }
    if (answer.contains("reloj")){
      points++;
    }
    uploadPoints("denominación de objetos",widget.resultsname,points); 
  }

  void linkNext (){
    sw.stop();
    int timeanswer =sw.elapsedMilliseconds;
    updatedf(widget.resultsname,"denominacion de objetos",timeanswer);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DrawQ("COPIE LA IMAGEN, QUE SE MUESTRA, EN PANTALLA","PREGUNTA N°20",widget.resultsname)),
    ); 
  }

  loadImage(String imagename) async{
    Reference  ref = fb.ref().child("memory_images").child(imagename);
    var url = await ref.getDownloadURL();
    setState(() {
      if (imagename=="reloj.png"){
        urlclock= url;
      }
      else if(imagename=="lapiz.png"){
        urlpen= url;
      }
    }); 
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
            Row(crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children:  <Widget>[
                urlpen==null ? CircularProgressIndicator() :
                (
                  Container(
                    alignment: Alignment.center,
                    width: 200*wratio,
                    height: 300*ratio,
                    decoration:BoxDecoration(
                      image:DecorationImage(
                        image: NetworkImage(urlpen.toString())
                      )
                    ),
                  )),
                  SizedBox(width: 10*ratio),
                  urlclock==null ? CircularProgressIndicator() : Container(
                    child:Image.network(urlclock.toString(),height: 170.0, width:140,
                    fit: BoxFit.cover,),
                  ),  //
              ],
            ),
            VideoRecorderExample(answer, callback,"denominación de objetos"),
            SizedBox(height: 20*ratio,),
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
                uploadPoints("denominación de objetos",widget.resultsname,0); 
                linkNext();
              },
            ),
          ],
        ),
      ),
    );
  }
}