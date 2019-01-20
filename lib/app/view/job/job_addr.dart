import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/job.dart';

class JobAddr extends StatelessWidget {

  final Job job;

  JobAddr(this.job);

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(10.0),
      child: new SizedBox(
        child: new Card(
          elevation: 0.0,
          child: new Row(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(
                  left: 15.0,
                  right: 15.0,
                ),
                child: new Text('工作地点', style: new TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold))
              ),

              new Expanded(
                child: new Text(job.addrDetail, style: new TextStyle(fontSize: 15.0))
              ),
            ],
          ),
        ),
      ),
    );
  }
}