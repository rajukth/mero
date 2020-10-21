import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mchat/Global/TextFieldContainer.dart';
import 'package:mchat/Global/rounded_button.dart';
import 'package:mchat/constants.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mchat/Screens/Dashboard/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Signup_Screen.dart';

class LoginScreen extends StatefulWidget {

  static const String id="LoginScreen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final GlobalKey<FormState> _loginForm = GlobalKey<FormState>();
  var email,password;

  bool _obscureText =true;
  void _togglePassword(){
    setState((){
      _obscureText=!_obscureText;
    });
  }

  @override

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(

        leading:IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).popUntil((route)=>route.isFirst),
        ) ,
        title:  Text(
        "LOGIN",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),),
          body: Container(
        width: double.infinity,
        height: size.height,
          child: Stack(

            alignment: Alignment.center,
            children: <Widget>[
              background(context),
              //
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 15),
                child: Form(
                  key: _loginForm,
                child: ListView(
                  children: [
                  Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    SvgPicture.asset("assets/icons/login.svg", height: size.height * 0.2),

                    //username and password field
                    TextFieldContainer(
                      child: TextFormField(
                        onChanged: (value)=> email=value,
                        validator: (val){
                          if(val.isEmpty){
                            return 'Email field cannot be empty';
                          }
                          if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)){
                            return 'Invalid email';
                          }


                          return null;
                        },
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.person,
                            color: kPrimaryColor,
                          ),
                          hintText: "Enter Email",
                          hintStyle: TextStyle(color: kPrimaryColor),
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    TextFieldContainer(
                      child: TextFormField(
                        obscureText: _obscureText,
                        validator: (val) => val.length < 8 ? 'Minimum 8 character' : null,
                        onChanged: (value)=> password=value,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.lock,
                            color: kPrimaryColor,
                          ),
                          hintText: "Password",

                          hintStyle: TextStyle(color: kPrimaryColor),
                          border: InputBorder.none,

                          suffixIcon:IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: kPrimaryColor,
                            ),
                            onPressed: () {
                              _togglePassword();
                            }, ),
                        ),

                      ),
                    ),
                    //

                    RoundedButton(
                      text: 'LOGIN',
                      color: kPrimaryColor,
                      textColor: Colors.white,
                      pressOn:() async {
                        if (_loginForm.currentState.validate()) {
                    await login(email, password);
                    SharedPreferences prefs= await SharedPreferences.getInstance();
                    String token = prefs.getString("token");
                    String msg = prefs.getString("msg");
                    if(token !=null){
                    Navigator.pushNamed(context,Dashboard.id);
                    }else if(msg!=null){
                      final snackBar = SnackBar(
                        content: Text(prefs.getString("msg")),
                        action: SnackBarAction(
                          label: 'Retry',
                          onPressed: () {
                            // Some code to undo the change.
                          },
                        ),
                      );
                      Scaffold.of(context).showSnackBar(snackBar);
                    }


                    // it to show a SnackBar.

                        }
                    },

                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: <Widget>[
                      Text("Don't have an Account ?",
                      style:TextStyle(color: kPrimaryColor)),
                      SizedBox(width: 8,),
                        GestureDetector(
                            onTap: (){

                              Navigator.pushNamed(context,SignUpScreen.id);
                            },
                            child: Text("Sign Up",style: TextStyle(color:Colors.blue,fontWeight: FontWeight.bold),)),


                      ],
                    ),

                  ]),
                ],
              ),
            )
            //
              )],
      ),
        ),
    );
  }
}




Widget background(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  return Stack(
    children: <Widget>[
      Positioned(
        top: 0,
        left: 0,
        child: Image.asset(
          "assets/images/main_top.png",
          width: size.width * 0.35,
        ),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: Image.asset(
          "assets/images/login_bottom.png",
          width: size.width * 0.4,
        ),
      )
    ],
  );
}

//Function to connect mongodb api and retrieve and check data
login(email,password) async {
  var url="http://192.168.16.105:3000/login"; //192.168.***.***  should be changed when pc ip got change to IPv4 address
  final http.Response response= await http.post(url,
    headers: <String ,String >{
      'Content-Type': 'application/json; charset=UTF-8',},
    body: jsonEncode(<String, String>{
      'email': email, 'password':password,
    }),
  );
  if(response.statusCode == 200){
  }else{
    throw Exception('Failed to connect');
  }
  print(response.body);
  var parse = jsonDecode(response.body);
  SharedPreferences prefs= await SharedPreferences.getInstance();
  await prefs.setString('token', parse["token"]);
  String token = prefs.getString("token");
  print(token);

}