  
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

var pixelRatio = window.devicePixelRatio;

//Size in logical pixels
var logicalScreenSize = window.physicalSize / pixelRatio;
var logicalWidth = logicalScreenSize.width;
var logicalHeight = logicalScreenSize.height;

double ratio = logicalHeight/803.6363636363636;
double wratio = logicalWidth/392.72727272727275;

TextStyle questionTitle=GoogleFonts.comfortaa(
  textStyle: TextStyle(fontSize: 50*ratio, fontWeight: FontWeight.w900,color: Colors.black)
);
TextStyle noStatsTitle=GoogleFonts.comfortaa(
  textStyle: TextStyle(fontSize: 40*ratio, fontWeight: FontWeight.w800,color: Colors.black)
);
TextStyle postStatsTitle=GoogleFonts.comfortaa(
  textStyle: TextStyle(fontSize: 35*ratio, fontWeight: FontWeight.w800,color: Colors.black)
);
TextStyle skipButtom=GoogleFonts.comfortaa(
  textStyle: TextStyle(fontSize: 20*ratio, fontWeight: FontWeight.w700,color: Colors.redAccent)
);
TextStyle continueButtom=GoogleFonts.comfortaa(
  textStyle: TextStyle(fontSize: 25*ratio, fontWeight: FontWeight.w900,color:Colors.black)
);
TextStyle homeButton=GoogleFonts.comfortaa(
  textStyle: TextStyle(fontSize: 30*ratio, fontWeight: FontWeight.w900,color:Colors.black)
);
TextStyle conditionButton=GoogleFonts.comfortaa(
  textStyle: TextStyle(fontSize: 20*ratio, fontWeight: FontWeight.w600,color:drawerMainColor)
);
TextStyle condtitleButton=GoogleFonts.comfortaa(
  textStyle: TextStyle(fontSize: 20*ratio, fontWeight: FontWeight.w700,color:Colors.black)
);

const backgroundColor = Color(0xFFD6F8F3);
const fieldColor = Color(0xFFAF5F5);
const kPrimaryColor = Color(0xFF8BE5E1);
const kPrimaryLightColor = Color(0xFF77C6C3 );
const textdraw= Colors.white;
const divdraw = Colors.white70;
const drawerMainColor = Color(0xFF1B908B);
const repwords=["pelota", "bandera", "árbol", "palmera","bicicleta","cuchara","manzana","caballo","mesa", "moneda"];
List <String> locs=["Hospital","Casa","Departamento","Oficina","Consultorio","Plaza","No sé"];
const locval=["Hospital","Casa","Departamento","Oficina","Consultorio","Plaza","Otro"];
const floor =["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15"];
const sentence="No hay ni sí, ni no, ni pero";
const kTextFieldDecoration = InputDecoration(
  hintStyle: TextStyle(color: Colors.black),
  contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(7)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(7.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kPrimaryColor, width: 1.5),
    borderRadius: BorderRadius.all(Radius.circular(7)),
  ),
);