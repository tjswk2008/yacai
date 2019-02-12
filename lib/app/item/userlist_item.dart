import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:date_format/date_format.dart';

class UserListItem extends StatelessWidget {
  final PersonalInfo personalInfo;

  UserListItem(this.personalInfo);

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
                        new Container(
                          height: 70.0,
                          padding: const EdgeInsets.all(20.0),
                          child: new Text(
                            personalInfo.name,
                            style: new TextStyle(fontSize: 20.0)
                          ),
                        ),
                        new Expanded(child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            new Padding(
                              padding: const EdgeInsets.only(
                                top: 30.0,
                                right: 10.0,
                              ),
                              child: new Text(
                                yearsOffset(personalInfo.birthDay).toString() + "岁",
                                textAlign: TextAlign.left,
                                style: new TextStyle(
                                    fontSize: 15.0, color: Colors.grey),
                              )
                            ),
                            new Padding(
                              padding: const EdgeInsets.only(
                                right: 10.0,
                              ),
                              child: new Text(
                                personalInfo.gender,
                                style: new TextStyle(color: Colors.red)
                              ),
                            ),
                          ],
                        ))
                      ],
                    ),

                    new Divider(),
                    new Row(
                      children: <Widget>[
                        new Padding(
                          padding: const EdgeInsets.only(
                            top: 5.0,
                            left: 20.0,
                            right: 5.0,
                            bottom: 15.0,
                          ),
                          child: new Text(yearsOffset(personalInfo.firstJobTime).toString() + "年经验",
                              style: new TextStyle(color: new Color.fromARGB(
                                  255, 0, 215, 198))),
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(
                            top: 5.0,
                            right: 5.0,
                            bottom: 15.0,
                          ),
                          child: new Text(personalInfo.academic)
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

  static int yearsOffset(String dateTime) {
    DateTime now = DateTime.parse(formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]));
    int v = now.millisecondsSinceEpoch - DateTime.parse(dateTime).millisecondsSinceEpoch;
    if (v < 0) v = -v;
    return v ~/ (86400000 * 30 * 12);
  }
}