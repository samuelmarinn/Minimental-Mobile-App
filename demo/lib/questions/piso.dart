import 'package:demo/additional/constants.dart';
import 'package:demo/additional/otherfunctions.dart';
import 'package:demo/components/tts.dart';
import 'package:demo/questions/repeticion.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FloorQ extends StatefulWidget {
  final String pregunta;
  final String num;
  final String resultsname;

  FloorQ(this.pregunta,this.num,this.resultsname);
  @override
  _FloorQState createState() => _FloorQState();
}

class _FloorQState extends State<FloorQ> {
  String answer ="";
  String correcta="";
  Stopwatch sw = new Stopwatch();

  @override
  void initState() {
    super.initState();
    var firebaseUser =  FirebaseAuth.instance.currentUser!.displayName;
    final _store = FirebaseFirestore.instance;
    _store.collection('usuarios').doc(firebaseUser).get().then((document) async {
      var co=await document.data()!["piso"];
      setState((){
        correcta= co;
      });
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
    uploadPoints("piso",widget.resultsname,points);  

    setState(() {
      answer = "";
    });
  }

  void linkNextPage(){
    sw.stop();
    int timeanswer =sw.elapsedMilliseconds;
    updatedf(widget.resultsname,"piso",timeanswer);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RepetitionQ("REPITA, LAS SIGUIENTES, PALABRAS: ","PREGUNTA N°11",widget.resultsname)),
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
            TextField(
              decoration: InputDecoration(
                hintText: "RESPONDA ACÁ",
                  hintStyle: TextStyle(color: Colors.black),
                  contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan, width: 1.5),
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                  ),
              ),
              maxLength: 2,
              keyboardType: TextInputType.number,
              onChanged: (value){
                setState((){
                  answer=value;
                });
              },
            ),
            SizedBox(height: 20),
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
                uploadPoints("piso",widget.resultsname,0); 
                linkNextPage();
              },
            ),
          ],
        ),
      ),
    );
  }
}