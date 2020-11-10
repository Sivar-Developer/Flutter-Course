import 'package:flutter/material.dart';

final ThemeData _androidTheme = ThemeData(
  // brightness: Brightness.dark,
  primarySwatch: Colors.deepPurple,
  accentColor: Colors.deepOrange,
  buttonColor: Colors.deepPurple,
  // buttonTheme: ButtonThemeData(textTheme: TextTheme())
  // fontFamily: 'Oswald'
);

final ThemeData _iOSTheme = ThemeData(
  // brightness: Brightness.dark,
  primarySwatch: Colors.grey,
  accentColor: Colors.deepOrange,
  buttonColor: Colors.blue,
  // buttonTheme: ButtonThemeData(textTheme: TextTheme())
  // fontFamily: 'Oswald'
);

ThemeData getAdaptiveThemeDta(context) {
  return Theme.of(context).platform == TargetPlatform.android ? _androidTheme : _iOSTheme;
}