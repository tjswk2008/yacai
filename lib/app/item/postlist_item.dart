import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/post.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostListItem extends StatelessWidget {
  final Post post;

  PostListItem(this.post);

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
              new Padding(
                padding: EdgeInsets.only(
                  top: 10.0*factor,
                  left: 10.0*factor,
                  right: 10.0*factor,
                  bottom: 15.0*factor,
                ),
                child: new RichText(
                  text: new TextSpan(
                    text: post.title,
                    style: new TextStyle(
                        fontSize: 24.0*factor,
                        color: Colors.black
                    ),
                  ),
                ),
              ),
              new Row(
                children: <Widget>[
                  new Padding(
                    padding: EdgeInsets.only(
                      left: 10.0*factor,
                      right: 5.0*factor
                    ),
                    child: new Icon(Icons.favorite, color: Colors.red, size: 26.0*factor)
                  ),
                  new Padding(
                    padding: EdgeInsets.only(
                      right: 10.0*factor
                    ),
                    child: new Text(
                        post.votes.toString(),
                        style: new TextStyle(
                            fontSize: 22.0*factor,
                            color: Colors.grey)),
                  ),
                  new Padding(
                    padding: EdgeInsets.only(
                      left: 10.0*factor,
                      right: 3.0*factor
                    ),
                    child: new Icon(Icons.face, color: Colors.lightBlue[300], size: 26.0*factor),
                  ),
                  new Text(post.viewers.toString(),
                        style: new TextStyle(fontSize: 22.0*factor, color: Colors.grey)),
                ],
              ),

              new Divider(),
              new Padding(
                padding: EdgeInsets.only(
                  left: 10.0*factor,
                  right: 10.0*factor,
                  bottom: 15.0*factor,
                ),
                child: new Text(
                  post.updateAt != post.askedAt ? '${timeago.format(DateTime.parse(post.updateAt), locale: 'zh_cn')}更新' : '${timeago.format(DateTime.parse(post.askedAt), locale: 'zh_cn')}创建',
                  style: new TextStyle(fontSize: 22.0*factor)
                )
              )
            ],
          ), 
        ),
      ),
    );
  }
}