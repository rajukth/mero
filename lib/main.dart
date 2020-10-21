import 'package:flutter/material.dart';
import 'package:mchat/Screens/Authenticate/Signup_Screen.dart';
import 'package:mchat/Screens/Authenticate/login_screen.dart';
import 'package:mchat/Screens/Components/body.dart';
import 'package:mchat/Screens/Dashboard/dashboard.dart';
import 'package:mchat/constants.dart';
import 'Screens/welcome.dart';

void main()=>runApp(MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mero',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,

      ),
      home: Welcome(),
      routes: {
        Welcome.id: (context)=> Welcome(),
        Body.id: (context)=> Body(),
        Dashboard.id: (context)=>Dashboard(),
        SignUpScreen.id: (context)=>SignUpScreen(),
        LoginScreen.id: (context)=>LoginScreen(),
      },

    );
  }
}
