import 'dart:async';
import 'dart:ui' as ui show window;

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
    print(ui.window.physicalSize.height);
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
            // top: 325*factor,
            bottom: 462*factor,
            left: 166*factor,
            child: new Image.asset(
              'assets/images/duck.png',
              width: 406*factor,
              height: 579*factor,
            ),
          ),
          Positioned(
            bottom: 137*factor, //1131
            left: 302*factor,
            child: new Image.asset(
              'assets/images/yacai.png',
              width: 147*factor,
              height: 98*factor,
            ),
          ),
          Positioned(
            bottom: 20*factor, //1310
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