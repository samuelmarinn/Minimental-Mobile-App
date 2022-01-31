import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/additional/constants.dart';
import 'package:demo/additional/otherfunctions.dart';
import 'package:demo/components/bar.dart';
import 'package:demo/components/navdraw.dart';
import 'package:demo/components/prevDataAlert.dart';
import 'package:demo/screen/stats.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class FirstRoute extends StatefulWidget {
    @override
  _FirstRouteState createState() => _FirstRouteState();
}

class _FirstRouteState extends State<FirstRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: Barbarbar(text: "Minimental Versión Móvil"),
      body: Center(
        child: Column( 
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[ 
            Container(
              width: double.infinity,
              height: 70*ratio,
              child: ElevatedButton.icon(
                onPressed: () {  
                  var firebaseUser =  FirebaseAuth.instance.currentUser!.displayName;
                  final _store = FirebaseFirestore.instance;
                  _store.collection('usuarios').doc(firebaseUser).get().then((document) async {
                    String locapp= await document.data()!["lugar de aplicación"];
                    String fl = await document.data()!["piso"];
                    prevData(context, locapp, fl);
                  });
                },
                icon: Icon(
                  Icons.arrow_forward ,
                  color: Colors.black,
                  size: 40.0*ratio,
                ),
                style: ElevatedButton.styleFrom(
                  shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0)),
                  primary: kPrimaryColor,
                  textStyle: TextStyle(
                  fontSize: 30*ratio,
                  fontWeight: FontWeight.bold)
                ),
                label: Text("Realizar test"+"\n Minimental",style: continueButtom),
              ),
            ),
            SizedBox(height: 30*ratio),
            Container(
              width: double.infinity,
              height: 70*ratio,
              child: ElevatedButton.icon(
                onPressed: () async { 
                  var params= await getStats(context); 
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Stats(params[0],params[1])),
                  );
                },
                icon: Icon(
                  Icons.bar_chart_outlined,
                  color: Colors.black,
                  size: 40.0*ratio,
                ),
                style: ElevatedButton.styleFrom(
                  shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0)),
                  primary: kPrimaryLightColor,
                  textStyle: TextStyle(
                  fontSize: 30*ratio,
                  fontWeight: FontWeight.bold)
                ),
                label: Text("Ver resumen"+ "\n de resultados",style: continueButtom),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

