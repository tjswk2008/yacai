import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_app/app/model/resume.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:dio/dio.dart';
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

class ResumePreview extends StatefulWidget {
  final int userId;

  ResumePreview(this.userId);

  @override
  ResumePreviewState createState() => new ResumePreviewState();
}

class ResumePreviewState extends State<ResumePreview>
    with TickerProviderStateMixin {

  VoidCallback onChanged;
  double width;
  String jobStatus;
  Resume resume;
  bool isRequesting = true;

  @override
  void initState() {
    super.initState();
    Api().getUserInfo(widget.userId)
      .then((Response response) {
        if(response.data['code'] != 1) {
          return;
        }
        setState(() {
          resume = Resume.fromMap(response.data['info']);
        });
      })
      .catchError((e) {
        print(e);
      })
      .whenComplete(() {
        setState(() {
         isRequesting = false; 
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget addExperience(String title, String btnName, List list, IndexedWidgetBuilder itemBuilder) {
    return new Padding(
      padding: const EdgeInsets.only(
        top: 5.0
      ),
      child: new Column(
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Text(
                title,
                style: new TextStyle(
                  fontSize: 16.0
                )
              ),
            ],
          ),
          new ListView.builder(
            physics: new NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: itemBuilder
          ),
          new Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width * 0.3;
    return new Scaffold(
      backgroundColor: Colors.white,
      body: resume == null ? new Center(
          child: new Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CupertinoActivityIndicator(),
                Text("加载中，请稍等...")
              ],
            ),
          )
        ) : new Stack(
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
                      new PersonalInfoView(resume.personalInfo),
                      new Padding(
                        padding: const EdgeInsets.only(
                          top: 5.0,
                          bottom: 5.0
                        ),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Text(
                              "求职状态",
                              style: new TextStyle(
                                fontSize: 16.0
                              )
                            ),
                            new Text(resume.jobStatus)
                          ],
                        ), 
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
                            new JobExpectation(resume.jobExpect),
                          ],
                        ),
                      ),
                      new Divider(),
                      addExperience(
                        "工作经历",
                        "添加工作经历",
                        resume.companyExperiences,
                        (context, int index) {
                          return new CompanyExperienceView(resume.companyExperiences[index]);
                        }
                      ),
                      new Divider(),
                      addExperience(
                        "项目经历",
                        "添加项目经历",
                        resume.projects,
                        (context, int index) {
                          return new ProjectView(resume.projects[index]);
                        }
                      ),
                      new Divider(),
                      addExperience(
                        "教育经历",
                        "添加教育经历",
                        resume.educations,
                        (context, int index) {
                          return new EducationView(resume.educations[index]);
                        }
                      ),
                      new Divider(),
                      addExperience(
                        "证书",
                        "添加证书",
                        resume.certificates,
                        (context, int index) {
                          return new CertificationView(resume.certificates[index]);
                        }
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
            top: 0.0,
            left: -10.0,
            child: new Container(
              height: 60,
              padding: const EdgeInsets.only(top: 15.0),
              decoration: new BoxDecoration(
                color: Colors.white,
              ),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new BackButton(color: Colors.grey),
                  new Padding(
                    padding: EdgeInsets.only(left: width, right: width),
                    child:  new Text('简历详情'),
                  )
                ]
              ),
            )
          ),
        ],
      )
    );
  }
}