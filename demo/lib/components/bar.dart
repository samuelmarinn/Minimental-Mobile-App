import 'package:flutter/material.dart';
import 'package:demo/additional/constants.dart';


class Barbarbar extends StatelessWidget implements PreferredSizeWidget{
  final String text;
  Barbarbar({required this.text});

  @override 
   Widget build(BuildContext context) {
     return AppBar(
       title: Text(text,style: TextStyle(color: Colors.black),),
        backgroundColor: kPrimaryColor,
     );
   }

@override
    final Size preferredSize=Size.fromHeight(kToolbarHeight);
}