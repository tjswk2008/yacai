import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:flutter_app/app/model/constants.dart';
import 'package:flutter_app/app/view/resume/personal_info_edit.dart';
import 'package:date_format/date_format.dart';

class PersonalInfoView extends StatelessWidget {

  final PersonalInfo personalInfo;
  final bool _editable;

  PersonalInfoView(this.personalInfo, this._editable);

  static int yearsOffset(String dateTime) {
    DateTime now = DateTime.parse(formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]));
    int v = now.millisecondsSinceEpoch - DateTime.parse(dateTime).millisecondsSinceEpoch;
    if (v < 0) v = -v;
    return v ~/ (86400000 * 30 * 12);
  }

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return new Padding(
      padding: EdgeInsets.only(top: 10.0*factor),
      child: new InkWell(
        onTap: () {
          if(!_editable) return;
          Navigator.of(context).push(new PageRouteBuilder(
            opaque: false,
            pageBuilder: (BuildContext context, _, __) {
              return new PersonalInfoEditView(personalInfo);
            },
            transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
              return new FadeTransition(
                opacity: animation,
                child: new SlideTransition(position: new Tween<Offset>(
                  begin: const Offset(0.0, 1.0),
                  end: Offset.zero,
                ).animate(animation), child: child),
              );
            }
          ));
        },
        child: new Card(
          elevation: 0.0,
          child: new Column(
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 20.0*factor, right: 10*factor),
                            child: new Text(
                              personalInfo.name == null ? '姓名' : personalInfo.name,
                              textAlign: TextAlign.left,
                              style: new TextStyle(fontSize: 30.0*factor),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 20.0*factor),
                            child: new Text(
                              personalInfo.gender == null ? '' : '(${personalInfo.gender})',
                              textAlign: TextAlign.left,
                              style: new TextStyle(fontSize: 20.0*factor),
                            ),
                          ),
                        ],
                      ),
                      new Row(
                        children: <Widget>[
                          new Padding(
                            padding: EdgeInsets.only(right: 15.0*factor),
                            child: new Text(
                              personalInfo.firstJobTime == null ? '首次参加工作时间' : yearsOffset(personalInfo.firstJobTime).toString() + "年经验",
                              textAlign: TextAlign.left,
                              style: new TextStyle(fontSize: 20.0*factor),
                            ),
                          ),
                          new Padding(
                            padding: EdgeInsets.only(right: 15.0*factor),
                            child: new Text(
                              personalInfo.birthDay == null ? '出生年月' : yearsOffset(personalInfo.birthDay).toString() + "岁",
                              textAlign: TextAlign.left,
                              style: new TextStyle(fontSize: 20.0*factor),
                            ),
                          ),
                          new Text(
                            personalInfo.academic != null ? academicArr[personalInfo.academic + 1] : '',
                            textAlign: TextAlign.left,
                            style: new TextStyle(fontSize: 20.0*factor),
                          ),
                        ],
                      )
                    ]
                  ),

                  personalInfo.avatar == null ? new Image.asset(
                      "assets/images/ic_avatar_default.png",
                      width: 90.0*factor,
                    )
                  : new CircleAvatar(
                    radius: 45.0*factor,
                    backgroundImage: new NetworkImage(personalInfo.avatar)
                  )
                ],
              ),
              
              new Divider(),
              
              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  new Padding(
                    padding: EdgeInsets.only(
                      top: 5.0*factor,
                      bottom: 5.0*factor,
                    ),
                    child: new Text(personalInfo.summarize == null ? '优势' : personalInfo.summarize, style: new TextStyle(
                        fontSize: 20.0*factor, color: Colors.grey)),
                  ),
                ],
              ),
              
              new Divider(),
            ],
          ),
        ),
      ),
    );
  }
}