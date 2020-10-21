
import 'package:flutter/material.dart';
import 'package:mchat/Global/rounded_button.dart';
import 'package:mchat/Screens/Components/body.dart';
import 'package:mchat/Screens/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class Dashboard extends StatelessWidget {
  static const String id="Dashboard";
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Center(child: Text("Welcome", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40.0))),
            Center(child: Text("To",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0))),
            Center(child: Text("Dashboard",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0))),
    Padding(
      padding: const EdgeInsets.all(20.0),
      child: RoundedButton(
      text: 'Log Out',
      color: kPrimaryColor,
      textColor: Colors.white,
      pressOn:()async {
        SharedPreferences prefs= await SharedPreferences.getInstance();
        await prefs.setString('token', null);
        Navigator.pushNamed(context, Welcome.id);
      }),
    ),

          ],
        )

    );
  }
}
