import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_app/app/model/resume.dart';
import 'package:flutter_app/app/view/resume/personal_info.dart';
import 'package:flutter_app/app/view/resume/job_expectation.dart';

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
  String jobStatus;

  @override
  void initState() {
    super.initState();
    jobStatus = widget._resume.jobStatus;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showJobStatus(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context){
        return new Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Icon(Icons.close),
                new Text('求职状态', style: new TextStyle(fontSize: 20.0)),
                new Icon(Icons.check),
              ],
            ),
            jobStatusOption(context, "离职-随时到岗"),
            jobStatusOption(context, "在职-月内到岗"),
            jobStatusOption(context, "在职-考虑机会"),
            jobStatusOption(context, "在职-暂不考虑"),
          ],
        );
      }
    );
  }

  void _setJobStatus(status) {
    setState(() {
      jobStatus = status;
    });
  }
  
  Widget jobStatusOption(BuildContext context, String text) {
    return new InkWell(
      onTap: () {
        _setJobStatus(text);
        Navigator.pop(context);
      },
      child: new Container(
        height: 24,
        decoration: new BoxDecoration(
          border: new Border.all(color: jobStatus == text ? const Color(0xffcccccc) : Colors.transparent),
        ),
        child: new Center(
          child: new Text(text),
        ),
      ),
    );
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
                      padding: const EdgeInsets.only(
                        left: 15.0,
                        right: 15.0,
                      ),
                      color: Colors.white,
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new PersonalInfoView(widget._resume.personalInfo),
                          new Padding(
                            padding: const EdgeInsets.only(
                              top: 5.0,
                              bottom: 5.0
                            ),
                            child: new InkWell(
                              onTap: () {_showJobStatus(context);},
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Text(
                                    "求职状态",
                                    style: new TextStyle(
                                      fontSize: 16.0
                                    )
                                  ),
                                  new Text(jobStatus)
                                ],
                              ),
                            ) 
                          ),
                          new Divider(),
                          new Padding(
                            padding: const EdgeInsets.only(
                              top: 5.0,
                              bottom: 5.0
                            ),
                            child: new Column(
                              children: <Widget>[
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    new Text(
                                      "求职期望",
                                      style: new TextStyle(
                                        fontSize: 16.0
                                      )
                                    ),
                                  ],
                                ),
                                new Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                ),
                                new JobExpectation(widget._resume.jobExpect),
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