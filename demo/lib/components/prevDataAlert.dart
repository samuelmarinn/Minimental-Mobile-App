import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/additional/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:demo/screen/instructions.dart';

prevData(BuildContext context,String loc,String floor) {
  String newfl="";
  String newloc="";
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
      var firebaseUser =  FirebaseAuth.instance.currentUser!.displayName;
      final _store = FirebaseFirestore.instance;
      if (newfl!="" && newfl!=""){
        _store.collection("usuarios").doc(firebaseUser).update(
        {
          "lugar de aplicación": newloc,
          "piso" : newfl,
        });  
      } 
      else if (newloc!=""){
        _store.collection("usuarios").doc(firebaseUser).update(
        {
          "lugar de aplicación": newloc,
        });  
      }
      else if (newfl!=""){
        _store.collection("usuarios").doc(firebaseUser).update(
        {
          "piso" : newfl,
        });  
      }             
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InstructionsScreen()),
      );
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Confirme ubicación actual y piso",style:condtitleButton),
    content: Stack(
      clipBehavior: Clip.none
      , children: <Widget>[
        Text("Presione 'Continuar' si los datos son correctos. Modifíquelos de ser necesario"),
        
        Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 40*ratio),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  onChanged: (value) {
                    newloc = value;
                  },
                  decoration: InputDecoration(
                    labelText: "Lugar Actual",
                    hintText: loc,
                    focusColor: kPrimaryColor,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  onChanged: (value) {
                    newfl = value;
                  },
                  decoration: InputDecoration(
                    hintText: floor,
                    labelText: "Piso",
                    focusColor: kPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
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