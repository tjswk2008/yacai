import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/home.dart';
import 'package:flutter_app/recruit.dart';
import 'package:flutter_app/util/screen.dart';

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
    double screenWidthInPt = MediaQuery.of(context).size.width;
    return new Material(
      color: new Color.fromARGB(255, 0, 215, 198),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          new Text("丫财",
            style: new TextStyle(
              color: Colors.white,
              fontSize: 50.0*screenWidthInPt/750,
              fontWeight: FontWeight.bold
            ),
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(
                  left: 65.0*screenWidthInPt/750,
                  right: 65.0*screenWidthInPt/750,
                  bottom: 40.0*screenWidthInPt/750
                ),
                child: new InkWell(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(
                      builder: (BuildContext context) => new Recruit()), (
                      Route route) => route == null);
                  },
                  child: new Container(
                    height: 60.0*screenWidthInPt/750,
                    decoration: new BoxDecoration(
                      border: new Border.all(color: Colors.orange[50], width: 2.0*screenWidthInPt/750),
                      borderRadius: new BorderRadius.all(new Radius.circular(6.0*screenWidthInPt/750))
                    ),
                    child: new Center(
                      child: new Text('我是招聘者', style: new TextStyle(color: Colors.white, fontSize: 22.0*screenWidthInPt/750),),
                    ),
                  ),
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(
                  left: 65.0*screenWidthInPt/750,
                  right: 65.0*screenWidthInPt/750,
                ),
                child: new InkWell(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(
                      builder: (BuildContext context) => new BossApp()), (
                      Route route) => route == null);
                  },
                  child: new Container(
                    height: 60.0*screenWidthInPt/750,
                    decoration: new BoxDecoration(
                      border: new Border.all(color: Colors.orange[50], width: 2.0*screenWidthInPt/750),
                      borderRadius: new BorderRadius.all(new Radius.circular(6.0*screenWidthInPt/750))
                    ),
                    child: new Center(
                      child: new Text('我是求职者', style: new TextStyle(color: Colors.white, fontSize: 22.0*screenWidthInPt/750),),
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