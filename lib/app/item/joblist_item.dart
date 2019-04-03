import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/job.dart';

class JobListItem extends StatelessWidget {
  final Job job;

  JobListItem(this.job);

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

      child: new SizedBox(
        child: new Card(
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
                        new Padding(
                          padding: EdgeInsets.only(
                            top: 10.0*screenWidthInPt/750,
                            left: 20.0*screenWidthInPt/750,
                          ),
                          child: new Text(job.name, style: new TextStyle(fontSize: 26.0*screenWidthInPt/750)),
                        ),
                        new Expanded(child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            new Padding(
                              padding: EdgeInsets.only(
                                right: 20.0*screenWidthInPt/750,
                              ),
                              child: new Text(
                                  '${job.salaryLow}k-${job.salaryHigh}k',
                                  style: new TextStyle(color: Colors.red, fontSize: 26.0*screenWidthInPt/750)),
                            ),
                          ],
                        ))
                      ],
                    ),

                    new Container(
                      child: new Text(
                        job.cname,
                        textAlign: TextAlign.left,
                        style: new TextStyle(
                            fontSize: 24.0*screenWidthInPt/750, color: Colors.grey),
                      ),
                      margin: EdgeInsets.only(
                          top: 10.0*screenWidthInPt/750,
                          left: 20.0*screenWidthInPt/750,
                        ),
                    ),

                    new Divider(),
                    new Row(
                      children: <Widget>[
                        new Padding(
                          padding: EdgeInsets.only(
                            left: 20.0*screenWidthInPt/750,
                            right: 5.0*screenWidthInPt/750,
                            bottom: 15.0*screenWidthInPt/750,
                          ),
                          child: new Text(job.username + " | " + job.title,
                              style: new TextStyle(color: new Color.fromARGB(255, 0, 215, 198), fontSize: 24.0*screenWidthInPt/750)),
                        ),
                        new Padding(
                          padding: EdgeInsets.only(
                            right: 10.0*screenWidthInPt/750,
                            bottom: 15.0*screenWidthInPt/750,
                          ),
                          child: new Text(" 发布于 " + job.pubTime, style: new TextStyle(fontSize: 24.0*screenWidthInPt/750))
                        )
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