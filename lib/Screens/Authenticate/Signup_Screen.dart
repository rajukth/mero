import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mchat/Global/TextFieldContainer.dart';
import 'package:mchat/Global/rounded_button.dart';
import 'package:mchat/Screens/Authenticate/login_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mchat/Screens/Components/body.dart';
import 'package:mchat/Screens/Dashboard/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';



import '../../constants.dart';
import '../welcome.dart';

class SignUpScreen extends StatefulWidget {

  static const String id="SignUpScreen";
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var email;
  var password;
  bool _obscureText =true;
  void _togglePassword(){
    setState(() {
     _obscureText=!_obscureText;
    });
  }

  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  @override
  Widget build(BuildContext context) {



    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading:IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).popUntil((route)=>route.isFirst),
        ) ,
        title: Text('SignUp', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),),
      ),
      body: Container(
        width: double.infinity,
        height: size.height,
        child: Stack(
          alignment: Alignment.center,

          children:<Widget> [
            background(context),
           Form(
             key: _form,
             child: ListView(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: size.height*0.01),
                      SvgPicture.asset("assets/icons/signup.svg", height: size.height * 0.3,),
                      Column(
                        children: <Widget>[
                          TextFieldContainer(
                            child: TextFormField(
                                onChanged: (value)=> email=value,
                              validator: (val){
                                  if(val.isEmpty){
                                  return 'Email field cannot be empty';
                                  }
                                  if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)){
                                    return 'Enter valid email';
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
                              controller: _pass,
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
                          TextFieldContainer(
                            child: TextFormField(
                              controller: _confirmPass,
                              obscureText: _obscureText,
                                validator: (val){
                                  if(val.isEmpty)
                                    return 'Empty';
                                  if(val != password)
                                    return 'Not Match';
                                  return null;
                                },

                                decoration: InputDecoration(
                                icon: Icon(
                                  Icons.lock,
                                  color: kPrimaryColor,
                                ),
                                hintText: "Confirm Password",
                                hintStyle: TextStyle(color: kPrimaryColor),
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    // Based on passwordVisible state choose the icon
                                    _obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: kPrimaryColor,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText=!_obscureText;
                                    });
                                  }, ),
                              ),
                            ),
                          ),

                          RoundedButton(
                            text: 'SIGNUP',
                            color: kPrimaryColor,
                            textColor: Colors.white,
                              pressOn:()async {
                                    if (_form.currentState.validate()) {
                                      signup(email, password);
                                      SharedPreferences prefs= await SharedPreferences.getInstance();
                                      String token = prefs.getString("token");
                                      if(token !=null){
                                    Navigator.pushNamed(context,Dashboard.id);
    }}
    },



                          ),

                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Already have an Account ?",
                              style:TextStyle(color: kPrimaryColor)),
                          SizedBox(width: 8,),
                          GestureDetector(
                              onTap: (){
                                Navigator.pushNamed(context,LoginScreen.id);
                              },
                              child: Text("LogIn",style: TextStyle(color:Colors.blue,fontWeight: FontWeight.bold),))
                        ],),


                    ],

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

Widget background(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  return Stack(
    children: <Widget>[
      Positioned(
        top: 0,
        left: 0,
        child: Image.asset(
          "assets/images/signup_top.png",
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

//function for connection of mongodb and insert of data

signup(email,password) async {

  var url="http://192.168.43.252:3000/signup"; //192.168.***.***  should be changed when pc ip got change to IPv4 address
  final http.Response response= await http.post(url,
    headers: <String ,String >{
      'Content-Type': 'application/json; charset=UTF-8',},
    body: jsonEncode(<String, String>{
      'email': email, 'password':password,
    }),
  );
  print(response.body);
  SharedPreferences prefs= await SharedPreferences.getInstance();
  var parse = jsonDecode(response.body);

    await prefs.setString('token', parse["token"]);
    String token = prefs.getString("token");
    print(token);

}





