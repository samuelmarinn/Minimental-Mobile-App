import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Teteese extends StatefulWidget {
  final String pregunta;
  final Color col;
  Teteese(this.pregunta,this.col);
  @override
  TeteeseState createState() => TeteeseState();
}

class TeteeseState extends State<Teteese> {
  final FlutterTts tts = FlutterTts();

  @override
  void initState() {
  super.initState();
  tts.setLanguage('es');
  tts.setSpeechRate(0.3);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        tts.speak(widget.pregunta);
      },
      child: CircleAvatar(  
        radius: 70.0,
        backgroundColor: widget.col,
        child:Icon(
          Icons.volume_up,
          color: Color(0xFF3CB0AB),
          size: 100.0,
        ),
      ),
    );
  }
}