import 'package:flutter/cupertino.dart' as prefix1;
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
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
  String userName;
  bool canBeViewed = false;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance()
      .then((SharedPreferences prefs) {
        setState(() {
         userName =  prefs.getString('userName');
        });
        int role = prefs.getInt('role');
        if (role == 1) {
          return Api().getUserInfo(widget.userId, null);
        }
        return Api().getUserInfo(widget.userId, userName);
      })
      .then((Response response) {
        if(response.data['code'] == 1) {
          setState(() {
            resume = Resume.fromMap(response.data['info']);
            canBeViewed = response.data['info']['canBeViewed'] == null ? true : response.data['info']['canBeViewed'];
          });
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
      padding: EdgeInsets.symmetric(vertical:40.0*factor, horizontal: 30*factor),
      child: new Column(
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(bottom: 30.0*factor),
                child: new Text(
                  title,
                  style: new TextStyle(
                    fontSize: 32.0*factor,
                    fontWeight: prefix1.FontWeight.bold,
                    color: Colors.grey[800]
                  )
                ),
              )
            ],
          ),
          list.length != 0 ? new ListView.builder(
            physics: new NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: itemBuilder
          ) : Container(),
          new Padding(
            padding: EdgeInsets.only(bottom: 30.0*factor),
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
          PopupMenuButton(
            onSelected: (int value){
               if(value == 1) {
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
               } else {
                 Api().viewResume(userName, widget.userId)
                  .then((Response response) {
                    if(response.data['code'] == 1) {
                      setState(() {
                        canBeViewed = true; 
                      });
                    }
                  })
                  .catchError((e) {
                    print(e);
                  });
               }
            },
            itemBuilder: widget.jobId == null ? (BuildContext context) =><PopupMenuItem<int>>[
              new PopupMenuItem(
                  value: 0,
                  child: Row(
                    mainAxisSize: prefix0.MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 25*factor),
                        child: Icon(Icons.remove_red_eye, size: 28*factor,),
                      ),
                      Text("查看全部", style: TextStyle(fontSize: 22*factor),)
                    ],
                  )
              )
            ] : (BuildContext context) =><PopupMenuItem<int>>[
              new PopupMenuItem(
                  value: 0,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 25*factor),
                        child: Icon(Icons.remove_red_eye, size: 28*factor,),
                      ),
                      Text("查看全部", style: TextStyle(fontSize: 22*factor),)
                    ],
                  )
              ),
              new PopupMenuItem(
                  value: 1,
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
            ]
          )
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Container(
                color: Colors.white,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new PersonalInfoView(resume.personalInfo, false, canBeViewed),
                    Container(
                      color: Colors.grey[100],
                      height: 10*factor,
                    ),
                    new Padding(
                      padding: EdgeInsets.all(
                        30.0*factor,
                      ),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Text(
                            "求职状态：",
                            style: new TextStyle(
                              fontSize: 32.0*factor,
                              color: Colors.grey[800],
                              fontWeight: prefix0.FontWeight.bold
                            )
                          ),
                          new Text(resume.jobStatus == null ? '未选择' : resume.jobStatus, style: new TextStyle(
                              fontSize: 26.0*factor
                            ))
                        ],
                      ), 
                    ),
                    Container(
                      color: Colors.grey[100],
                      height: 10*factor,
                    ),
                    new Padding(
                      padding: EdgeInsets.all(
                        30.0*factor,
                      ),
                      child: new Column(
                        children: <Widget>[
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                "求职期望：",
                                style: new TextStyle(
                                  fontSize: 32.0*factor,
                                  fontWeight: prefix0.FontWeight.bold,
                                  color: Colors.grey[800]
                                )
                              ),
                            ],
                          ),
                          new Padding(
                            padding: EdgeInsets.only(top: 30.0*factor),
                          ),
                          JobExpectation(resume.jobExpect, false),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.grey[100],
                      height: 10*factor,
                    ),
                    addExperience(
                      factor,
                      "工作经历：",
                      "添加工作经历",
                      resume.companyExperiences,
                      (context, int index) {
                        return new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            canBeViewed ? CompanyExperienceView(resume.companyExperiences[index], false, canBeViewed) : 
                              index == 0 ? CompanyExperienceView(resume.companyExperiences[0], false, canBeViewed) : 
                              Text('****', style: TextStyle(fontSize: 24*factor)),
                            index == resume.companyExperiences.length - 1 ? new Container() : new Divider()
                          ],
                        );
                      }
                    ),
                    Container(
                      color: Colors.grey[100],
                      height: 10*factor,
                    ),
                    addExperience(
                      factor,
                      "项目经历：",
                      "添加项目经历",
                      resume.projects,
                      (context, int index) {
                        return new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            canBeViewed ? ProjectView(resume.projects[index], false) : 
                              index == 0 ? ProjectView(resume.projects[0], false) : 
                              Text('****', style: TextStyle(fontSize: 24*factor)),
                            index == resume.projects.length - 1 ? new Container() : new Divider()
                          ],
                        );
                      }
                    ),
                    Container(
                      color: Colors.grey[100],
                      height: 10*factor,
                    ),
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
                    Container(
                      color: Colors.grey[100],
                      height: 10*factor,
                    ),
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