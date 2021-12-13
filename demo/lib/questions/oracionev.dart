//import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:demo/additional/constants.dart';
import 'package:demo/additional/otherfunctions.dart';
import 'package:demo/questions/reporacion.dart';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;

class SentenceEv extends StatefulWidget {
  final XFile image;
  String resultsname;
  SentenceEv(this.image,this.resultsname);
  @override
  _SentenceEvState createState() => _SentenceEvState();
}

class _SentenceEvState extends State<SentenceEv> {

  String answer="";

  @override
  void initState() {
    super.initState();
  }

  Future<void> evaluateAnswer() async {
    /*var bytes = File(widget.image.path.toString()).readAsBytesSync();
    String img64 = base64Encode(bytes);
    var url = Uri.parse('https://api.ocr.space/parse/image');
    var payload = {"base64Image": "data:image/jpg;base64,${img64.toString()}"};
    var header = {"apikey": "8c7b44284588957"};
    //faltaría verlo en español
    var post = await http.post(url=url,body: payload,headers: header);
    var result = jsonDecode(post.body);
    setState(() {
      answer = result['ParsedResults'][0]['ParsedText'];
    });*/
    uploadPoints("escritura de oración",widget.resultsname,0);
  }

  void linkNext (){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RepsenQ("REPITA, LA SIGUIENTE ORACIÓN: No hay ni sí, ni no, ni pero","PREGUNTA N° 18",widget.resultsname)),
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
              width: 300,
              height: 400,
              child: Image.file(File(widget.image.path), fit: BoxFit.cover),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              child: Text("Ingrsar Respuesta",style: continueButtom),
              onPressed: (){  
                //evaluar: usar el ocr   
                evaluateAnswer(); 
                linkNext ();
              },
              style: ElevatedButton.styleFrom(
                primary:kPrimaryColor,
                fixedSize: const Size(250, 50),
              ),
            ),
            SizedBox(height: 15),
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