import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_app/app/model/post.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

class AnswerList extends StatefulWidget {

  final List<Answer> _answers;

  AnswerList(this._answers);

  @override
  AnswerListState createState() => new AnswerListState();
}

class AnswerListState extends State<AnswerList>
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

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      shrinkWrap: true,
      itemCount: widget._answers.length,
      itemBuilder: (BuildContext context, int index) {
        Answer answer = widget._answers[index];
        return new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Container(
              width: 70.0,
              padding: const EdgeInsets.only(right: 15.0),
              child: new Column(
                children: <Widget>[
                  new Row(
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
                  mainAxisAlignment: MainAxisAlignment.end,
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
                
                // new Column(
                //   children: <Widget>[
                //     new ListView.builder(
                //       shrinkWrap: true,
                //       itemCount: answer.commets.length,
                //       itemBuilder: (BuildContext context, int commetIndex) {
                //         Commet commet = answer.commets[commetIndex];
                //         return new Row(
                //           children: <Widget>[
                //             new Column(
                //               children: <Widget>[
                //                 new RichText(
                //                   text: new TextSpan(
                //                     text: "${commet.answer} - ${commet.answerBy},${commet.answerAt}",
                //                     style: new TextStyle(
                //                         fontSize: 20.0,
                //                         color: Colors.black
                //                     ),
                //                   ),
                //                 ),
                //                 new Divider()
                //               ],
                //             )
                //           ],
                //         );
                //       },
                //     )
                //   ],
                // )
              ],
            )
          ],
        );
      },
    );
  }
}