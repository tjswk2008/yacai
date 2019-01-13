import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_app/app/model/resume.dart';
import 'package:flutter_app/app/view/resume/personal_info.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

class ResumeDetail extends StatefulWidget {

  final Resume _resume;

  ResumeDetail(this._resume);

  @override
  ResumeDetailState createState() => new ResumeDetailState();
}

class ResumeDetailState extends State<ResumeDetail>
    with TickerProviderStateMixin {

  VoidCallback onChanged;
  double width;

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
    width = MediaQuery.of(context).size.width * 0.3;
    return new Scaffold(
        backgroundColor: Colors.white,
        body: new Stack(
          children: <Widget>[
            new SingleChildScrollView(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.all(25.0),
                    ),
                    new Container(
                      color: Colors.white,
                      child: new Column(
                        children: <Widget>[
                          new PersonalInfoView(widget._resume.personalInfo),
                          new Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Text(
                                  "求职状态",
                                  style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0
                                  )
                                ),
                                new Text(widget._resume.jobStatus)
                              ],
                            ),
                          ),
                          new Divider(),
                        ],
                      ),
                    )
                  ],
                )
            ),

            new Positioned(
              top: 10.0,
              left: -10.0,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new BackButton(color: Colors.grey),
                  new Padding(
                    padding: EdgeInsets.only(left: width, right: width),
                    child:  new Text('我的简历'),
                  ),
                  new Text('预览')
                ]
              )
            ),
          ],
        )
    );
  }
}