import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CompanyInc extends StatelessWidget {

  final String _companyInc;

  CompanyInc(this._companyInc);

  @override
  Widget build(BuildContext context) {
    double screenWidthInPt = MediaQuery.of(context).size.width;
    return new Padding(
      padding: EdgeInsets.only(
        top: 10.0*screenWidthInPt/750,
        left: 10.0*screenWidthInPt/750,
        right: 10.0*screenWidthInPt/750,
        bottom: 10.0*screenWidthInPt/750,
      ),
      child: new Container(
          color: Colors.white,
          child: new Padding(
              padding: EdgeInsets.all(15.0*screenWidthInPt/750),
              child: new Column(
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Container(
                        margin: EdgeInsets.only(bottom: 10.0*screenWidthInPt/750),
                        child: new Text(
                            '公司介绍', style: new TextStyle(fontSize: 20.0*screenWidthInPt/750)),
                      )
                    ],
                  ),

                  new RichText(
                    text: new TextSpan(
                      text: _companyInc,
                      style: new TextStyle(
                          fontSize: 18.0*screenWidthInPt/750,
                          color: Colors.black
                      ),
                    ),
                  )
                ],
              )
          )
      ),
    );
  }
}