//import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:demo/additional/constants.dart';
import 'package:demo/additional/otherfunctions.dart';
import 'package:demo/screen/endoftest.dart';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;

class DrawEv extends StatefulWidget {
  final XFile image;
  final String resultsname;
  final Stopwatch stw;
  DrawEv(this.image,this.resultsname,this.stw);
  @override
  _DrawEvState createState() => _DrawEvState();
}

class _DrawEvState extends State<DrawEv> {

  String answer="";

  @override
  void initState() {
    super.initState();
  }

  Future<void> evaluateAnswer() async {
    uploadPoints("copiar dibujo",widget.resultsname,0); 
  }

  Future<void> linkNext () async {
    widget.stw.stop();
    int timeanswer =widget.stw.elapsedMilliseconds;
    updatedf(widget.resultsname,"dibujo",timeanswer);
    var pList= await pointsPerCategory(widget.resultsname);
    var conclu= await conclusion(pList[1],28,widget.resultsname);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResultsL(widget.resultsname,pList[0],conclu,28,pList[1])),
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
                //evaluar: usar el ocr   
                evaluateAnswer();
                linkNext(); 
              },
              style: ElevatedButton.styleFrom(
                primary:kPrimaryColor,
                fixedSize: Size(250*wratio, 50*ratio),
              ),
            ),
            SizedBox(height: 15*ratio),
            TextButton(
              child: Text("Volver",style: skipButtom,),
              onPressed: (){     
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}