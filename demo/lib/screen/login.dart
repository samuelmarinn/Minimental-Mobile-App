import 'package:demo/additional/constants.dart';
import 'package:demo/components/buttom.dart';
import 'package:demo/screen/inside.dart';
import 'package:demo/screen/patientform.dart';
import 'package:demo/screen/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  const Body({
    Key? key,
  }) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  bool isloading = false;
  bool hide=true;

  @override
  Widget build(BuildContext context) {
    return Container(
     child: isloading
      ? Center(
          child: CircularProgressIndicator(),
        )
      : Form(
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
                      Text(
                        "Ingresar",
                        style: GoogleFonts.comfortaa(
                          textStyle: TextStyle(fontSize: 50, fontWeight: FontWeight.w900)
                        ),
                      ),
                      SizedBox(height: 60),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          email = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Email vacío. Por favor ingrese email";
                          }
                        },
                        textAlign: TextAlign.center,
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Email',
                          prefixIcon: Icon(
                            Icons.email,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        obscureText: hide,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Contraseña vacía. Por favor ingresar contraseña";
                          }
                        },
                        onChanged: (value) {
                          password = value;
                        },
                        textAlign: TextAlign.center,
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Contraseña',
                          prefixIcon: Icon(
                            Icons.lock,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              hide ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                hide = !hide;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 60),
                      LoginSignupButton(
                        title: 'Ingresar',
                        ontapp: () async {
                          if (formkey.currentState!.validate()) {
                            setState(() {
                              isloading = true;
                            });
                            try {
                              await _auth.signInWithEmailAndPassword(email: email, password: password);
                              var firebaseUser =  FirebaseAuth.instance.currentUser!.displayName;
                              var _fsinst= FirebaseFirestore.instance.collection("usuarios");
                              _fsinst.doc(firebaseUser)
                              .get()
                              .then((doc) async {
                                setState(() {
                                  isloading = false;
                                });
                                if (doc.exists){
                                  SharedPreferences pref = await SharedPreferences.getInstance();
                                  pref.setString("Email", email);
                                  await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (contex) => FirstRoute(),
                                  ));
                                }
                                else {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (contex) => Patient(),
                                  ));
                                }
                              });
                            } on FirebaseAuthException catch (e) {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text("Error"),
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
                              print(e);
                            }
                            setState(() {
                              isloading = false;
                            });
                          }
                        },
                      ),
                      SizedBox(height: 10),
                      Text( "No tengo una cuenta" ,
                      ),
                      GestureDetector(
                        onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return SignUpScreen();
                              },
                            ),
                          )
                        },
                        child: Text("Registrarse",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}


                    







