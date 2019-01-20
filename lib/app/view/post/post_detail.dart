import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_app/app/model/post.dart';
import 'package:flutter_app/app/view/post/answer_list.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

class PostDetail extends StatefulWidget {

  final Post _post;

  PostDetail(this._post);

  @override
  PostDetailState createState() => new PostDetailState();
}

class PostDetailState extends State<PostDetail>
    with TickerProviderStateMixin {

  VoidCallback onChanged;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildAnswers() {
    List<Answer> answers = widget._post.answers;
    List<Widget> rows = new List<Widget>(answers.length);
    for (int i=0; i < answers.length; i++){
      Answer answer = answers[i];
      List<Widget> cols = new List<Widget>(answer.commets.length);
      for(int j=0; j < answer.commets.length; j++){
        Commet commet = answer.commets[j];
        cols[j] = new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new RichText(
                  text: new TextSpan(
                    text: "${commet.answer} - ${commet.answerBy},${commet.answerAt}",
                    style: new TextStyle(
                        fontSize: 20.0,
                        color: Colors.black
                    ),
                  ),
                ),
                new Divider()
              ],
            )
          ],
        );
      }
      rows[i] = new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: new Column(
                      children: <Widget>[
                        new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Icon(Icons.favorite),
                            new Text(answer.votes),
                          ],
                        )
                      ],
                    ),
                  ),
                  new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new RichText(
                        text: new TextSpan(
                          text: answer.answer,
                          style: new TextStyle(
                              fontSize: 20.0,
                              color: Colors.black
                          ),
                        ),
                      ),
                      new Row(
                        children: <Widget>[
                          new Padding(
                            padding: const EdgeInsets.only(
                              right: 10.0
                            ),
                            child: new Text(answer.answerBy),
                          ),
                          new Text(answer.answerAt),
                        ],
                      ),
                      new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: cols,
                      )
                    ],
                  )
                ],
              ),
            ],
          );
    }

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );

    // return new Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: new ListView.builder(
    //     shrinkWrap: true,
    //     itemCount: widget._post.answers.length,
    //     itemBuilder: (BuildContext context, int index) {
    //       Answer answer = widget._post.answers[index];
    //       return new Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: <Widget>[
    //           new Row(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             mainAxisSize: MainAxisSize.max,
    //             children: <Widget>[
    //               new Icon(Icons.favorite),
    //               new Text(answer.votes),
    //               new Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: <Widget>[
    //                   new RichText(
    //                     text: new TextSpan(
    //                       text: answer.answer,
    //                       style: new TextStyle(
    //                           fontSize: 20.0,
    //                           color: Colors.black
    //                       ),
    //                     ),
    //                   ),
    //                   new Row(
    //                     children: <Widget>[
    //                       new Padding(
    //                         padding: const EdgeInsets.only(
    //                           right: 10.0
    //                         ),
    //                         child: new Text(answer.answerBy),
    //                       ),
    //                       new Text(answer.answerAt),
    //                     ],
    //                   ),
    //                   new SizedBox.shrink(
    //                     child: new ListView.builder(
    //                       itemCount: answer.commets.length,
    //                       itemBuilder: (BuildContext context, int commetIndex) {
    //                         Commet commet = answer.commets[commetIndex];
    //                         return new Column(
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           children: <Widget>[
    //                             new RichText(
    //                               text: new TextSpan(
    //                                 text: "${commet.answer} - ${commet.answerBy},${commet.answerAt}",
    //                                 style: new TextStyle(
    //                                     fontSize: 20.0,
    //                                     color: Colors.black
    //                                 ),
    //                               ),
    //                             ),
    //                             new Divider()
    //                           ],
    //                         );
    //                       },
    //                     )
    //                   )
    //                 ],
    //               )
    //             ],
    //           ),
    //         ],
    //       );
    //     },
    //   )
    // );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          elevation: 0.0,
          title: new Text("帖子详情",
              style: new TextStyle(fontSize: 20.0, color: Colors.white)),
        ),
        body: new SingleChildScrollView(
          child: new Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: 10.0
                ),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new RichText(
                      text: new TextSpan(
                        text: widget._post.title,
                        style: new TextStyle(
                            fontSize: 18.0,
                            color: Colors.black
                        ),
                      ),
                    ),
                    new Divider(),
                    new Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Container(
                          width: 70.0,
                          padding: const EdgeInsets.only(right: 15.0),
                          child: new Column(
                            children: <Widget>[
                              new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Icon(Icons.favorite),
                                  new Text(widget._post.votes),
                                ],
                              )
                            ],
                          ),
                        ),
                        new Expanded(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new RichText(
                                text: new TextSpan(
                                  text: widget._post.detail,
                                  style: new TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.black
                                  ),
                                ),
                              ),
                              new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Padding(
                                    padding: const EdgeInsets.only(
                                      right: 10.0
                                    ),
                                    child: new Text(widget._post.askedBy),
                                  ),
                                  new Text(widget._post.askedAt),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    new Divider(),
                    new Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: new Text('${widget._post.answers.length}个回答：'),
                    ),
                    new AnswerList(widget._post.answers)
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }
}