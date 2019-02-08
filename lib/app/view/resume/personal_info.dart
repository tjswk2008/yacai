import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:flutter_app/app/view/resume/personal_info_edit.dart';
import 'package:date_format/date_format.dart';

class PersonalInfoView extends StatelessWidget {

  final PersonalInfo personalInfo;

  PersonalInfoView(this.personalInfo);

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: new InkWell(
        onTap: () {
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
                      new Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: new Text(
                          personalInfo.name,
                          textAlign: TextAlign.left,
                          style: new TextStyle(fontSize: 30.0),
                        ),
                      ),
                      new Row(
                        children: <Widget>[
                          new Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: new Text(
                              personalInfo.firstJobTime,
                              textAlign: TextAlign.left,
                              style: new TextStyle(fontSize: 15.0),
                            ),
                          ),
                          new Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: new Text(
                              formatDate(DateTime.parse(personalInfo.birthDay), [yyyy, '-', mm]),
                              textAlign: TextAlign.left,
                              style: new TextStyle(fontSize: 15.0),
                            ),
                          ),
                          new Text(
                            personalInfo.academic,
                            textAlign: TextAlign.left,
                            style: new TextStyle(fontSize: 15.0),
                          ),
                        ],
                      )
                    ]
                  ),

                  new CircleAvatar(
                    radius: 35.0,
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
                    padding: const EdgeInsets.only(
                      top: 5.0,
                      bottom: 5.0,
                    ),
                    child: new Text(personalInfo.summarize, style: new TextStyle(
                        fontSize: 15.0, color: Colors.grey)),
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