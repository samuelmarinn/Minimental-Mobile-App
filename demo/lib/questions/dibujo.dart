import 'package:camera/camera.dart';
import 'package:demo/additional/constants.dart';
import 'package:demo/additional/otherfunctions.dart';
import 'package:demo/components/camera_pic.dart';
import 'package:demo/components/tts.dart';
import 'package:demo/screen/endoftest.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DrawQ extends StatefulWidget {
  final String pregunta;
  final String num;
  final String resultsname;
  DrawQ(this.pregunta,this.num,this.resultsname);
  @override
  _DrawQState createState() => _DrawQState();
}

class _DrawQState extends State<DrawQ> {
  Stopwatch sw = new Stopwatch();
  final FirebaseStorage fb = FirebaseStorage.instance;
  var urlpentagon;

  @override
  void initState() {
    super.initState();
    sw.start();
    loadImage("pentagon.png");
  }

  loadImage(String imagename) async{
    Reference  ref = fb.ref().child("draw_images").child(imagename);
    var url = await ref.getDownloadURL();
    setState(() {
      urlpentagon= url;
    }); 
  }

  Future<void> linkNext () async {
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
                urlpentagon==null ? CircularProgressIndicator() :
                (
                  Container(
                    alignment: Alignment.center,
                    width: 200,
                    height: 300,
                    decoration:BoxDecoration(
                      image:DecorationImage(
                        image: NetworkImage(urlpentagon.toString())
                      )
                    ),
                  )
                ),  //
              ],
            ),
            ElevatedButton(
              child: Text("Tomar Foto",style: continueButtom),
              onPressed: () async { 
                final cameras = await availableCameras();
                final firstCamera = cameras[0];    
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TakePicScr(st: sw,camera: firstCamera,q: "dibujo",resultsname: widget.resultsname)),
                ); 
              },
              style: ElevatedButton.styleFrom(
                primary:kPrimaryColor,
                fixedSize: Size(180*wratio, 50*ratio),
              ),
            ),
            SizedBox(height: 15*ratio),
            TextButton(
              child: Text("Saltar",style: skipButtom),
              onPressed: (){     
                uploadPoints("copiar dibujo",widget.resultsname,0); 
                linkNext();
              },
            ),
          ],
        ),
      ),
    );
  }
}