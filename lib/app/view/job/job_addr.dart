import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/job.dart';

class JobAddr extends StatelessWidget {

  final Job job;

  JobAddr(this.job);

  @override
  Widget build(BuildContext context) {
    double screenWidthInPt = MediaQuery.of(context).size.width;
    return new Padding(
      padding: EdgeInsets.only(
        left: 20.0*screenWidthInPt/750
      ),
      child: new SizedBox(
        child: new Card(
          elevation: 0.0,
          child: new Row(
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(
                  right: 15.0*screenWidthInPt/750,
                ),
                child: new Text('工作地点', style: new TextStyle(fontSize: 20.0*screenWidthInPt/750, fontWeight: FontWeight.bold))
              ),

              new Expanded(
                child: new Text(job.addrDetail, style: new TextStyle(fontSize: 20.0*screenWidthInPt/750))
              ),
            ],
          ),
        ),
      ),
    );
  }
}