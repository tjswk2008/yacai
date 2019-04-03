import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/job.dart';

class JobBase extends StatelessWidget {

  final Job job;

  JobBase(this.job);

  @override
  Widget build(BuildContext context) {
    double screenWidthInPt = MediaQuery.of(context).size.width;
    return new Padding(
      padding: EdgeInsets.only(
        top: 15.0*screenWidthInPt/750,
        left: 15.0*screenWidthInPt/750,
        right: 15.0*screenWidthInPt/750,
      ),
      child: new SizedBox(
        child: new Card(
          elevation: 0.0,
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(top: 10.0*screenWidthInPt/750),
              ),

              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  new Container(
                    margin: EdgeInsets.only(bottom: 10.0*screenWidthInPt/750),
                    child: new Text(
                      job.name,
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 26.0*screenWidthInPt/750),
                    ),
                  ),

                  new Container(
                    child: new Text('${job.salaryLow}k-${job.salaryHigh}k', style: new TextStyle(
                        fontSize: 26.0*screenWidthInPt/750, color: new Color.fromARGB(255, 0, 215, 198))),
                  ),
                ],
              ),

              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[

                  new Padding(
                    padding: EdgeInsets.only(
                      right: 15.0*screenWidthInPt/750,
                    ),
                    child: new Text(job.timereq, style: new TextStyle(
                        fontSize: 22.0*screenWidthInPt/750, color: Colors.grey)),
                  ),

                  new Container(
                    child: new Text(
                        job.academic, style: new TextStyle(
                        fontSize: 22.0*screenWidthInPt/750, color: Colors.grey)),
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