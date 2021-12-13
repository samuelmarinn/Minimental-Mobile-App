import 'package:demo/additional/constants.dart';
import 'package:demo/additional/otherfunctions.dart';
import 'package:demo/components/tts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:demo/components/camera_video.dart';
import 'package:demo/questions/espacio.dart';

class TimeQ extends StatefulWidget {
  final String temporal;
  final String pregunta;
  final String num;
  final String resultsname;
  
  TimeQ(this.temporal,this.pregunta,this.num,this.resultsname);
  @override
  _TimeQState createState() => _TimeQState();
}

class _TimeQState extends State<TimeQ> {
  String answer ="";
  Stopwatch sw = new Stopwatch();

  @override
  void initState() {
    super.initState();
    sw.start();
  }

  callback(recanswer) {
    setState(() {
      answer = recanswer;
    });
  }

  void getAnswer(String a) {
    setState(() {
      answer=a;
    });
  }

  Future<String> getSeason(date) async {
    await initializeDateFormatting(); //very important
    int year = int.parse(DateFormat.y().format(date));
    var fallStart = DateTime(year,3,20,0,0,0,0);
    var winterStart = DateTime(year,6,21,0,0,0,0);
    var springStart = DateTime(year,9,23,0,0,0,0);
    var summerStart = DateTime(year,12,21,0,0,0,0);
    String season = "";
    if (date.isAfter(fallStart) && date.isBefore(winterStart)){
      season ="Otoño";
    }
    else if (date.isAfter(winterStart) && date.isBefore(springStart)){
      season= "Invierno";
    }
    else if (date.isAfter(springStart) && date.isBefore(summerStart)){
      season= "Primavera";
    }
    else{
      season = "Verano";
    }
    return season;
  }

  Future<void> evaluateAnswer() async {
    int points=0;
    String correcta="";
    var now = DateTime.now();
    await initializeDateFormatting(); //very important
    if (widget.temporal=="día"){
      correcta = DateFormat.EEEE('es').format(now);
    }
    else if (widget.temporal=="mes"){
      correcta = DateFormat.MMMM('es').format(now);
    }
    else if (widget.temporal=="año"){
     correcta = DateFormat('y').format(now);
     
    }
    else if (widget.temporal=="día del mes"){
      correcta=DateFormat.d().format(now);
    }
    else if (widget.temporal=="estación"){
      correcta = await getSeason(now);
    }
    if (answer.contains(correcta)){
      points=1;
    }

    uploadPoints(widget.temporal,widget.resultsname,points);
    setState(() {
      answer = "";
    });
  }

  void linkNext (){
  sw.stop();
  int timeanswer =sw.elapsedMilliseconds;
  updatedf(widget.resultsname,widget.temporal,timeanswer);
  if (widget.temporal=="día"){
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => TimeQ("mes", "¿EN QUÉ, MES ESTAMOS?","PREGUNTA N°2",widget.resultsname)),
    ); 
  }
  else if (widget.temporal=="mes"){
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => TimeQ("día del mes", "¿EN QUÉ, DÍA DEL MES ESTAMOS?","PREGUNTA N°3",widget.resultsname)),
    ); 
  }
  else if (widget.temporal=="día del mes"){
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => TimeQ("año", "¿EN QUÉ, AÑO ESTAMOS?","PREGUNTA N°4",widget.resultsname)),
    ); 
  } 
  else if (widget.temporal=="año"){
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => TimeQ("estación", "¿EN QUÉ, ESTACIÓN ESTAMOS?","PREGUNTA N°5",widget.resultsname)),
    ); 
  }     
  else if (widget.temporal=="estación"){
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => PlaceQ("país", "¿EN QUÉ, PAÍS ESTÁ?","PREGUNTA N°6",widget.resultsname)),
    ); 
  } 
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
            VideoRecorderExample(answer, callback,widget.temporal),
            SizedBox(height: 30),
            ElevatedButton(
            child: Text("Continuar",style: continueButtom),
              onPressed: ((){
                evaluateAnswer();
                linkNext(); 
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
                uploadPoints(widget.temporal,widget.resultsname,0); 
                linkNext();
              },
            ),
          ],
        ),
      ),
    );
  }
}