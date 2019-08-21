import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/job.dart';

class JobDesc extends StatelessWidget {

  final Job job;

  JobDesc(this.job);

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return new Padding(
      padding: EdgeInsets.only(
        left: 20.0*factor,
        right: 20.0*factor
      ),
      child: new Container(
          color: Colors.white,
          child: new Padding(
              padding: EdgeInsets.all(15.0*factor),
              child: new Column(
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Container(
                        margin: EdgeInsets.only(bottom: 10.0*factor),
                        child: new Text(
                            '职位详情', style: new TextStyle(fontSize: 32.0*factor, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),

                  Container(height: 20*factor,),

                  new RichText(
                    text: new TextSpan(
                      text: job.detail,
                      style: new TextStyle(
                          fontSize: 26.0*factor,
                          color: Colors.grey[700],
                          height: 1.6
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