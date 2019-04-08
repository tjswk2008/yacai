import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/job.dart';
import 'package:flutter_app/app/component/timeago/timeago.dart' as timeago;

class JobListItem extends StatelessWidget {
  final Job job;

  JobListItem(this.job);

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    timeago.setLocaleMessages("zh_cn", timeago.ZhCnMessages());
    return new Padding(
      padding: EdgeInsets.only(left: 20.0*factor, right: 20*factor, top: 30*factor),

      child: new SizedBox(
        child: new Card(
          elevation: 2,
          // color: Color(0xffeeeeee),
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
                            top: 10.0*factor,
                            left: 20.0*factor,
                          ),
                          child: new Text(job.name, style: new TextStyle(fontSize: 26.0*factor)),
                        ),
                        new Expanded(child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            new Padding(
                              padding: EdgeInsets.only(
                                right: 20.0*factor,
                              ),
                              child: new Text(
                                  '${job.salaryLow}k-${job.salaryHigh}k',
                                  style: new TextStyle(color: Colors.red, fontSize: 26.0*factor)),
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
                            fontSize: 24.0*factor, color: Colors.grey),
                      ),
                      margin: EdgeInsets.only(
                          top: 10.0*factor,
                          left: 20.0*factor,
                        ),
                    ),

                    new Divider(),
                    new Row(
                      children: <Widget>[
                        // new Padding(
                        //   padding: EdgeInsets.only(
                        //     left: 20.0*factor,
                        //     right: 5.0*factor,
                        //     bottom: 15.0*factor,
                        //   ),
                        //   child: new Text(job.username + " | " + job.title,
                        //       style: new TextStyle(color: new Color.fromARGB(255, 0, 215, 198), fontSize: 24.0*factor)),
                        // ),
                        new Padding(
                          padding: EdgeInsets.only(
                            left: 20.0*factor,
                            bottom: 15.0*factor,
                          ),
                          child: new Text("发布于 ${timeago.format(DateTime.parse(job.pubTime), locale: 'zh_cn')}",
                            style: new TextStyle(fontSize: 24.0*factor))
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