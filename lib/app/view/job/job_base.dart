import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/job.dart';

class JobBase extends StatelessWidget {

  final Job job;

  JobBase(this.job);

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return new Padding(
      padding: EdgeInsets.only(
        top: 20.0*factor,
        left: 20.0*factor,
        right: 20.0*factor,
      ),
      child: new SizedBox(
        child: new Card(
          elevation: 0.0,
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(top: 10.0*factor),
              ),

              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  new Container(
                    margin: EdgeInsets.only(bottom: 10.0*factor),
                    child: new Text(
                      job.name,
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 34.0*factor, fontWeight: FontWeight.bold),
                    ),
                  ),

                  new Container(
                    child: new Text('${job.salaryLow}k-${job.salaryHigh}k', style: new TextStyle(
                        fontSize: 34.0*factor,
                        color: Theme.of(context).primaryColor
                      )
                    ),
                  ),
                ],
              ),

              new Padding(
                padding: EdgeInsets.only(top: 10.0*factor),
              ),

              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[

                  new Padding(
                    padding: EdgeInsets.only(
                      right: 15.0*factor,
                    ),
                    child: new Icon(Icons.business, size: 32*factor, color: Colors.grey[600],),
                  ),

                  new Padding(
                    padding: EdgeInsets.only(
                      right: 15.0*factor,
                    ),
                    child: new Text(job.timereq, style: new TextStyle(
                        fontSize: 26.0*factor, color: Colors.grey)),
                  ),

                  new Padding(
                    padding: EdgeInsets.only(
                      right: 15.0*factor,
                    ),
                    child: new Icon(Icons.school, size: 32*factor, color: Colors.grey[600]),
                  ),

                  new Container(
                    child: new Text(
                        job.academic, style: new TextStyle(
                        fontSize: 26.0*factor, color: Colors.grey)),
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