import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mchat/constants.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function pressOn;
  final Color color,textColor;



  const RoundedButton({
    Key key,
    this.text,
    this.pressOn,
    this.color,
    this.textColor,
}):super(key: key);



  @override
  Widget build(BuildContext context) {
    Size size= MediaQuery.of(context).size;
  return Container(
    margin: EdgeInsets.symmetric(vertical: 8),
    width: size.width*0.8,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(29),
      child: FlatButton(
        padding: EdgeInsets.symmetric(vertical: 15,horizontal: 30),
        color:color,
        onPressed:pressOn ,
        child: Text(text,style:TextStyle(color: textColor )),),
    ),
  );


   }
}
