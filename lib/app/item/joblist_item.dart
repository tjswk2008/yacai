import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/job.dart';
import 'package:flutter_app/app/component/timeago/timeago.dart' as timeago;

class JobListItem extends StatelessWidget {
  final Job job;
  final bool showCount;

  JobListItem(this.job, this.showCount);

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    timeago.setLocaleMessages("zh_cn", timeago.ZhCnMessages());
    return new Padding(
      padding: EdgeInsets.only(bottom: 20*factor),

      child: new SizedBox(
        child: new Container(
          color: Colors.white,
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
                            top: 20.0*factor,
                            bottom: 10*factor,
                            left: 35.0*factor,
                          ),
                          child: Row(
                            children: <Widget>[
                              new Text(job.name, style: new TextStyle(fontSize: 34.0*factor, color: Colors.black)),
                              showCount ? Padding(
                                padding: EdgeInsets.only(left: 20*factor),
                                child: new Text(
                                  job.count == 0 ? '' : '(${job.count}份简历)',
                                  style: TextStyle(
                                    fontSize: 24.0*factor,
                                    color: Colors.green,
                                    fontFamily: 'fangzheng'
                                  )
                                ),
                              ) : Container()
                            ],
                          )
                        ),
                        new Expanded(child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            new Padding(
                              padding: EdgeInsets.only(
                                right: 47.0*factor,
                                top: 10*factor
                              ),
                              child: new Text(
                                  '${job.salaryLow}k-${job.salaryHigh}k',
                                  style: new TextStyle(color: Theme.of(context).primaryColor, fontSize: 30.0*factor, fontFamily: 'fangzheng', )),
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
                            fontFamily: 'fangzheng', fontSize: 28.0*factor, color: Colors.grey),
                      ),
                      margin: EdgeInsets.only(
                          top: 10.0*factor,
                          left: 35.0*factor,
                        ),
                    ),

                    new Divider(),
                    new Row(
                      children: <Widget>[
                        new Padding(
                          padding: EdgeInsets.only(
                            left: 35.0*factor,
                            bottom: 20.0*factor,
                          ),
                          child: (job.avatar == null || job.avatar == '') ? new Image.asset(
                            "assets/images/avatar_default.png",
                            width: 30.0*factor,
                            color: Theme.of(context).primaryColor,
                          ) : new CircleAvatar(
                            radius: 15.0*factor,
                            backgroundImage: new NetworkImage(job.avatar)
                          ),
                        ),
                        new Padding(
                          padding: EdgeInsets.only(
                            left: 10.0*factor,
                            bottom: 20.0*factor,
                          ),
                          child: new Text("发布于 ${timeago.format(DateTime.parse(job.pubTime), locale: 'zh_cn')}",
                            style: new TextStyle(fontFamily: 'fangzheng', fontSize: 28.0*factor))
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