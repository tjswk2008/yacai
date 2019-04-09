import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/company.dart';

class CompanyInfo extends StatelessWidget {

  final Company company;

  CompanyInfo(this.company);

  @override
  Widget build(BuildContext context) {
    double screenWidthInPt = MediaQuery.of(context).size.width;
    return new Padding(
      padding: EdgeInsets.only(
        left: 10.0*screenWidthInPt/750
      ),
      child: new SizedBox(
        child: new Card(
          elevation: 0.0,
          child: new Row(
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(
                  left: 10.0*screenWidthInPt/750,
                  right: 45.0*screenWidthInPt/750,
                ),
                child: company.logo != null ? new Image.network(
                  company.logo,
                  width: 100.0*screenWidthInPt/750,
                  height: 100.0*screenWidthInPt/750,) : Container(
                    width: 100.0*screenWidthInPt/750,
                    height: 100.0*screenWidthInPt/750,
                  ),
              ),

              new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Container(
                      child: new Text(
                        company.name,
                        textAlign: TextAlign.left,
                        style: new TextStyle(fontSize: 24.0*screenWidthInPt/750),
                      ),
                      margin: EdgeInsets.only(top: 10.0*screenWidthInPt/750, bottom: 10.0*screenWidthInPt/750),
                    ),

                    new Padding(
                      padding: EdgeInsets.only(
                        top: 10.0*screenWidthInPt/750,
                        right: 10.0*screenWidthInPt/750,
                        bottom: 10.0*screenWidthInPt/750,
                      ),
                      child: new Text(company.location, style: new TextStyle(
                          fontSize: 24.0*screenWidthInPt/750, color: Colors.grey)),
                    ),

                    new Padding(
                      padding: EdgeInsets.only(
                        top: 10.0*screenWidthInPt/750,
                        right: 10.0*screenWidthInPt/750,
                        bottom: 10.0*screenWidthInPt/750,
                      ),
                      child: new Text(
                          company.type + " | " + company.employee, style: new TextStyle(
                          fontSize: 22.0*screenWidthInPt/750, color: Colors.grey)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}