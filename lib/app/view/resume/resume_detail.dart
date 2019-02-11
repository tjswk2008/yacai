import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_app/app/model/resume.dart';
import 'package:flutter_app/app/view/resume/personal_info.dart';
import 'package:flutter_app/app/view/resume/job_expectation.dart';
import 'package:flutter_app/app/view/resume/company_experience.dart';
import 'package:flutter_app/app/view/resume/project.dart';
import 'package:flutter_app/app/view/resume/education.dart';
import 'package:flutter_app/app/view/resume/certification.dart';
import 'package:flutter_app/app/view/resume/certification_edit.dart';
import 'package:flutter_app/app/view/resume/company_experience_edit.dart';
import 'package:flutter_app/app/view/resume/project_edit.dart';
import 'package:flutter_app/app/view/resume/education_edit.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/app/model/app.dart';
import 'package:flutter_app/actions/actions.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

List<String> jobStatusArr = <String>[
  "离职-随时到岗",
  "在职-月内到岗",
  "在职-考虑机会",
  "在职-暂不考虑",
];

class ResumeDetail extends StatefulWidget {

  ResumeDetail();

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
          addButton(btnName),
        ],
      ),
    );
  }
  
  Widget jobStatusOption(BuildContext context, int index) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return new InkWell(
          onTap: () {
            Resume resume = state.resume;
            resume.jobStatus = jobStatusArr[index];
            StoreProvider.of<AppState>(context).dispatch(SetResumeAction(resume));
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
    );
  }

  Widget addButton(String text) {
    Widget widget;
    switch (text) {
      case '添加工作经历':
        widget = new CompanyExperienceEditView(new CompanyExperience(
          cname: '',
          jobTitle: '',
          detail: '',
          performance: '',
          startTime: formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd])
        ));
        break;
      case '添加项目经历':
        widget = new ProjectEditView(new Project(
          name: '',
          role: '',
          detail: '',
          performance: '',
          startTime: formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd])
        ));
        break;
      case '添加教育经历':
        widget = new EducationEditView(new Education(
          name: '',
          academic: '',
          detail: '',
          major: '',
          startTime: formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd])
        ));
        break;
      case '添加证书':
        widget = new CertificationEditView(new Certification(
          name: '',
          industry: '',
          qualifiedTime: formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]),
          code: '',
        ));
        break;
      default:
    }
    return new InkWell(
      onTap: () {
        Navigator.of(context).push(new PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) {
            return widget;
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
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, appState) {
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
                          new PersonalInfoView(appState.resume.personalInfo),
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
                                  new Text(appState.resume.jobStatus)
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
                                new JobExpectation(appState.resume.jobExpect),
                              ],
                            ),
                          ),
                          new Divider(),
                          addExperience(
                            "工作经历",
                            "添加工作经历",
                            appState.resume.companyExperiences,
                            (context, int index) {
                              return new CompanyExperienceView(appState.resume.companyExperiences[index]);
                            }
                          ),
                          new Divider(),
                          addExperience(
                            "项目经历",
                            "添加项目经历",
                            appState.resume.projects,
                            (context, int index) {
                              return new ProjectView(appState.resume.projects[index]);
                            }
                          ),
                          new Divider(),
                          addExperience(
                            "教育经历",
                            "添加教育经历",
                            appState.resume.educations,
                            (context, int index) {
                              return new EducationView(appState.resume.educations[index]);
                            }
                          ),
                          new Divider(),
                          addExperience(
                            "证书",
                            "添加证书",
                            appState.resume.certificates,
                            (context, int index) {
                              return new CertificationView(appState.resume.certificates[index]);
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
                        child:  new Text('我的简历'),
                      ),
                      new Text('预览')
                    ]
                  ),
                )
              ),
            ],
          )
        );
      }
    );
  }
}