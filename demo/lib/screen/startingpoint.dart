import 'package:demo/screen/login.dart';
import 'package:demo/screen/signup.dart';
import 'package:flutter/material.dart';
import 'package:demo/additional/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "TEST MINIMENTAL MÓVIL",
              textAlign: TextAlign.center,
              style: GoogleFonts.comfortaa(
                  textStyle: TextStyle(fontSize: 40, fontWeight: FontWeight.w600)
                ),
            ),
            SizedBox(height: size.height * 0.05),
            SizedBox(height: size.height * 0.05),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              width: size.width * 0.8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(29),
                child: TextButton(
                  onPressed: () =>{
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return LoginScreen();
                        },
                      ),
                  )
                  },
                  style:TextButton.styleFrom(
                    primary: Colors.black,
                    backgroundColor: kPrimaryLightColor,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  ),
                  child: Text(
                    "INGRESAR",
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              width: size.width * 0.8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(29),
                child: TextButton(
                  onPressed: () =>{
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SignUpScreen();
                        },
                      ),
                  )
                  },
                  style:TextButton.styleFrom(
                    primary: Colors.black,
                    backgroundColor: kPrimaryColor,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  ),
                  child: Text(
                    "CREAR CUENTA",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

