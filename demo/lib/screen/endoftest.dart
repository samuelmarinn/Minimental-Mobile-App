
import 'package:demo/additional/constants.dart';
import 'package:demo/screen/inside.dart';
import 'package:flutter/material.dart';

class ResultsL extends StatefulWidget {
  final String resultsname;
  final List<String> pointsList;
  final String conclusion;
  final int total;
  final int obtained;
  ResultsL(this.resultsname,this.pointsList,this.conclusion,this.total,this.obtained);
  @override
  _ResultsLState createState() => _ResultsLState();
}

class _ResultsLState extends State<ResultsL> {
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
                "RESULTADOS",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: questionTitle,
              ),
            ),
            SizedBox(height: 30*ratio),
            Container(
              child: Text(
                "USTED TIENE",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0*ratio),
              ),
            ),
            SizedBox(height: 15*ratio),
            Container(
              child: Text(
                widget.obtained.toString() + "/" + widget.total.toString() +" PUNTOS",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0*ratio,color:drawerMainColor),
              ),
            ),
            SizedBox(height: 30*ratio),
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
                  DataCell(Text(widget.pointsList[0])),  
                ]),  
                DataRow(cells: [   
                  DataCell(Text(categories[1])),  
                  DataCell(Text(widget.pointsList[1])),  
                ]),    
                DataRow(cells: [   
                  DataCell(Text(categories[2])),  
                  DataCell(Text(widget.pointsList[2])),  
                ]), 
                DataRow(cells: [   
                  DataCell(Text(categories[3])),  
                  DataCell(Text(widget.pointsList[3])),  
                ]),   
                                DataRow(cells: [   
                  DataCell(Text(categories[4])),  
                  DataCell(Text(widget.pointsList[4])),  
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
            SizedBox(height: 10),  
            TextButton(
              child: Text("NOTA: En caso de estar en riesgo de deterioro cognitivo, consultar con especialistas, este test NO es una herramienta de diagnóstico"
                ,style: TextStyle(fontSize: 20*ratio, fontWeight: FontWeight.w900,color: Colors.red[900],fontStyle: FontStyle.italic)
              ),
              onPressed:  (){
                linkNextPage();
              },
            ),
            SizedBox(height: 30*ratio),
            ElevatedButton(
              child: Text("Finalizar",style: continueButtom),
              onPressed:  (){
                linkNextPage();
              },
              style: ElevatedButton.styleFrom(
                primary:kPrimaryColor,
                fixedSize: Size(140*wratio, 50*ratio),
              ),
            ),
          ],
        ),
      ),
    );
  }
}