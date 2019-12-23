import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/communicate.dart';
import 'package:flutter_app/app/component/timeago/timeago.dart' as timeago;

class CommunicateListItem extends StatelessWidget {
  final CommunicateModel post;

  CommunicateListItem(this.post);

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    timeago.setLocaleMessages("zh_cn", timeago.ZhCnMessages());
    return new Padding(
      padding: EdgeInsets.only(
        top: 10*factor,
        left: 10.0*factor,
        right: 10.0*factor,
        bottom: 10*factor,
      ),

      child: new SizedBox(
        child: new Card(
          elevation: 0.0,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new Padding(
                    padding: EdgeInsets.only(
                      top: 30.0*factor,
                      left: 30.0*factor,
                      bottom: 5.0*factor,
                    ),
                    child: new RichText(
                      text: new TextSpan(
                        text: "来自",
                        style: new TextStyle(
                            fontSize: 30.0*factor,
                            color: Colors.black54
                        ),
                      ),
                    ),
                  ),
                  new Padding(
                    padding: EdgeInsets.only(
                      top: 30.0*factor,
                      left: 5*factor,
                      right: 5*factor,
                      bottom: 5.0*factor,
                    ),
                    child: new RichText(
                      text: new TextSpan(
                        text: post.userName,
                        style: new TextStyle(
                            fontSize: 30.0*factor,
                            color: Colors.red[300]
                        ),
                      ),
                    ),
                  ),
                  new Padding(
                    padding: EdgeInsets.only(
                      top: 30.0*factor,
                      right: 30.0*factor,
                      bottom: 5.0*factor,
                    ),
                    child: new RichText(
                      text: new TextSpan(
                        text: "的会话",
                        style: new TextStyle(
                            fontSize: 30.0*factor,
                            color: Colors.black54
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              new Padding(
                padding: EdgeInsets.only(
                  left: 30.0*factor,
                  right: 30.0*factor,
                ),
                child: new Divider(),
              ),
              new Row(
                children: <Widget>[
                  new Padding(
                    padding: EdgeInsets.only(
                      left: 30.0*factor,
                      right: 5.0*factor,
                      bottom: 20*factor,
                      top: 10*factor
                    ),
                    child: new Text(
                        "职位：",
                        style: new TextStyle(
                            fontSize: 26.0*factor,
                            color: Colors.grey)
                    ),
                  ),
                  new Padding(
                    padding: EdgeInsets.only(
                      right: 30.0*factor,
                      top: 10*factor,
                      bottom: 20*factor
                    ),
                    child: new Text(
                        post.name,
                        style: new TextStyle(
                            fontSize: 26.0*factor,
                            color: Colors.grey)),
                  )
                ],
              )
            ],
          ), 
        ),
      ),
    );
  }
}