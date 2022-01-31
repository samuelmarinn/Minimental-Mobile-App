import 'package:demo/components/buttom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:demo/additional/constants.dart';
import 'package:demo/screen/login.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  String username=" ";
  bool isloading = false;
  bool hide=true;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                              "Crear Cuenta",
                              textAlign: TextAlign.left,
                              style: GoogleFonts.comfortaa(
                                textStyle: TextStyle(fontSize: 50*ratio, fontWeight: FontWeight.w900)
                              ),
                            ),
                          ),
                          SizedBox(height: 40*ratio),
                          TextFormField(
                            onChanged: (value) {
                              username = value.toString().trim();
                            },
                            validator: (value) => (value!.isEmpty)
                                ? 'Campo vacío. Ingresa un nombre'
                                : null,
                            textAlign: TextAlign.center,
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Nombre de usuario',
                              prefixIcon: Icon(
                                Icons.person
                              ),
                            ),
                          ),
                          SizedBox(height: 15/ratio),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              email = value.toString().trim();
                            },
                            validator: (value) => (value!.isEmpty)
                                ? 'Campo vacío. Ingresa un mail'
                                : null,
                            textAlign: TextAlign.center,
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Email: (ejemplo: ejemplo@gmail.com)',
                              prefixIcon: Icon(
                                Icons.email,
                              ),
                            ),
                          ),
                          SizedBox(height: 15*ratio),
                          TextFormField(
                            obscureText: hide,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Campo Vacío. Ingresa una contraseña";
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
                          SizedBox(height: 15*ratio),
                          TextFormField(
                            obscureText: hide,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Campo vacío. Ingrese contraseña";
                              }
                              if (value != password){
                                return "Las contraseñas no coinciden";
                              }
                            },
                            textAlign: TextAlign.center,
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Confirmar contraseña',
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
                          SizedBox(height: 25*ratio),
                          Text( "Ya tengo una cuenta" ,
                          ),
                          GestureDetector(
                            onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return LoginScreen();
                                  },
                                ),
                              )
                            },
                            child: Text("Ingresar",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 10*ratio),
                          LoginSignupButton(
                            title: 'Registrarse',
                            ontapp: () async {
                              if (formkey.currentState!.validate()) {
                                setState(() {
                                  isloading = true;
                                });
                                try {
                                  UserCredential res =await _auth.createUserWithEmailAndPassword(
                                      email: email, password: password);
                                  User? user= res.user;
                                  user!.updateDisplayName(username);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.blueGrey,
                                      content: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            'Registro existoso! Puedes ingresar'),
                                      ),
                                      duration: Duration(seconds: 5),
                                    ),
                                  );
                                  Navigator.of(context).pop();

                                  setState(() {
                                    isloading = false;
                                  });
                                } on FirebaseAuthException catch (e) {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title:
                                          Text('Registro fallido'),
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
