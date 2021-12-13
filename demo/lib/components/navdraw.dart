import 'package:demo/additional/constants.dart';
import 'package:demo/additional/otherfunctions.dart';
import 'package:demo/screen/inside.dart';
import 'package:demo/screen/login.dart';
import 'package:demo/screen/stats.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class NavigationDrawerWidget extends StatefulWidget {
    final padding = EdgeInsets.symmetric(horizontal: 20);
  _NavigationDrawerWidgetState createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {

  @override
  Widget build(BuildContext context) {

    final FirebaseAuth _ath = FirebaseAuth.instance;
    final email = '${_ath.currentUser!.email}';
    final User? user = _ath.currentUser;
    final userProfile = user!.displayName;

    return Drawer(
      child: Material(
        color: drawerMainColor,
        child: ListView(
          children: <Widget>[
            buildHeader(
              name: userProfile!,
              email: email,
              //onClicked: () => {},
            ),
            Container(
              padding: widget.padding,
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  const SizedBox(height: 24),
                  buildMenuItem(
                    text: 'Pantalla Principal',
                    icon: Icons.home,
                    onClicked: () => selectedItem(context, 0),
                  ),
                  const SizedBox(height: 24),
                  Divider(color: divdraw),
                  const SizedBox(height: 24),
                  buildMenuItem(
                    text: 'Resultados',
                    icon: Icons.bar_chart_outlined,
                    onClicked: () => selectedItem(context, 1),
                  ),
                  const SizedBox(height: 24),
                  buildMenuItem(
                    text: 'Datos Del Paciente',
                    icon: Icons.person_outline,
                    onClicked: () => selectedItem(context, 2),
                  ),
                  const SizedBox(height: 16),
                  Divider(color: divdraw),
                  buildMenuItem(
                    text: 'Configuración',
                    icon: Icons.settings_outlined,
                    onClicked: () => selectedItem(context, 999),
                  ),
                  buildMenuItem(
                    text: 'Cerrar sesión',
                    icon: Icons.exit_to_app_outlined,
                    onClicked: () => selectedItem(context, 46),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader({
    required String name,
    required String email,
    //required VoidCallback onClicked,
  }) =>
      InkWell(
        //onTap: onClicked,
        child: Container(
          padding: widget.padding.add(EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 20, color: textdraw),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(fontSize: 14, color: textdraw),
                  ),
                ],
              ),
            ], 
          ),
        ),
      );

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = textdraw;
    final hoverColor = divdraw;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  Future<void> selectedItem(BuildContext context, int index) async {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FirstRoute(),
        ));
        break;
      case 1:
        var params= await getStats(context);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Stats(params[0],params[1]),
        ));
        break;     
      case 46:
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.remove("Email");
        await _firebaseAuth.signOut();
        if (_firebaseAuth.currentUser == null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
        break;
    }

  }
}