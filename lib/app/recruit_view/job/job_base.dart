import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/job.dart';

class JobBase extends StatelessWidget {

  final Job job;

  JobBase(this.job);

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(15.0),
      child: new SizedBox(
        child: new Card(
          elevation: 0.0,
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(top: 70.0),
              ),

              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  new Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: new Text(
                      job.name,
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 20.0),
                    ),
                  ),

                  new Container(
                    child: new Text(job.salary, style: new TextStyle(
                        fontSize: 13.0, color: new Color.fromARGB(255, 0, 215, 198))),
                  ),
                ],
              ),

              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  new Container(
                    child: new Text(
                      job.addrSummarize,
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 15.0, color: Colors.grey),
                    ),
                  ),

                  new Padding(
                    padding: const EdgeInsets.only(
                      top: 0.0,
                      left: 15.0,
                      right: 15.0,
                      bottom: 0.0,
                    ),
                    child: new Text(job.timereq, style: new TextStyle(
                        fontSize: 15.0, color: Colors.grey)),
                  ),

                  new Container(
                    child: new Text(
                        job.academic, style: new TextStyle(
                        fontSize: 15.0, color: Colors.grey)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}