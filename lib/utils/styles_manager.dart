import 'package:flutter/cupertino.dart';

TextStyle _getTextStyle(double fontSize, FontWeight fontWeight, Color color) {
  return TextStyle(
      fontSize: fontSize,
      fontFamily: "Brazila",
      color: color,
      fontWeight: fontWeight);
}

//regular style
TextStyle getRegularStyle(
    {double fontSize = 12, required Color color}) {
  return _getTextStyle(fontSize, FontWeight.w400, color);
}

//medium style
TextStyle getMediumStyle(
    {double fontSize = 12, required Color color}) {
  return _getTextStyle(fontSize, FontWeight.w500, color);
}

//light style
TextStyle getLightStyle(
    {double fontSize = 12, required Color color}) {
  return _getTextStyle(fontSize, FontWeight.w300, color);
}

//semiBold style
TextStyle getSemiBoldStyle(
    {double fontSize = 12, required Color color}) {
  return _getTextStyle(fontSize, FontWeight.w600, color);
}

//bold style
TextStyle getBoldStyle({double fontSize = 12, required Color color}) {
  return _getTextStyle(fontSize, FontWeight.w700, color);
}
