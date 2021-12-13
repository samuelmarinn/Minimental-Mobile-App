import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/additional/constants.dart';
import 'package:demo/additional/otherfunctions.dart';
import 'package:demo/questions/tiempo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class InstructionsScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[ 
            Container(
              child: Text(
                "Instrucciones",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: questionTitle,
              ),
            ),
            SizedBox(height: 30),
            Container(
              alignment: Alignment.topCenter,
              width: 300,
              height: 350,
              decoration: BoxDecoration(
                color: Colors.white38,
              ),
              child: Text('Responda las preguntas que se le presentan a continuación. Haga click en el ícono de volúmen para escuchar la pregunta, y responda según corresponda. \n \nEn las preguntas donde deba responder con video, debe hacer click en el ícono verde para comenzar a grabar, y en el ícono rojo para detener'
              ,style:TextStyle(fontSize: 25)),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              child: Text("Continuar",style:continueButtom),
              onPressed: () {
                conditionsBefore(context);
              },
              style: ElevatedButton.styleFrom(
                primary:kPrimaryColor,
                fixedSize: const Size(140, 50),
              ),
            ),
          ],
        )
      ),
    );
  }
}

conditionsBefore(BuildContext context) {

  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Cancelar",style: conditionButton),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: Text("Continuar",style: conditionButton),
    onPressed:  () {            
      final firestoreInstance = FirebaseFirestore.instance;
      var firebaseUser =  FirebaseAuth.instance.currentUser!.displayName;
      DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
      String nownow= dateFormat.format(DateTime.now());
      firestoreInstance
      .collection("usuarios")
      .doc(firebaseUser)
      .get()
      .then((value) async {
        var dat=value.data();
        await createrowdf(nownow,dat!["fecha de nacimiento"].toDate(),dat["años de educación"]);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TimeQ("día","¿QUÉ DÍA, ES HOY?","PREGUNTA N°1",nownow)),
        );
      });
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Términos y condiciones",style:condtitleButton),
    content: Text("Al realizar este test, sus respuestas serán guardadas de forma anónima. Al pulsar 'Continuar', usted nos entrega su consentimiento para recolectar estos datos"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}