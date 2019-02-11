import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/home.dart';
import 'package:flutter_app/recruit.dart';

class SplashPage extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<SplashPage> {

  Timer _t;

  @override
  void initState() {
    super.initState();
    // _t = new Timer(const Duration(milliseconds: 1500), () {
    //   try {
    //     Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(
    //         builder: (BuildContext context) => new BossApp()), (
    //         Route route) => route == null);
    //   } catch (e) {

    //   }
    // });
  }

  @override
  void dispose() {
    // _t.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      color: new Color.fromARGB(255, 0, 215, 198),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          new Text("丫财",
            style: new TextStyle(
              color: Colors.white,
              fontSize: 50.0,
              fontWeight: FontWeight.bold
            ),
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(15.0),
                child: new InkWell(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(
                      builder: (BuildContext context) => new Recruit()), (
                      Route route) => route == null);
                  },
                  child: new Container(
                    height: 30.0,
                    decoration: new BoxDecoration(
                      border: new Border.all(color: Colors.orange[100]),
                      borderRadius: new BorderRadius.all(new Radius.circular(5.0))
                    ),
                    child: new Center(
                      child: new Text('我是招聘者', style: new TextStyle(color: Colors.white, fontSize: 14.0),),
                    ),
                  ),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(15.0),
                child: new InkWell(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(
                      builder: (BuildContext context) => new BossApp()), (
                      Route route) => route == null);
                  },
                  child: new Container(
                    height: 30.0,
                    decoration: new BoxDecoration(
                      border: new Border.all(color: Colors.orange[200]),
                      borderRadius: new BorderRadius.all(new Radius.circular(5.0))
                    ),
                    child: new Center(
                      child: new Text('我是求职者', style: new TextStyle(color: Colors.white, fontSize: 14.0),),
                    ),
                  ),
                ),
              )
            ]
          )
        ],
      ),
    );
  }
}