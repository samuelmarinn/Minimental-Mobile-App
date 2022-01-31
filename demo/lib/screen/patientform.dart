import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/additional/otherfunctions.dart';
import 'package:demo/components/buttom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:demo/additional/constants.dart';
import 'package:demo/screen/inside.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Patient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PatientReg(),
    );
  }
}

class PatientReg extends StatefulWidget {
  @override
  _PatientRegState createState() => _PatientRegState();
}

class _PatientRegState extends State<PatientReg> {
  final formkey = GlobalKey<FormState>();
  final _store = FirebaseFirestore.instance;
  String email = '';
  String patientname=" ";
  String lastnamepa=" ";
  String lastnamema=" ";
  DateTime birthdate= DateTime.now();
  String strdate= " ";
  String edlevel= " ";
  String hdh= " ";
  String floor = " ";
  String laboryears= " ";
  List<String> edlevelval = ["0-4","5-8","9-12","más de 12"];
  bool isloading = false;
  bool hide=true;
  TextEditingController _dateController = TextEditingController();

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        locale : const Locale("es","ES"),
        initialDate: birthdate,
        firstDate: DateTime(1910),
        lastDate: DateTime.now(),
        
      );
    if (picked != null && picked != birthdate){
      setState(() {
        birthdate = picked;
        var date =
          "${picked.toLocal().day}/${picked.toLocal().month}/${picked.toLocal().year}";
      _dateController.text = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPrimaryLightColor,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            isloading
          ? Center(
              child: CircularProgressIndicator(),
            ):Form(
              key: formkey,
              child: Stack(
                children: [
                  Container(
                    child: SingleChildScrollView(
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 120),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Hero(
                            tag: '1',
                            child: Text(
                              "Antes de seguir, ingrese datos del paciente (posteriormente podrán ser cambiados)",
                            style: GoogleFonts.comfortaa(
                                textStyle: TextStyle(fontSize: 30*ratio, fontWeight: FontWeight.w700)
                              ),
                            ),
                          ),
                          SizedBox(height: 30*ratio),
                          TextFormField(
                            onChanged: (value) {
                              patientname = value.toString().trim();
                            },
                            validator: (value) => (value!.isEmpty)
                                ? 'Campo vacío. Ingresa un nombre'
                                : null,
                            textAlign: TextAlign.center,
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Nombres',
                              fillColor: backgroundColor,
                              filled: true,
                            ),
                          ),
                          SizedBox(height: 10*ratio),
                          Row(
                            children: <Widget>[ 
                              new Flexible(
                                child: TextFormField(
                                  onChanged: (value) {
                                    lastnamepa = value.toString().trim();
                                  },
                                  validator: (value) => (value!.isEmpty)
                                      ? 'Campo vacío.'
                                      : null,
                                  textAlign: TextAlign.center,
                                  decoration: kTextFieldDecoration.copyWith(
                                    hintText: 'Apellido Paterno',  
                                    fillColor: backgroundColor,
                                    filled: true,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10*wratio),
                              new Flexible(
                                child: TextFormField(
                                  onChanged: (value) {
                                    lastnamema = value.toString().trim();
                                  },
                                  validator: (value) => (value!.isEmpty)
                                      ? 'Campo vacío. '
                                      : null,
                                  textAlign: TextAlign.center,
                                  decoration: kTextFieldDecoration.copyWith(
                                    hintText: 'Apellido Materno',
                                    fillColor: backgroundColor,
                                    filled: true,
                                  ),
                                ),
                              ),
                            ]
                          ),
                          SizedBox(height: 10*ratio),
                          TextFormField(
                            onTap: () async {
                              FocusScope.of(context).requestFocus(new FocusNode());
                              _selectDate(context);
                              _dateController.text = DateFormat('dd/MM/yyyy').format(birthdate);
                            } ,
                            controller: _dateController,
                            keyboardType: TextInputType.datetime,
                            validator: (String? value){
                              if (value!.isEmpty) {
                                return 'Campo vacío. Por favor seleccionar una fecha.';
                              }
                              return null;
                            },
                            onSaved: (val) {
                              strdate = birthdate.toString();
                            },
                            textAlign: TextAlign.center,
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Fecha De Nacimiento',
                              fillColor: backgroundColor,
                              filled: true,
                            ),
                          ),  
                          SizedBox(height: 10*ratio),
                          DropdownButtonFormField(
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Nivel Educacional',
                              fillColor: backgroundColor,
                              filled: true,
                            ),
                            isExpanded: true,
                            onChanged: (String? value) {
                              setState(() {
                                  edlevel = value!;
                              });
                            },
                            onSaved: (String? value) {
                              setState(() {
                                  edlevel = value!;
                              });
                            },
                            validator: (String? value) =>(value!.isEmpty)
                               ? "Campo vacío. Por favor seleccionar una opción"
                               : null,
                            items: edlevelval.map((edlevelval) {
                              return DropdownMenuItem(
                                value: edlevelval,
                                child: Text(
                                  edlevelval,                   
                                ),
                              );
                            }).toList(),
                          ),                       
                          SizedBox(height: 10*ratio),            
                          TextFormField(
                            onChanged: (value) {
                              laboryears = value.toString().trim();
                            },
                            keyboardType: TextInputType.number,
                            validator: (value) => (value!.isEmpty|| !isNumeric(value))
                                ? 'Campo inválido. Por favor ingresar un valor válido'
                                : null,
                            textAlign: TextAlign.center,
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Años de servicio (ej: 20)',
                              fillColor: backgroundColor,
                              filled: true,
                            ),
                          ),
                          SizedBox(height: 10*ratio),
                          DropdownButtonFormField(
                            //value: locval[0],
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Lugar Actual',
                              fillColor: backgroundColor,
                              filled: true,
                            ),
                            isExpanded: true,
                            onChanged: (String? value) {
                              setState(() {
                                  hdh = value!;
                              });
                            },
                            onSaved: (String? value) {
                              setState(() {
                                  hdh = value!;
                              });
                            },
                            validator: (String? value) =>(value!.isEmpty)
                               ? "Campo vacío. Por favor seleccionar una opción"
                               : null,
                            items: locval.map((locval) {
                              return DropdownMenuItem(
                                value: locval,
                                child: Text(
                                  locval,                   
                                ),
                              );
                            }).toList(),
                          ),                          
                          SizedBox(height: 10*ratio),                          
                          TextFormField(
                            onChanged: (value) {
                              floor = value.toString().trim();
                            },
                            keyboardType: TextInputType.number,
                            validator: (value) => (value!.isEmpty || !isNumeric(value))
                                ? 'Campo inválido. Por favor ingresar un valor válido'
                                : null,
                            textAlign: TextAlign.center,
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Piso (ej: 1,2, etc)',
                              fillColor: backgroundColor,
                              filled: true,
                            ),
                          ),
                          SizedBox(height: 10*ratio),
                          LoginSignupButton(
                            title: 'Guardar',
                            ontapp: () async {
                              if (formkey.currentState!.validate()) {
                                setState(() {
                                  isloading = true;
                                });
                                try {
                                  var firebaseUser =  FirebaseAuth.instance.currentUser!.displayName;
                                  _store.collection("usuarios").doc(firebaseUser).set(
                                  {
                                    "nombre" : patientname + " "+ lastnamepa+ " " + lastnamema,
                                    "fecha de nacimiento" : birthdate,
                                    "años de educación" : edlevel,
                                    "años de servicio" : laboryears,
                                    "lugar de aplicación": hdh,
                                    "piso" : floor,
                                  });
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (contex) => FirstRoute(),
                                  ));
                                  setState(() {
                                    isloading = false;
                                  });
                                } on FirebaseException catch (e) {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title:
                                          Text('Ingreso de datos de paciente fallido'),
                                      content: Text('${e.message}'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Text('Ok'),
                                        )
                                      ],
                                    ),
                                  );
                                }
                                setState(() {
                                  isloading = false;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
