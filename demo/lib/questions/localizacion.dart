import 'package:demo/additional/constants.dart';
import 'package:demo/additional/otherfunctions.dart';
import 'package:demo/components/tts.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'piso.dart';

class LocQ extends StatefulWidget {
  final String nivel;
  final String pregunta;
  final String num;
  final String resultsname;
  LocQ(this.nivel,this.pregunta,this.num,this.resultsname);
  @override
  _LocQState createState() => _LocQState();
}

class _LocQState extends State<LocQ> {
  String answer ="";
  String correcta="";
  List <String> questionops = [];
  Stopwatch sw = new Stopwatch();

  @override
  void initState() {
    super.initState();
    var firebaseUser =  FirebaseAuth.instance.currentUser!.displayName;
    final _store = FirebaseFirestore.instance;
    _store.collection('usuarios').doc(firebaseUser).get().then((document) async {
    correcta= await document.data()!["lugar de aplicación"];
    setState((){
      questionops=List.from(locs);
      questionops.shuffle();},
    );
    if (!questionops.contains(correcta)){
      setState((){
          questionops.add(correcta);
          questionops.shuffle();
        });
      }
    });
    sw.start();
  }

  callback(recanswer) {
    setState(() {
      answer = recanswer;
    });
  }

  Future<void> evaluateA() async {
    int points=0;
    if (answer==correcta){
      points=1;
    }
    //enviar puntos y respuesta a un servidor
    uploadPoints(widget.nivel,widget.resultsname,points);   

    setState(() {
      answer = "";
    });
  }

  void linkNextPage(){
    sw.stop();
    int timeanswer =sw.elapsedMilliseconds;
    updatedf(widget.resultsname,widget.nivel,timeanswer);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FloorQ("¿EN QUÉ, PISO ESTÁ?","PREGUNTA N°10",widget.resultsname)),
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
                style: continueButtom,
              ),
            ),
            SizedBox(height: 10),
            Teteese(widget.pregunta,kPrimaryColor),
            SizedBox(height: 10),
            ...questionops.map((question){
              return Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {  
                    setState((){
                      answer=question;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: answer==question ? Colors.green : Colors.cyan,
                    textStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold)
                  ),
                  child: Text(question),
                  ),
              );
            }).toList(),
            SizedBox(height: 15),
            ElevatedButton(
            child: Text("Continuar",style: continueButtom),
              onPressed: ((){
                sw.stop();
                evaluateA();
                linkNextPage(); 
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
                uploadPoints(widget.nivel,widget.resultsname,0); 
                linkNextPage();
              },
            ),
          ],
        ),
      ),
    );
  }
}