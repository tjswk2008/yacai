import 'package:flutter/material.dart';

class YaCaiUtil {
  static YaCaiUtil instance = new YaCaiUtil();
  BuildContext context;
  double factor;

  YaCaiUtil();

  static YaCaiUtil getInstance() {
    return instance;
  }

  void init(BuildContext ctx) {
      context = ctx;
      factor = MediaQuery.of(context).size.width/750;
  }

  ///每个逻辑像素的字体像素数，字体的缩放比例
  showMsg(msg) {
    showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
          return new AlertDialog(
              title: new Text('提示', style: TextStyle(fontSize: 32*factor),),
              content: new SingleChildScrollView(
                  child: new ListBody(
                      children: <Widget>[
                          new Text(msg, style: TextStyle(fontSize: 28*factor)),
                      ],
                  ),
              ),
              actions: <Widget>[
                  new FlatButton(
                      child: new Text('确定', style: TextStyle(fontSize: 32*factor)),
                      onPressed: () {
                          Navigator.of(context).pop();
                      },
                  ),
              ],
          );
      },
    );
  }
}