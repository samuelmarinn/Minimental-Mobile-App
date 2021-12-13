import 'package:demo/additional/constants.dart';
import 'package:demo/additional/otherfunctions.dart';
import 'package:demo/components/tts.dart';
import 'package:demo/questions/localizacion.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:demo/components/camera_video.dart';

class PlaceQ extends StatefulWidget {
  final String nivel;
  final String pregunta;
  final String num;
  final String resultsname;
  PlaceQ(this.nivel,this.pregunta,this.num,this.resultsname);
  @override
  _PlaceQState createState() => _PlaceQState();
}

class _PlaceQState extends State<PlaceQ> {
  late Position _currentPosition ;
  String _currentCountry = "";
  String _currentLocal = "";
  String _currentRegion = "";
  String answer ="";
  Stopwatch sw = new Stopwatch();

  @override
  void initState() {
    super.initState();
    sw.start();
  }

  _getCurrentLocation() {
    Geolocator
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.best, forceAndroidLocationManager: true)
      .then((Position position) {
        setState(() {
          _currentPosition = position;
          _getAddressFromLatLng();
        });
      }).catchError((e) {
        print(e);
      });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition.latitude,
        _currentPosition.longitude
      );

      Placemark place = placemarks[0];

      setState(() {
        _currentCountry = "${place.country}";
        _currentLocal = "${place.locality}";
        _currentRegion = "${place.administrativeArea}";
      });
    } catch (e) {
      print(e);
    }
  }

  callback(recanswer) {
    setState(() {
      answer = recanswer;
    });
  }

  void evaluateA(){
    _getCurrentLocation();
    String correcta="";
    int points=0;
    if (widget.nivel=="país"){
      correcta=_currentCountry;    
    }
    else if (widget.nivel=="comuna"){
      correcta=_currentLocal;    
    }
    else if (widget.nivel=="region"){
      correcta=_currentRegion;    
    }
    if (answer.contains(correcta)){
      points=1;
    }
    setState(() {
      answer = "";
    });
    //enviar puntos y respuesta a un servidor
    uploadPoints(widget.nivel,widget.resultsname,points); 
  }

  void linkNextPage(){
    sw.stop();
    int timeanswer =sw.elapsedMilliseconds;
    updatedf(widget.resultsname,widget.nivel,timeanswer);
    if (widget.nivel=="país"){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PlaceQ("región","¿EN QUÉ, REGIÓN ESTÁ?","PREGUNTA N°7",widget.resultsname)),
      ); 
    }
    else if (widget.nivel=="región"){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PlaceQ("comuna","¿EN QUÉ, COMUNA ESTÁ?","PREGUNTA N°8",widget.resultsname)),
      ); 
    }
    else if (widget.nivel=="comuna"){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LocQ("lugar","¿EN QUÉ, LUGAR ESTÁ?","PREGUNTA N°9",widget.resultsname)),
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
            VideoRecorderExample(answer, callback,widget.nivel),
            SizedBox(height: 30),
            ElevatedButton(
              child: Text("Continuar",style: continueButtom),
              onPressed:  (){
                sw.stop();
                evaluateA();
                linkNextPage();
              },
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