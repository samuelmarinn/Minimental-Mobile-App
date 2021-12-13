import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/additional/constants.dart';
import 'package:demo/components/results_linechart.dart';
import 'package:demo/screen/justonetest.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:number_to_words/number_to_words.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:translator/translator.dart';
import 'package:http/http.dart' as http;

//funcion que convierte un número a letras en español pasandolo primero a inglés, luego a español
Future<String> numbertowordsp(number) async {
  final translator = GoogleTranslator();
  var eng = NumberToWord().convert('en-in',number);
  print(eng);
  var tra = await translator.translate(eng, from: 'en', to: 'es');
  return tra.toString();
}

bool isNumeric(String s) {
 if (s == " ") {
   return false;
 }
 return double.tryParse(s) != null;
}

List<int> diffrandoms(int n,int options){
  var random = Random();
  List <int> numbers= [random.nextInt(options)];
  while (numbers.length!=n){
    int a= random.nextInt(options);
    if (!numbers.contains(a)){
      numbers.add(a);
    }
  }
  return numbers;
}

void uploadPoints(String qname,String d,var p){
final _store = FirebaseFirestore.instance;
var firebaseUser =  FirebaseAuth.instance.currentUser!.displayName;
_store.collection("usuarios").doc(firebaseUser).collection("Pruebas").doc(d).set(
  {
    qname : p,
  }, SetOptions(merge: true));
}

Future<void> createrowdf(var date, var birth, var education ) async {
  var up = Uri.parse('http://storagemm.pythonanywhere.com/updatedfini');
  final date2 = DateTime.now();
  var years= date2.difference(birth!).inDays~/365;
  await http.post(up,headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  },
  body: jsonEncode(<String, String>{
    'date': date,
    'age': years.toString(),
    'education': education,
  }));
}

Future<void> updatedf(var date, var column, var val ) async {
  var up = Uri.parse('http://storagemm.pythonanywhere.com/updatedftime');
  await http.post(up,headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  },
  body: jsonEncode(<String, String>{
    'date': date,
    'column': column,
    'value': val.toString(),
  }));
}

Future<List> pointsPerCategory(String results) async {
  final firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser =  FirebaseAuth.instance.currentUser!.displayName;
  List <String> points=[];
  var obtained=0;
  var value = await firestoreInstance.collection("usuarios").doc(firebaseUser).collection("Pruebas").doc(results).get();
  if (value.exists){
    var dt=value.data();
    var pLoc=dt!["día"].toInt()+dt["mes"].toInt()+dt["día del mes"].toInt()+dt["año"].toInt()+dt["estación"].toInt()+dt["país"].toInt()+dt["región"].toInt()+dt["comuna"].toInt()+dt["lugar"].toInt()+dt["piso"].toInt();
    points.add(pLoc.toString());
    obtained+=pLoc as int;
    var pta="0";
    if (dt["resta"].toInt()>dt["deletreo inverso"].toInt()){
        pta=dt["resta"].toString();
        obtained+=dt["resta"].toInt() as int ;
    }
    else{
      pta=dt["deletreo inverso"].toString();
      obtained+=dt["deletreo inverso"].toInt() as int ;
    }
    points.add((dt["repetición 1"].toInt()+int.parse(pta)).toString());
    obtained+=dt["repetición 1"].toInt() as int;
    points.add(dt["memoria"].toString());
    obtained+=dt["memoria"].toInt() as int;
    points.add((dt["instrucción verbal"].toInt()+dt["instrucción escrita"].toInt()+dt["escritura de oración"].toInt()+dt["repetición de oración"].toInt()+dt["denominación de objetos"].toInt()).toString());
    obtained+=(dt["instrucción verbal"].toInt()+dt["instrucción escrita"].toInt()+dt["escritura de oración"].toInt()+dt["repetición de oración"].toInt()+dt["denominación de objetos"].toInt()) as int;
    points.add(dt["copiar dibujo"].toString());
    obtained+=dt["copiar dibujo"].toInt() as int;
    if (!dt.containsKey('Total')){
      uploadPoints("Total",results, obtained);
    }
  }
  return [points,obtained];
}

Future<String> conclusion(int gotit,int original, var results) async {
  final firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser =  FirebaseAuth.instance.currentUser!.displayName;
  String conclusion="";
  var value= await firestoreInstance.collection("usuarios").doc(firebaseUser).get();
  if (value.exists){
    int min=0;
    final date2 = DateTime.now();
    var dat=value.data();
    var years= date2.difference(dat!["fecha de nacimiento"].toDate()).inDays~/365;
    if (dat["años de educación"].toString()=="0-4" && years <41){
      min=9999;
    }
    else if (dat["años de educación"].toString()=="0-4" && years <61){
      min=18;
    }
    else if (dat["años de educación"].toString()=="0-4"){
      min=20;
    }
    else if (dat["años de educación"].toString()=="5-8" && years <41){
      min=26;
    }
    else if ((dat["años de educación"].toString()=="5-8" && years <61) ||(dat["años de educación"].toString()=="9-12" && 40<years )){
      min=27;
    }
    else if (dat["años de educación"].toString()=="5-8" ){
      min=23;
    }
    else if ((dat["años de educación"].toString()=="9-12" && years <41) ||(dat["años de educación"].toString()=="más de 12" && 61<years )){
      min=28;
    }
    else if ((dat["años de educación"].toString()=="más de 12" && years <61) ){
      min=29;
    }
    if (gotit<=min-(30-original)){
      conclusion="EN RIESGO DE DETERIORO COGNITIVO";
    }
    else {
      conclusion="SIN RIESGO DE DETERIORO COGNITIVO";
    }
    if (!dat.containsKey('Conclusión')){
      uploadPoints("Conclusión",results, conclusion);
    }
  }

  return conclusion;
}

Future<List> getStats(var context) async {
  final List<Series> data = [];
  List<ElevatedButton> buttonsList = [];

  final firestoreInstance = FirebaseFirestore.instance;
  final firebaseUser =  FirebaseAuth.instance.currentUser!.displayName;
  var querySnapshot =   await firestoreInstance.collection("usuarios").doc(firebaseUser).collection("Pruebas").get();
  querySnapshot.docs.forEach((result) async {
    if (result.exists){
      var dt=result.data();
      var name=result.reference.id;
      var dat=DateTime.parse(name);
      Series toadd=Series(date:dat,points:dt["Total"].toInt());
      data.add(toadd);
      var pList= await pointsPerCategory(name);
      var conclu= dt["Conclusión"].toString();
      buttonsList.add(new ElevatedButton(
        onPressed: (){  
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OneTest(name,pList[0],conclu,28,pList[1])),
          );    
        }
        ,style: ElevatedButton.styleFrom(
          primary:kPrimaryColor,
          fixedSize: const Size(140, 50),
        ),
        child: Text(name)
      ));
    }
  });
  return [data, buttonsList];
}