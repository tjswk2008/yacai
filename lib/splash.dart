import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/role.dart';

class SplashPage extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<SplashPage> {

  Timer _t;

  @override
  void initState() {
    super.initState();
    _t = new Timer(const Duration(milliseconds: 1500), () {
      try {
        Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(
            builder: (BuildContext context) => new RolePage()), (
            Route route) => route == null);
      } catch (e) {

      }
    });
  }

  @override
  void dispose() {
    _t.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return new Material(
      // color: new Color.fromARGB(255, 0, 215, 198),
      child: new Stack(
        children: <Widget>[
          Positioned.fill(
            child: new Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.0, -1.0),
                  end: Alignment(0.0, 1.0),
                  colors: <Color>[
                    Color.fromRGBO(150, 210, 249, 1),
                    Color.fromRGBO(90, 169, 226, 1)
                  ],
                ),
              ),
            )
          ),
          Positioned(
            top: 469*factor,
            left: 166*factor,
            child: new Image.asset(
              'assets/images/duck.png',
              width: 406*factor,
              height: 579*factor,
            ),
          ),
          Positioned(
            top: 1131*factor,
            left: 302*factor,
            child: new Image.asset(
              'assets/images/yacai.png',
              width: 147*factor,
              height: 98*factor,
            ),
          ),
          Positioned(
            top: 1310*factor,
            left: 140*factor,
            child: new Image.asset(
              'assets/images/slogan.png',
              width: 463*factor,
              height: 36*factor,
            )
          ),
        ],
      )
      
    );
  }
}