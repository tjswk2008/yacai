import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/job.dart';

class JobAddr extends StatelessWidget {

  final Job job;

  JobAddr(this.job);

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return new Padding(
      padding: EdgeInsets.all(
        30.0*factor,
      ),
      child: new SizedBox(
        child: new Card(
          elevation: 0.0,
          child: new Row(
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(
                  right: 40.0*factor,
                ),
                child: new Text('工作地点', style: new TextStyle(fontSize: 30.0*factor, fontWeight: FontWeight.bold))
              ),

              new Expanded(
                child: new Text('上海市 ${job.area} ${job.addrDetail}', style: new TextStyle(fontSize: 26.0*factor, height: 1.6))
              ),
            ],
          ),
        ),
      ),
    );
  }
}