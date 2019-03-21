import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_app/app/model/constants.dart';

class UserListItem extends StatelessWidget {
  final PersonalInfo personalInfo;

  UserListItem(this.personalInfo);

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return new Padding(
      padding: EdgeInsets.only(
        top: 10.0*factor,
        left: 10.0*factor,
        right: 10.0*factor,
        bottom: 10.0*factor,
      ),

      child: new Card(
        child: new Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.only(
                top: 20.0*factor,
                left: 20.0*factor,
                right: 10.0*factor,
                bottom: 15.0*factor,
              ),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        personalInfo.name,
                        style: new TextStyle(fontSize: 26.0*factor)
                      ),
                      new Row(
                        children: <Widget>[
                          new Padding(
                            padding: EdgeInsets.only(
                              top: 15.0*factor,
                              right: 10.0*factor,
                            ),
                            child: new Text(
                              personalInfo.gender,
                              textAlign: TextAlign.left,
                              style: new TextStyle(
                                  fontSize: 22.0*factor, color: Colors.grey),
                            )
                          ),
                          new Padding(
                            padding: EdgeInsets.only(
                              top: 15.0*factor,
                              right: 10.0*factor,
                            ),
                            child: new Text(
                              yearsOffset(personalInfo.birthDay).toString() + "岁",
                              style: new TextStyle(fontSize: 22.0*factor, color: Colors.red)
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  personalInfo.avatar == null ? new Image.asset(
                    "assets/images/ic_avatar_default.png",
                    width: 90.0*factor,
                  ) : new CircleAvatar(
                    radius: 45.0*factor,
                    backgroundImage: new NetworkImage(personalInfo.avatar)
                  )
                ],
              ),
            ),
            new Divider(),
            new Row(
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(
                    top: 10.0*factor,
                    left: 20.0*factor,
                    right: 10.0*factor,
                    bottom: 15.0*factor,
                  ),
                  child: new Text(yearsOffset(personalInfo.firstJobTime).toString() + "年经验",
                      style: new TextStyle(fontSize: 22*factor, color: new Color.fromARGB(
                          255, 0, 215, 198))),
                ),
                new Padding(
                  padding: EdgeInsets.only(
                    top: 10.0*factor,
                    bottom: 15.0*factor,
                  ),
                  child: new Text(academicArr[personalInfo.academic], style: new TextStyle(fontSize: 22*factor))
                ),
                personalInfo.school != null ? new Padding(
                  padding: EdgeInsets.only(
                    top: 10.0*factor,
                    right: 10.0*factor,
                    bottom: 15.0*factor,
                  ),
                  child: new Text('(${personalInfo.school})', style: new TextStyle(fontSize: 22*factor))
                ) : Container(),
              ],
            ),
          ],
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