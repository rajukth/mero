
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mchat/Screens/Authenticate/Signup_Screen.dart';
import 'package:mchat/Screens/Authenticate/login_screen.dart';
import 'package:mchat/Screens/Components/Background.dart';
import 'package:mchat/Screens/Dashboard/dashboard.dart';
import 'package:mchat/constants.dart';
import 'package:mchat/Global/rounded_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatefulWidget {

  static const String id="Body";
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {


  @override
  Widget build(BuildContext context) {
   //to check previous logged in
    checkToken() async{
      SharedPreferences prefs= await SharedPreferences.getInstance();
      String token = prefs.getString("token");
      if(token !=null) {
        Navigator.pushNamed(context, Dashboard.id);
      }
    }
    checkToken();
    //
    Size size = MediaQuery
        .of(context)
        .size; //total size of the screen (height and width)
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Welcome",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0) ),
            SizedBox(
              height: size.height * 0.03,
            ),
            SvgPicture.asset("assets/icons/chat.svg",
                height: size.height * 0.45),
            SizedBox(
              height: size.height * 0.03,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RoundedButton(
                  text: "LOGIN",
                  color: kPrimaryColor,
                  textColor: Colors.white,
                  pressOn: () {
                    /*_makeGetRequest();*/
                    Navigator.pushNamed(context,LoginScreen.id);
                  },
                ),
                RoundedButton(
                  text: "SIGNUP",
                  color: kPrimaryLightColor,
                  textColor: Colors.black,
                  pressOn: () {
                    Navigator.pushNamed(context,SignUpScreen.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}