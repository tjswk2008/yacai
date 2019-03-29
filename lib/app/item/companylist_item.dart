import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/company.dart';

class CompanyListItem extends StatelessWidget {
  final Company company;

  CompanyListItem(this.company);

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return new Padding(
      padding: EdgeInsets.only(
        top: 10.0*factor,
        left: 15.0*factor,
        right: 15.0*factor,
        bottom: 10.0*factor,
      ),

      child: new SizedBox(
        child: new Card(
          elevation: 0.0,
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(
                  top: 10.0*factor,
                  left: 15.0*factor,
                  right: 15.0*factor,
                  bottom: 0.0,
                ),
                child: company.logo != null ? new Image.network(
                  company.logo,
                  width: 100.0*factor,
                  height: 100.0*factor,) : Container(
                    width: 100.0*factor,
                    height: 100.0*factor,
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
                        style: new TextStyle(fontSize: 24.0*factor),
                      ),
                      margin: EdgeInsets.only(top: 10.0*factor, bottom: 10.0*factor),
                    ),

                    new Padding(
                      padding: EdgeInsets.only(
                        top: 10.0*factor,
                        left: 0.0,
                        right: 10.0*factor,
                        bottom: 10.0*factor,
                      ),
                      child: new Text(company.location, style: new TextStyle(
                          fontSize: 22.0*factor, color: Colors.grey)),
                    ),

                    new Padding(
                      padding: EdgeInsets.only(
                        top: 10.0*factor,
                        left: 0.0,
                        right: 10.0*factor,
                        bottom: 10.0*factor,
                      ),
                      child: new Text(
                          '${company.type} | ${company.employee}', style: new TextStyle(
                          fontSize: 22.0*factor, color: Colors.grey)),
                    ),

                    new Divider(),
                    new Row(
                      children: <Widget>[
                        new Padding(
                          padding: EdgeInsets.only(
                            top: 10.0*factor,
                            left: 0.0,
                            right: 10.0*factor,
                            bottom: 15.0*factor,
                          ),
                          child: Row(
                            children: <Widget>[
                              Text('热招：', style: new TextStyle(
                                fontSize: 22.0*factor, color: Colors.grey)),
                              company.jobs.length == 0 ? Container() : Text(company.jobs[0].name, style: new TextStyle(
                                fontSize: 22.0*factor, color: Colors.red)),
                              company.jobs.length == 0 ? Container() : Text(' 等 ', style: new TextStyle(
                                fontSize: 22.0*factor, color: Colors.grey)),
                              Text(company.jobs.length.toString(), style: new TextStyle(
                                fontSize: 22.0*factor, color: Colors.red)),
                              Text(' 个职位', style: new TextStyle(
                                fontSize: 22.0*factor, color: Colors.grey)),
                            ],
                          )
                        ),
                        new Expanded(child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            new Padding(
                              padding: EdgeInsets.only(
                                bottom: 10.0*factor,
                              ),
                              child: Icon(
                                Icons.keyboard_arrow_right,
                                size: 36*factor,
                                color: Colors.grey,),
                            ),
                          ],
                        ))
                      ],
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