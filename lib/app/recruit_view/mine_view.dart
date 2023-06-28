import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:flutter_app/app/view/login_view.dart';
import 'package:flutter_app/app/recruit_view/job/job_list.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/app/model/app.dart';
import 'package:flutter_app/actions/actions.dart';
import 'package:flutter_app/app/recruit_view/verification.dart';
import 'package:flutter_app/app/model/company.dart';
import 'package:flutter_app/app/view/company/company_edit.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:flutter_app/app/model/job.dart';
import 'package:flutter_app/splash.dart';
import 'package:flutter_app/app/recruit_view/resume_list.dart';
import 'package:flutter_app/app/view/user_edit.dart';

class MineTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MineTabState();
}

class MineTabState extends State<MineTab> {
  String userAvatar = '';
  String jobStatus = '';
  String userName = '';
  bool isRequesting = false;
  PersonalInfo personalInfo;

  @override
  void initState() {
    super.initState();
    initInfo();
  }

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width / 750;
    final double _appBarHeight = 250.0 * factor;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, appState) {
          return new Scaffold(
              appBar: PreferredSize(
                  child: AppBar(
                    elevation: 0.0,
                  ),
                  preferredSize: Size.fromHeight(0)),
              backgroundColor: Colors.grey[100],
              body: Stack(
                children: <Widget>[
                  SafeArea(
                    child: EasyRefresh(
                      onRefresh: () async {
                        Response response = await Api().login(userName, null);
                        List<Response> resList = await Future.wait([
                          Api().getCompanyInfo(response.data['id']),
                          Api().getRecruitJobList(userName)
                        ]);
                        StoreProvider.of<AppState>(context).dispatch(
                            SetJobsAction(
                                Job.fromJson(resList[1].data['list'])));
                        Company company;
                        if (resList[0].data['info'] == null) {
                          company = new Company(
                            name: '', // 公司名称
                            location: '', // 公司位置
                            type: '', // 公司性质
                            size: '', // 公司规模
                            employee: '', // 公司人数
                            inc: '',
                          );
                        } else {
                          company = Company.fromMap(resList[0].data['info']);
                        }
                        StoreProvider.of<AppState>(context)
                            .dispatch(SetCompanyAction(company));
                      },
                      child: Column(
                        children: <Widget>[
                          InkWell(
                              onTap: () {
                                if (userName != '') {
                                  _setUserInfo();
                                } else {
                                  _login();
                                }
                              },
                              child: Container(
                                height: _appBarHeight,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment(0.0, -1.0),
                                    end: Alignment(0.0, -0.4),
                                    colors: <Color>[
                                      Theme.of(context).primaryColor,
                                      Theme.of(context).primaryColor
                                    ],
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    new Padding(
                                        padding: EdgeInsets.only(
                                          top: 20.0 * factor,
                                          left: 30.0 * factor,
                                          right: 20.0 * factor,
                                        ),
                                        child: personalInfo == null ||
                                                personalInfo.avatar == ''
                                            ? new Image.asset(
                                                "assets/images/avatar_default.png",
                                                width: 120.0 * factor,
                                              )
                                            : new CircleAvatar(
                                                radius: 60.0 * factor,
                                                backgroundImage:
                                                    new NetworkImage(
                                                        personalInfo.avatar))),
                                    new Row(
                                      children: <Widget>[
                                        new Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            new Padding(
                                                padding: EdgeInsets.only(
                                                  top: 40.0 * factor,
                                                  left: 20 * factor,
                                                  bottom: 20.0 * factor,
                                                ),
                                                child: new Text(
                                                    userName == ''
                                                        ? "点击头像登录"
                                                        : userName,
                                                    style: new TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            36.0 * factor))),
                                            new Text(
                                                appState.resume == null ||
                                                        appState.resume
                                                                .jobStatus ==
                                                            ''
                                                    ? ""
                                                    : appState.resume.jobStatus,
                                                style: new TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 30.0 * factor)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                          new Column(children: <Widget>[
                            new InkWell(
                                onTap: () {
                                  if (userName == '') {
                                    _login();
                                  } else {
                                    _navToViewerList();
                                  }
                                },
                                child: new Container(
                                  height: 100.0 * factor,
                                  margin: EdgeInsets.only(top: 5.0 * factor),
                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: new Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Padding(
                                        padding: EdgeInsets.only(
                                          top: 20.0 * factor,
                                          bottom: 20.0 * factor,
                                          left: 25.0 * factor,
                                          right: 20.0 * factor,
                                        ),
                                        child: new Row(
                                          children: <Widget>[
                                            new Icon(
                                              Icons.remove_red_eye,
                                              size: 42.0 * factor,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            new Padding(
                                              padding: EdgeInsets.only(
                                                  right: 15.0 * factor),
                                            ),
                                            new Text(
                                              '简历查看记录',
                                              style: TextStyle(
                                                  fontSize: 34.0 * factor),
                                            ),
                                          ],
                                        ),
                                      ),
                                      new Padding(
                                        padding: EdgeInsets.only(
                                          right: 20.0 * factor,
                                        ),
                                        child: new Icon(Icons.chevron_right,
                                            size: 42.0 * factor,
                                            color:
                                                Theme.of(context).primaryColor),
                                      )
                                    ],
                                  ),
                                )),
                            new InkWell(
                                onTap: () {
                                  if (userName == '') {
                                    _login();
                                  } else {
                                    _navToPubJobList();
                                  }
                                },
                                child: new Container(
                                  height: 100.0 * factor,
                                  margin: EdgeInsets.only(top: 5.0 * factor),
                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: new Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Padding(
                                        padding: EdgeInsets.only(
                                          top: 20.0 * factor,
                                          bottom: 20.0 * factor,
                                          left: 25.0 * factor,
                                          right: 20.0 * factor,
                                        ),
                                        child: new Row(
                                          children: <Widget>[
                                            new Icon(
                                              Icons.near_me,
                                              size: 42.0 * factor,
                                              color: Colors.blue,
                                            ),
                                            new Padding(
                                              padding: EdgeInsets.only(
                                                  right: 15.0 * factor),
                                            ),
                                            new Text(
                                              '投递记录',
                                              style: TextStyle(
                                                  fontSize: 34.0 * factor),
                                            ),
                                          ],
                                        ),
                                      ),
                                      new Padding(
                                        padding: EdgeInsets.only(
                                          right: 20.0 * factor,
                                        ),
                                        child: new Icon(Icons.chevron_right,
                                            size: 42.0 * factor,
                                            color:
                                                Theme.of(context).primaryColor),
                                      )
                                    ],
                                  ),
                                )),
                            new InkWell(
                                onTap: () {
                                  if (userName == '') {
                                    _login();
                                  } else {
                                    _navToCompanyEdit(appState.company);
                                  }
                                },
                                child: new Container(
                                  height: 100.0 * factor,
                                  margin: EdgeInsets.only(top: 5.0 * factor),
                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: new Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Padding(
                                        padding: EdgeInsets.only(
                                          top: 20.0 * factor,
                                          bottom: 20.0 * factor,
                                          left: 25.0 * factor,
                                          right: 20.0 * factor,
                                        ),
                                        child: new Row(
                                          children: <Widget>[
                                            new Icon(Icons.business,
                                                size: 42.0 * factor,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                            new Padding(
                                              padding: EdgeInsets.only(
                                                  right: 15.0 * factor),
                                            ),
                                            new Text(
                                              '填写企业资料',
                                              style: TextStyle(
                                                  fontSize: 34.0 * factor),
                                            ),
                                          ],
                                        ),
                                      ),
                                      new Padding(
                                        padding: EdgeInsets.only(
                                          right: 20.0 * factor,
                                        ),
                                        child: new Icon(Icons.chevron_right,
                                            size: 42.0 * factor,
                                            color:
                                                Theme.of(context).primaryColor),
                                      )
                                    ],
                                  ),
                                )),
                            new InkWell(
                                onTap: () {
                                  if (userName == '') {
                                    _login();
                                  } else if (appState.company.name == '' ||
                                      appState.company.name == null) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(new SnackBar(
                                      content: new Text(
                                        "请先填写企业基本资料",
                                        style:
                                            TextStyle(fontSize: 20.0 * factor),
                                      ),
                                    ));
                                    return;
                                  } else {
                                    _navToVerification(appState.company);
                                  }
                                },
                                child: new Container(
                                  height: 100.0 * factor,
                                  margin: EdgeInsets.only(top: 5.0 * factor),
                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: new Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Padding(
                                        padding: EdgeInsets.only(
                                          top: 20.0 * factor,
                                          bottom: 20.0 * factor,
                                          left: 25.0 * factor,
                                          right: 20.0 * factor,
                                        ),
                                        child: new Row(
                                          children: <Widget>[
                                            new Icon(Icons.verified_user,
                                                size: 42.0 * factor,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                            new Padding(
                                              padding: EdgeInsets.only(
                                                  right: 15.0 * factor),
                                            ),
                                            new Text(
                                              '企业认证',
                                              style: TextStyle(
                                                  fontSize: 34.0 * factor),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10 * factor),
                                              child: new Text(
                                                  appState.company == null ||
                                                          appState.company
                                                                  .verified ==
                                                              null ||
                                                          appState.company
                                                                  .verified ==
                                                              0
                                                      ? '(未认证)'
                                                      : appState.company
                                                                  .verified ==
                                                              1
                                                          ? '(已认证)'
                                                          : '(未通过)',
                                                  style: TextStyle(
                                                    fontSize: 34.0 * factor,
                                                    color: appState.company !=
                                                                null &&
                                                            appState.company
                                                                    .verified ==
                                                                1
                                                        ? Colors.green
                                                        : Colors.red,
                                                  )),
                                            )
                                          ],
                                        ),
                                      ),
                                      new Padding(
                                        padding: EdgeInsets.only(
                                          right: 20.0 * factor,
                                        ),
                                        child: new Icon(Icons.chevron_right,
                                            size: 42.0 * factor,
                                            color:
                                                Theme.of(context).primaryColor),
                                      )
                                    ],
                                  ),
                                )),
                          ])
                        ],
                      ),
                    ),
                  ),
                  userName != ''
                      ? new Positioned(
                          bottom: 0.0 * factor,
                          left: 0.0 * factor,
                          width: MediaQuery.of(context).size.width,
                          child: FlatButton(
                              child: new Container(
                                height: 90 * factor,
                                child: new Center(
                                  child: Text(
                                    "退出登录",
                                    style: TextStyle(
                                        color: Colors.orange[400],
                                        fontSize: 36.0 * factor,
                                        letterSpacing: 5 * factor),
                                  ),
                                ),
                              ),
                              color: Colors.white,
                              onPressed: () async {
                                if (isRequesting) return;
                                setState(() {
                                  isRequesting = true;
                                });
                                // 发送给webview，让webview登录后再取回token
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString('userName', '');
                                prefs.setString('token', '');
                                setState(() {
                                  isRequesting = false;
                                  userName = '';
                                });
                                StoreProvider.of<AppState>(context)
                                    .dispatch(SetJobsAction([]));
                                StoreProvider.of<AppState>(context)
                                    .dispatch(SetCompanyAction(null));
                                Navigator.of(context).pushAndRemoveUntil(
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            new SplashPage()),
                                    (Route route) => route == null);
                              }),
                        )
                      : Container(),
                ],
              ));
        });
  }

  initInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName');
    });
    Response response =
        await Api().getUserBaseInfo(prefs.getString('userName'));
    personalInfo = PersonalInfo.fromMap(response.data['info']);
  }

  _login() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new NewLoginPage();
    }));
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

  _setUserInfo() {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new UserEditView(personalInfo);
        },
        transitionsBuilder: _pageAnimation));
  }

  _navToViewerList() {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new ResumeTab('简历查看列表', null, 2);
        },
        transitionsBuilder: _pageAnimation));
  }

  _navToCompanyEdit(Company company) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new CompanyEdit(company);
        },
        transitionsBuilder: _pageAnimation));
  }

  _navToVerification(Company company) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new Verification(company);
        },
        transitionsBuilder: _pageAnimation));
  }

  _navToPubJobList() {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new PubJobList();
        },
        transitionsBuilder: _pageAnimation));
  }
}
