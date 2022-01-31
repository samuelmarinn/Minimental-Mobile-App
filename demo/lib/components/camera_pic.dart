import 'dart:async';
import 'package:camera/camera.dart';
import 'package:demo/additional/constants.dart';
import 'package:demo/questions/dibujoev.dart';
import 'package:demo/questions/oracionev.dart';
import 'package:flutter/material.dart';

class TakePicScr extends StatefulWidget {
  final CameraDescription camera;
  final  Stopwatch st;
  final String q;
  final String resultsname;

  const TakePicScr({Key? key, required this.st,required this.camera,required this.q,required this.resultsname}) : super(key: key);

  @override
  TakePicScrState createState() => TakePicScrState();
}

class TakePicScrState extends State<TakePicScr> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    //SystemChrome.setEnabledSystemUIMode();
    super.initState();
    // Para visualizar la salida actual de la cámara, es necesario 
    // crear un CameraController.
    _controller = CameraController(
      // Obtén una cámara específica de la lista de cámaras disponibles
      widget.camera,
      // Define la resolución a utilizar
      ResolutionPreset.high,
    );

    // A continuación, debes inicializar el controlador. Esto devuelve un Future!
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Asegúrate de deshacerte del controlador cuando se deshaga del Widget.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children:[
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller);
              } else {
                // De lo contrario, muestra un indicador de carga
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 105.4*ratio,
              width: double.infinity,
              color: Colors.black,
              child: GestureDetector(
                    onTap: () async {
                      await _initializeControllerFuture;
                      var xFile = await _controller.takePicture();

                      //lleva a pag donde se muestra la foto tomada, si se confirma la foto se avanza, si no, se devuelve
                      if (widget.q=="escritura de oraciones"){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SentenceEv(xFile,widget.resultsname)),
                        ); 
                      }
                      else if (widget.q=="dibujo"){
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DrawEv(xFile,widget.resultsname,widget.st)),
                        ); 
                      }
                    },
                    child:
                      Container(
                        //color: Colors.black,
                        height: 60*ratio,
                        width: 60*wratio,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}