import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/post.dart';

class PostListItem extends StatelessWidget {
  final Post post;

  PostListItem(this.post);

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.only(
        top: 3.0,
        left: 5.0,
        right: 5.0,
        bottom: 3.0,
      ),

      child: new SizedBox(
        child: new Card(
          elevation: 0.0,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  left: 10.0,
                  right: 10.0,
                  bottom: 5.0,
                ),
                child: new RichText(
                  text: new TextSpan(
                    text: post.title,
                    style: new TextStyle(
                        fontSize: 16.0,
                        color: Colors.black
                    ),
                  ),
                ),
              ),
              new Row(
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 3.0
                    ),
                    child: new Icon(Icons.favorite)
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(
                      right: 10.0
                    ),
                    child: new Text(
                        post.votes.toString(),
                        style: new TextStyle(
                            color: Colors.grey)),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 3.0
                    ),
                    child: new Icon(Icons.face),
                  ),
                  new Text(post.viewers.toString(),
                        style: new TextStyle(color: Colors.grey)),
                ],
              ),

              new Divider(),
              new Padding(
                padding: const EdgeInsets.only(
                  top: 5.0,
                  left: 10.0,
                  right: 10.0,
                  bottom: 15.0,
                ),
                child: new Text(post.latestStatus)
              )
            ],
          ), 
        ),
      ),
    );
  }
}