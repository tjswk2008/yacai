import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_app/app/model/resume.dart';
import 'package:flutter_app/app/view/resume/personal_info.dart';
import 'package:flutter_app/app/view/resume/job_expectation.dart';
import 'package:flutter_app/app/view/resume/company_experience.dart';
import 'package:flutter_app/app/view/resume/project.dart';
import 'package:flutter_app/app/view/resume/education.dart';
import 'package:flutter_app/app/view/resume/certification.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

List<String> jobStatusArr = <String>[
  "离职-随时到岗",
  "在职-月内到岗",
  "在职-考虑机会",
  "在职-暂不考虑",
];

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
            new ListView.builder(
              shrinkWrap: true,
              itemCount: jobStatusArr.length,
              itemBuilder: jobStatusOption
            ),
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
  
  Widget jobStatusOption(BuildContext context, int index) {
    return new InkWell(
      onTap: () {
        _setJobStatus(jobStatusArr[index]);
        Navigator.pop(context);
      },
      child: new Container(
        height: 24,
        decoration: new BoxDecoration(
          border: new Border.all(color: jobStatus == jobStatusArr[index] ? const Color(0xffcccccc) : Colors.transparent),
        ),
        child: new Center(
          child: new Text(jobStatusArr[index]),
        ),
      ),
    );
  }

  Widget addButton(String text) {
    return new InkWell(
      onTap: () {
        print(text);
      },
      child: new Container(
        height: 30.0,
        decoration: new BoxDecoration(
          border: new Border.all(color: const Color(0xffcccccc)),
          borderRadius: new BorderRadius.all(new Radius.circular(3.0))
        ),
        child: new Center(
          child: new Text(text, style: new TextStyle(color: Colors.black, fontSize: 10.0),),
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
                mainAxisSize: MainAxisSize.max,
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
                        new Padding(
                          padding: const EdgeInsets.only(
                            top: 5.0
                          ),
                          child: new Column(
                            children: <Widget>[
                              new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  new Text(
                                    "工作经历",
                                    style: new TextStyle(
                                      fontSize: 16.0
                                    )
                                  ),
                                ],
                              ),
                              new ListView.builder(
                                shrinkWrap: true,
                                itemCount: widget._resume.companyExperiences.length,
                                itemBuilder: (context, int index) {
                                  return new CompanyExperienceView(widget._resume.companyExperiences[index]);
                                }
                              ),
                              new Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                              ),
                              addButton("添加工作经历"),
                            ],
                          ),
                        ),
                        new Divider(),
                        new Padding(
                          padding: const EdgeInsets.only(
                            top: 5.0
                          ),
                          child: new Column(
                            children: <Widget>[
                              new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  new Text(
                                    "项目经历",
                                    style: new TextStyle(
                                      fontSize: 16.0
                                    )
                                  ),
                                ],
                              ),
                              new ListView.builder(
                                shrinkWrap: true,
                                itemCount: widget._resume.companyExperiences.length,
                                itemBuilder: (context, int index) {
                                  return new ProjectView(widget._resume.projects[index]);
                                }
                              ),
                              new Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                              ),
                              addButton("添加项目经历"),
                            ],
                          ),
                        ),
                        new Divider(),
                        new Padding(
                          padding: const EdgeInsets.only(
                            top: 5.0
                          ),
                          child: new Column(
                            children: <Widget>[
                              new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  new Text(
                                    "教育经历",
                                    style: new TextStyle(
                                      fontSize: 16.0
                                    )
                                  ),
                                ],
                              ),
                              new ListView.builder(
                                shrinkWrap: true,
                                itemCount: widget._resume.educations.length,
                                itemBuilder: (context, int index) {
                                  return new EducationView(widget._resume.educations[index]);
                                }
                              ),
                              new Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                              ),
                              addButton("添加教育经历"),
                            ],
                          ),
                        ),
                        new Divider(),
                        new Padding(
                          padding: const EdgeInsets.only(
                            top: 5.0
                          ),
                          child: new Column(
                            children: <Widget>[
                              new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  new Text(
                                    "证书",
                                    style: new TextStyle(
                                      fontSize: 16.0
                                    )
                                  ),
                                ],
                              ),
                              new ListView.builder(
                                shrinkWrap: true,
                                itemCount: widget._resume.educations.length,
                                itemBuilder: (context, int index) {
                                  return new CertificationView(widget._resume.certificates[index]);
                                }
                              ),
                              new Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                              ),
                              addButton("添加证书"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
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