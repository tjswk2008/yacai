import 'package:flutter/material.dart';
import 'package:flutter_app/splash.dart';
// import 'package:flutter/rendering.dart';

void main() {
  // debugPaintSizeEnabled=true;
  runApp(new MaterialApp(
    title: "丫财",
    theme: new ThemeData(
      primaryIconTheme: const IconThemeData(color: Colors.white),
      brightness: Brightness.light,
      primaryColor: new Color.fromARGB(255, 0, 215, 198),
      accentColor: Colors.cyan[300],
    ),
    home: new SplashPage()));
}