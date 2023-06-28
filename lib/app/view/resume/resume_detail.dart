import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
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
import 'package:flutter_app/app/model/constants.dart';
import 'package:flutter_app/app/component/select.dart';
import 'package:flutter_app/app/view/resume/resume_preview.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

class ResumeDetail extends StatefulWidget {
  ResumeDetail();

  @override
  ResumeDetailState createState() => new ResumeDetailState();
}

class ResumeDetailState extends State<ResumeDetail>
    with TickerProviderStateMixin {
  VoidCallback onChanged;
  String jobStatus;
  bool isRequesting = false;
  String userName;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      setState(() {
        userName = prefs.getString('userName');
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget addExperience(double factor, String title, String btnName, List list,
      IndexedWidgetBuilder itemBuilder) {
    return new Padding(
      padding: EdgeInsets.symmetric(
          vertical: 40.0 * factor, horizontal: 30 * factor),
      child: new Column(
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(bottom: 30.0 * factor),
                child: new Text(title,
                    style: new TextStyle(
                        fontSize: 32.0 * factor,
                        color: Colors.grey[800],
                        fontWeight: prefix0.FontWeight.bold)),
              )
            ],
          ),
          list == null
              ? Container()
              : new ListView.builder(
                  physics: new NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: itemBuilder),
          new Padding(
            padding: EdgeInsets.only(bottom: 30.0 * factor),
          ),
          addButton(btnName, factor),
        ],
      ),
    );
  }

  Widget addButton(String text, double factor) {
    Widget widget;
    switch (text) {
      case '添加工作经历':
        widget = new CompanyExperienceEditView(new CompanyExperience(
            cname: '',
            jobTitle: '',
            detail: '',
            performance: '',
            startTime: formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd])));
        break;
      case '添加项目经历':
        widget = new ProjectEditView(new Project(
            name: '',
            role: '',
            detail: '',
            performance: '',
            startTime: formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd])));
        break;
      case '添加教育经历':
        widget = new EducationEditView(new Education(
            name: '',
            academic: 0,
            detail: '',
            major: '',
            startTime: formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd])));
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
            transitionsBuilder: _pageAnimation));
      },
      child: new Container(
        height: 70.0 * factor,
        decoration: new BoxDecoration(
            border: new Border.all(color: const Color(0xffcccccc)),
            borderRadius:
                new BorderRadius.all(new Radius.circular(6.0 * factor))),
        child: new Center(
          child: new Text(
            text,
            style:
                new TextStyle(fontSize: 28.0 * factor, color: Colors.grey[800]),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width / 750;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, appState) {
          return new Scaffold(
            backgroundColor: Colors.white,
            appBar: new AppBar(
              elevation: 0.0,
              leading: IconButton(
                  icon: const BackButtonIcon(),
                  iconSize: 40 * factor,
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                  onPressed: () {
                    Navigator.maybePop(context);
                  }),
              title: Text('我的简历',
                  style:
                      TextStyle(fontSize: 30.0 * factor, color: Colors.white)),
              actions: <Widget>[
                new PopupMenuButton(
                    onSelected: (int value) async {
                      if (value == 0) {
                        Response response = await Api().login(userName, null);
                        Navigator.of(context).push(new PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (BuildContext context, _, __) {
                              return new ResumePreview(
                                  response.data['id'], null);
                            },
                            transitionsBuilder: _pageAnimation));
                      } else {
                        Response response = await Api().refreshResume(userName);
                        if (response.data['code'] != 1) {
                          showDialog<Null>(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return new AlertDialog(
                                content: Center(
                                    child: Text(
                                  "刷新失败，请稍后重试~",
                                  style: TextStyle(fontSize: 28 * factor),
                                )),
                                actions: <Widget>[
                                  new TextButton(
                                    child: new Text(
                                      '知道了',
                                      style: TextStyle(
                                          fontSize: 26 * factor,
                                          color: Colors.orange),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                          return;
                        }
                        showDialog<Null>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return new AlertDialog(
                              content: Text(
                                "刷新成功~",
                                style: TextStyle(fontSize: 28 * factor),
                              ),
                              actions: <Widget>[
                                new TextButton(
                                  child: new Text(
                                    '知道了',
                                    style: TextStyle(
                                        fontSize: 26 * factor,
                                        color: Colors.orange),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
                          new PopupMenuItem(
                              value: 0,
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        EdgeInsets.only(right: 25 * factor),
                                    child: Icon(
                                      Icons.remove_red_eye,
                                      size: 28 * factor,
                                    ),
                                  ),
                                  Text(
                                    "预览简历",
                                    style: TextStyle(fontSize: 22 * factor),
                                  )
                                ],
                              )),
                          new PopupMenuItem(
                              value: 1,
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        EdgeInsets.only(right: 25 * factor),
                                    child: Icon(
                                      Icons.refresh,
                                      size: 28 * factor,
                                    ),
                                  ),
                                  Text(
                                    "刷新简历",
                                    style: TextStyle(fontSize: 22 * factor),
                                  )
                                ],
                              ))
                        ])
              ],
            ),
            body: new SingleChildScrollView(
                child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(
                      left: 25.0 * factor * factor,
                      right: 25.0 * factor,
                      top: 20.0 * factor),
                ),
                new Container(
                  color: Colors.white,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new PersonalInfoView(
                          appState.resume.personalInfo, true, true),
                      Container(
                        color: Colors.grey[100],
                        height: 10 * factor,
                      ),
                      new Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 40.0 * factor, horizontal: 30 * factor),
                          child: new InkWell(
                            onTap: () {
                              // _showJobStatus(context);
                              YCPicker.showYCPicker(
                                context,
                                selectItem: (res) async {
                                  if (isRequesting) return;
                                  setState(() {
                                    isRequesting = true;
                                  });
                                  // 发送给webview，让webview登录后再取回token
                                  Api()
                                      .saveJobStatus(res, userName)
                                      .then((Response response) {
                                    setState(() {
                                      isRequesting = false;
                                    });
                                    if (response.data['code'] != 1) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(new SnackBar(
                                        content: new Text("保存失败！"),
                                      ));
                                      return;
                                    }
                                    Resume resume = appState.resume;
                                    resume.jobStatus = res;
                                    StoreProvider.of<AppState>(context)
                                        .dispatch(SetResumeAction(resume));
                                  }).catchError((e) {
                                    setState(() {
                                      isRequesting = false;
                                    });
                                    print(e);
                                  });
                                },
                                data: jobStatusArr,
                              );
                            },
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Text("求职状态：",
                                    style: new TextStyle(
                                        fontSize: 32.0 * factor,
                                        fontWeight: prefix0.FontWeight.bold,
                                        color: Colors.grey[800])),
                                new Text(
                                  appState.resume.jobStatus == null
                                      ? '请选择'
                                      : appState.resume.jobStatus,
                                  style: TextStyle(fontSize: 26.0 * factor),
                                )
                              ],
                            ),
                          )),
                      Container(
                        color: Colors.grey[100],
                        height: 10 * factor,
                      ),
                      new Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 40.0 * factor, horizontal: 30 * factor),
                        child: new Column(
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                new Text("求职期望：",
                                    style: new TextStyle(
                                        fontSize: 32.0 * factor,
                                        fontWeight: prefix0.FontWeight.bold,
                                        color: Colors.grey[800])),
                              ],
                            ),
                            new Padding(
                              padding: EdgeInsets.only(top: 30.0 * factor),
                            ),
                            new JobExpectation(appState.resume.jobExpect, true),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.grey[100],
                        height: 10 * factor,
                      ),
                      addExperience(factor, "工作经历：", "添加工作经历",
                          appState.resume.companyExperiences,
                          (context, int index) {
                        return new Column(
                          children: <Widget>[
                            new CompanyExperienceView(
                                appState.resume.companyExperiences[index],
                                true,
                                true),
                            index ==
                                    appState.resume.companyExperiences.length -
                                        1
                                ? new Container()
                                : new Divider()
                          ],
                        );
                      }),
                      Container(
                        color: Colors.grey[100],
                        height: 10 * factor,
                      ),
                      addExperience(
                          factor, "项目经历：", "添加项目经历", appState.resume.projects,
                          (context, int index) {
                        return new Column(
                          children: <Widget>[
                            new ProjectView(
                                appState.resume.projects[index], true),
                            index == appState.resume.projects.length - 1
                                ? new Container()
                                : new Divider()
                          ],
                        );
                      }),
                      Container(
                        color: Colors.grey[100],
                        height: 10 * factor,
                      ),
                      addExperience(
                          factor, "教育经历：", "添加教育经历", appState.resume.educations,
                          (context, int index) {
                        return new Column(
                          children: <Widget>[
                            new EducationView(
                                appState.resume.educations[index], true),
                            index == appState.resume.educations.length - 1
                                ? new Container()
                                : new Divider()
                          ],
                        );
                      }),
                      Container(
                        color: Colors.grey[100],
                        height: 10 * factor,
                      ),
                      addExperience(
                          factor, "证书：", "添加证书", appState.resume.certificates,
                          (context, int index) {
                        return new Column(
                          children: <Widget>[
                            new CertificationView(
                                appState.resume.certificates[index], true),
                            index == appState.resume.certificates.length - 1
                                ? new Container()
                                : new Divider()
                          ],
                        );
                      }),
                    ],
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(bottom: 50.0 * factor),
                )
              ],
            )),
          );
        });
  }

  Widget _pageAnimation(_, Animation<double> animation, __, Widget child) {
    return new FadeTransition(
      opacity: animation,
      child: new SlideTransition(
          position: new Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(animation),
          child: child),
    );
  }
}
