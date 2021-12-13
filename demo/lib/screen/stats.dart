import 'package:demo/additional/constants.dart';
import 'package:demo/components/bar.dart';
import 'package:demo/components/navdraw.dart';
import 'package:demo/components/results_linechart.dart';
import 'package:flutter/material.dart';

class Stats extends StatefulWidget {
  final List<Series> chartdata;
  final List<ElevatedButton> blist;
  Stats(this.chartdata,this.blist);
  _StatsState createState() => _StatsState();
}
class _StatsState extends State<Stats> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: Barbarbar(text: "Test Minimental"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.chartdata.length !=0 ? 
          <Widget>[
            Container(
              child: Text(
                "RESUMEN DE \n RESULTADOS",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: noStatsTitle
              ),
            ),
            Container(
              child: Chart(
              title: "puntaje total",
              data: widget.chartdata,
              ),
            ),
            SizedBox(height: 10),
            Container(
              child: Text(
                "Pruebas rendidas",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800
                    ,color:Colors.cyan[600])
              ),
            ),
            Wrap(children: widget.blist),
            SizedBox(height: 30),
            ElevatedButton(
              child: Text("Volver",style: continueButtom),
              onPressed:  (){
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary:kPrimaryColor,
                fixedSize: const Size(140, 50),
              ),
            ),
          ] : 
          <Widget>[
            Container(
              child: Text(
                "NO SE REGISTRAN \n PRUEBAS",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: noStatsTitle,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              child: Text("Volver",style: continueButtom),
              onPressed:  (){
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary:kPrimaryColor,
                fixedSize: const Size(140, 50),
              ),
            ),
          ]
        ),
      ),
    );
  }
}