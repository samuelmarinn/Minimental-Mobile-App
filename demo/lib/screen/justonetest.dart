import 'package:demo/additional/constants.dart';
import 'package:demo/screen/inside.dart';
import 'package:flutter/material.dart';

class OneTest extends StatefulWidget {
  final String resultsname;
  final List<String> points;
  final String conclusion;
  final int total;
  final int obtained;
  OneTest(this.resultsname,this.points,this.conclusion,this.total,this.obtained);
  @override
  _OneTestState createState() => _OneTestState();
}

class _OneTestState extends State<OneTest> {
  int total=28;
  List<String> categories=["Orientación","Atención y Concentración","Memoria","Lenguaje","Habilidades Visoconstrutivas"];

  void linkNextPage(){
        Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FirstRoute()),
    );
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
                "RESULTADOS TEST \n"+widget.resultsname,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style:postStatsTitle,
              ),
            ),
            SizedBox(height: 20*ratio),
            Container(
              child: Text(
                "USTED TIENE",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0*ratio),
              ),
            ),
            SizedBox(height: 10*ratio),
            Container(
              child: Text(
                widget.obtained.toString()+"/"+total.toString() +" PUNTOS",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0*ratio,color:drawerMainColor),
              ),
            ),
            SizedBox(height: 20*ratio),
             DataTable(  
              columns: [  
                DataColumn(label: Text(  
                    'Cateogría',  
                    style: TextStyle(fontSize: 18*ratio, fontWeight: FontWeight.bold)  
                )),  
                DataColumn(label: Text(  
                    'Puntaje',  
                    style: TextStyle(fontSize: 18*ratio, fontWeight: FontWeight.bold)  
                )),    
              ],  
              rows: [  
                DataRow(cells: [   
                  DataCell(Text(categories[0])),  
                  DataCell(Text(widget.points[0])),  
                ]),  
                DataRow(cells: [   
                  DataCell(Text(categories[1])),  
                  DataCell(Text(widget.points[1])),  
                ]),    
                DataRow(cells: [   
                  DataCell(Text(categories[2])),  
                  DataCell(Text(widget.points[2])),  
                ]), 
                DataRow(cells: [   
                  DataCell(Text(categories[3])),  
                  DataCell(Text(widget.points[3])),  
                ]),   
                                DataRow(cells: [   
                  DataCell(Text(categories[4])),  
                  DataCell(Text(widget.points[4])),  
                ]),                 
                DataRow(cells: [   
                  DataCell(Text("Total")),  
                  DataCell(Text(widget.obtained.toString())),  
                ]),  
                DataRow(cells: [   
                  DataCell(Text("Conclusión")),  
                  DataCell(Text(widget.conclusion
                     ,style: TextStyle(fontSize: 20*ratio, fontWeight: FontWeight.w900
                    ,color: widget.conclusion=="EN RIESGO DE DETERIORO COGNITIVO" ? Colors.red[600] : Colors.green[600])
                    )
                  ), 
                ]),
              ],  
            ),  
            SizedBox(height: 10*ratio),  
            TextButton(
              child: Text("NOTA: En caso de estar en riesgo de deterioro cognitivo, consultar con especialistas, este test NO es una herramienta de diagnóstico"
                ,style: TextStyle(fontSize: 20*ratio, fontWeight: FontWeight.w900,color: Colors.red[900],fontStyle: FontStyle.italic)
              ),
              onPressed:  (){
                linkNextPage();
              },
            ),
            SizedBox(height: 20*ratio),
            ElevatedButton(
              child: Text("Volver",style: continueButtom),
              onPressed:  (){
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary:kPrimaryColor,
                fixedSize:  Size(140*wratio, 50*ratio),
              ),
            ),
            SizedBox(height:15*ratio),
            TextButton(
              child: Text("Volver a inicio",style: continueButtom),
              onPressed:  (){
                linkNextPage();
              },
              style: ElevatedButton.styleFrom(
                primary:kPrimaryColor,
                fixedSize: Size(240*wratio, 50*ratio),
              ),
            ),
          ],
        ),
      ),
    );
  }
}