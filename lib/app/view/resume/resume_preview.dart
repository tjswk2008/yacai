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
import 'package:flutter_app/app/recruit_view/invite.dart';
import 'package:flutter_app/app/view/resume/certification.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

class ResumePreview extends StatefulWidget {
  final int userId;
  final int jobId;

  ResumePreview(this.userId, this.jobId);

  @override
  ResumePreviewState createState() => new ResumePreviewState();
}

class ResumePreviewState extends State<ResumePreview>
    with TickerProviderStateMixin {

  VoidCallback onChanged;
  String jobStatus;
  Resume resume;
  bool isRequesting = true;

  @override
  void initState() {
    super.initState();
    Api().getUserInfo(widget.userId)
      .then((Response response) {
        if(response.data['code'] == 1) {
          setState(() {
            resume = Resume.fromMap(response.data['info']);
          });
          return SharedPreferences.getInstance();
        }
      })
      .then((SharedPreferences prefs) {
        return Api().viewResume(prefs.getString('userName'), widget.userId);
      })
      .then((Response response) {
        if(response.data['code'] == 1) {
          print(response.data['code']);
        }
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

  Widget addExperience(double factor, String title, String btnName, List list, IndexedWidgetBuilder itemBuilder) {
    return new Padding(
      padding: EdgeInsets.only(
        top: 5.0*factor
      ),
      child: new Column(
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(bottom: 10.0*factor),
                child: new Text(
                  title,
                  style: new TextStyle(
                    fontSize: 24.0*factor
                  )
                ),
              )
            ],
          ),
          new Padding(
            padding: EdgeInsets.only(left: 10.0*factor),
            child: new ListView.builder(
              physics: new NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: itemBuilder
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(bottom: 15.0*factor),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("简历详情", style: new TextStyle(color: Colors.white, fontSize: 30.0*factor)),
        leading: IconButton(
          icon: const BackButtonIcon(),
          iconSize: 40*factor,
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () {
            Navigator.maybePop(context);
          }
        ),
        iconTheme: new IconThemeData(color: Colors.white),
        actions: <Widget>[
          widget.jobId != null ? PopupMenuButton(
            onSelected: (int value){
               if(value == 0) {
                 Navigator.of(context).push(new PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return new Invite(widget.jobId, widget.userId);
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
               }
            },
            itemBuilder: (BuildContext context) =><PopupMenuItem<int>>[
              new PopupMenuItem(
                  value: 0,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 25*factor),
                        child: Icon(Icons.insert_invitation, size: 28*factor,),
                      ),
                      Text("邀请面试", style: TextStyle(fontSize: 22*factor),)
                    ],
                  )
              ),
              new PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 25*factor),
                        child: Icon(Icons.remove_red_eye, size: 28*factor,),
                      ),
                      Text("查看全部", style: TextStyle(fontSize: 22*factor),)
                    ],
                  )
              )
            ]
          ) : Container()
        ],
      ),
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
        ) : new SingleChildScrollView(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(
                  left: 25.0*factor,
                  right: 25.0*factor,
                  top: 5.0*factor
                ),
              ),
              new Container(
                padding: EdgeInsets.only(
                  left: 15.0*factor,
                  right: 15.0*factor,
                ),
                color: Colors.white,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new PersonalInfoView(resume.personalInfo, false),
                    new Padding(
                      padding: EdgeInsets.only(
                        top: 5.0*factor,
                        bottom: 5.0*factor
                      ),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Text(
                            "求职状态",
                            style: new TextStyle(
                              fontSize: 24.0*factor
                            )
                          ),
                          new Text(resume.jobStatus, style: new TextStyle(
                              fontSize: 24.0*factor
                            ))
                        ],
                      ), 
                    ),
                    new Divider(),
                    new Padding(
                      padding: EdgeInsets.only(
                        top: 5.0*factor,
                        bottom: 5.0*factor
                      ),
                      child: new Column(
                        children: <Widget>[
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                "求职期望",
                                style: new TextStyle(
                                  fontSize: 24.0*factor
                                )
                              ),
                            ],
                          ),
                          new Padding(
                            padding: EdgeInsets.only(top: 20.0*factor),
                          ),
                          new Padding(
                            padding: EdgeInsets.only(left: 10.0*factor),
                            child: new JobExpectation(resume.jobExpect, false),
                          ),
                        ],
                      ),
                    ),
                    new Divider(),
                    addExperience(
                      factor,
                      "工作经历：",
                      "添加工作经历",
                      resume.companyExperiences,
                      (context, int index) {
                        return new Column(
                          children: <Widget>[
                            new CompanyExperienceView(resume.companyExperiences[index], false),
                            index == resume.companyExperiences.length - 1 ? new Container() : new Divider()
                          ],
                        );
                      }
                    ),
                    new Divider(),
                    addExperience(
                      factor,
                      "项目经历：",
                      "添加项目经历",
                      resume.projects,
                      (context, int index) {
                        return new Column(
                          children: <Widget>[
                            new ProjectView(resume.projects[index], false),
                            index == resume.projects.length - 1 ? new Container() : new Divider()
                          ],
                        );
                      }
                    ),
                    new Divider(),
                    addExperience(
                      factor,
                      "教育经历：",
                      "添加教育经历",
                      resume.educations,
                      (context, int index) {
                        return new Column(
                          children: <Widget>[
                            new EducationView(resume.educations[index], false),
                            index == resume.educations.length - 1 ? new Container() : new Divider()
                          ],
                        );
                      }
                    ),
                    new Divider(),
                    addExperience(
                      factor,
                      "证书：",
                      "添加证书",
                      resume.certificates,
                      (context, int index) {
                        return new Column(
                          children: <Widget>[
                            new CertificationView(resume.certificates[index], false),
                            index == resume.certificates.length - 1 ? new Container() : new Divider()
                          ],
                        );
                      }
                    ),
                  ],
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(bottom: 50.0*factor),
              )
            ],
          )
        )
    );
  }
}