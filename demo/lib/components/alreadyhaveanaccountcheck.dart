import 'package:flutter/material.dart';
import 'package:demo/additional/constants.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final Function press;
  const AlreadyHaveAnAccountCheck({
    Key? key,
    this.login = true,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "No tengo una cuenta" : "Tengo una cuenta ",
          style: TextStyle(color: kPrimaryColor),
        ),
        GestureDetector(
          onTap: () => {press},
          child: Text(
            login ? "Registrarse" : "Ingresar",
            style: TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}