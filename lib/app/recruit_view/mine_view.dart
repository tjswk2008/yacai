import 'package:flutter/material.dart';
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
import 'package:flutter_easyrefresh/delivery_header.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:flutter_app/app/model/job.dart';
import 'package:flutter_app/splash.dart';
import 'package:flutter_app/app/recruit_view/resume_list.dart';

class MineTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MineTabState();
}

class MineTabState extends State<MineTab> {
  
  String userAvatar = '';
  String jobStatus = '';
  String userName = '';
  bool isRequesting = false;
  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();
  

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
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    final double _appBarHeight = 250.0*factor;
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, appState) {
        return new Scaffold(
          appBar: PreferredSize(
            child: AppBar(elevation: 0.0,),
            preferredSize: Size.fromHeight(0)
          ),
          backgroundColor: Color(0xFFEEEEEE),
          body: Stack(
            children: <Widget>[
              SafeArea(
                child: EasyRefresh(
                  key: _easyRefreshKey,
                  refreshHeader: DeliveryHeader(
                    key: _headerKey,
                  ),
                  onRefresh: () async {
                    Response response = await Api().login(userName, null);
                    List<Response> resList = await Future.wait([Api().getCompanyInfo(response.data['id']), Api().getRecruitJobList(userName)]);
                    StoreProvider.of<AppState>(context).dispatch(SetJobsAction(Job.fromJson(resList[1].data['list'])));
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
                    StoreProvider.of<AppState>(context).dispatch(SetCompanyAction(company));
                  },
                  child: Column(
                    children: <Widget>[
                      new Container(
                        height: _appBarHeight,
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
                        child: new GestureDetector(
                          onTap: () {
                            if(userName != '') return;
                            _login();
                          },
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              new Padding(
                                padding: EdgeInsets.only(
                                  top: 60.0*factor,
                                  left: 60.0*factor,
                                  right: 60.0*factor,
                                ),
                                child: appState.resume == null || appState.resume.personalInfo.avatar == ''
                                  ? new Image.asset(
                                      "assets/images/ic_avatar_default.png",
                                      width: 120.0*factor,
                                    )
                                  : new CircleAvatar(
                                    radius: 60.0*factor,
                                    backgroundImage: new NetworkImage(appState.resume.personalInfo.avatar)
                                  )
                              ),

                              new Row(
                                children: <Widget>[
                                  new Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      new Padding(
                                          padding: EdgeInsets.only(
                                            top: 85.0*factor,
                                          ),
                                          child: new Text(
                                              userName == '' ? "点击头像登录" : userName,
                                              style: new TextStyle(
                                                  color: Colors.white, fontSize: 30.0*factor))
                                      ),
                                      new Text(
                                          appState.resume == null || appState.resume.jobStatus == '' ? "" : appState.resume.jobStatus,
                                          style: new TextStyle(
                                              color: Colors.white, fontSize: 30.0*factor)
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ),

                      new Column(
                        children: <Widget>[
                          new InkWell(
                            onTap: () {
                              if(userName == '') {
                                _login();
                              } else {
                                _navToViewerList();
                              }
                            },
                            child: new Container(
                              height: 80.0*factor,
                              margin: EdgeInsets.only(top: 10.0*factor, bottom: 10.0*factor),
                              decoration: new BoxDecoration(
                                color: Colors.white,
                              ),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Padding(
                                    padding: EdgeInsets.all(20.0*factor),
                                    child: new Row(
                                      children: <Widget>[
                                        new Icon(Icons.remove_red_eye, size: 32.0*factor, color: Theme.of(context).primaryColor,),
                                        new Padding(
                                          padding: EdgeInsets.only(right: 20.0*factor),
                                        ),
                                        new Text('简历查看记录', style: TextStyle(fontSize: 26.0*factor),),
                                      ],
                                    ),
                                  ),
                                  new Icon(Icons.chevron_right, size: 32.0*factor,),
                                ],
                              ),
                            )
                          ),

                          new InkWell(
                            onTap: () {
                              if(userName == '') {
                                _login();
                              } else {
                                _navToPubJobList();
                              }
                            },
                            child: new Container(
                              height: 80.0*factor,
                              margin: EdgeInsets.only(bottom: 10.0*factor),
                              decoration: new BoxDecoration(
                                color: Colors.white,
                              ),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Padding(
                                    padding: EdgeInsets.all(20.0*factor),
                                    child: new Row(
                                      children: <Widget>[
                                        new Icon(Icons.near_me, size: 32.0*factor, color: Colors.blue,),
                                        new Padding(
                                          padding: EdgeInsets.only(right: 20.0*factor),
                                        ),
                                        new Text('投递记录', style: TextStyle(fontSize: 26.0*factor),),
                                      ],
                                    ),
                                  ),
                                  new Icon(Icons.chevron_right, size: 32.0*factor,),
                                ],
                              ),
                            )
                          ),

                          new InkWell(
                            onTap: () {
                              if(userName == '') {
                                _login();
                              } else {
                                _navToCompanyEdit(appState.company);
                              }
                            },
                            child: new Container(
                              height: 80.0*factor,
                              margin: EdgeInsets.only(bottom: 10.0*factor),
                              decoration: new BoxDecoration(
                                color: Colors.white,
                              ),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Padding(
                                    padding: EdgeInsets.all(20.0*factor),
                                    child: new Row(
                                      children: <Widget>[
                                        new Icon(Icons.business, size: 32.0*factor),
                                        new Padding(
                                          padding: EdgeInsets.only(right: 20.0*factor),
                                        ),
                                        new Text('填写企业资料', style: TextStyle(fontSize: 26.0*factor),),
                                      ],
                                    ),
                                  ),
                                  new Icon(Icons.chevron_right, size: 32.0*factor,),
                                ],
                              ),
                            )
                          ),

                          new InkWell(
                            onTap: () {
                              if(userName == '') {
                                _login();
                              } else if (appState.company.name == '' || appState.company.name == null) {
                                Scaffold.of(context).showSnackBar(new SnackBar(
                                  content: new Text("请先填写企业基本资料", style: TextStyle(fontSize: 20.0*factor),),
                                ));
                                return;
                              } else {
                                _navToVerification(appState.company);
                              }
                            },
                            child: new Container(
                              height: 80.0*factor,
                              margin: EdgeInsets.only(bottom: 10.0*factor),
                              decoration: new BoxDecoration(
                                color: Colors.white,
                              ),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Padding(
                                    padding: EdgeInsets.all(20.0*factor),
                                    child: new Row(
                                      children: <Widget>[
                                        new Icon(Icons.verified_user, size: 32.0*factor, color: Colors.green,),
                                        new Padding(
                                          padding: EdgeInsets.only(right: 20.0*factor),
                                        ),
                                        new Text('企业认证', style: TextStyle(fontSize: 26.0*factor),),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10*factor),
                                          child: new Text(
                                            appState.company == null || appState.company.verified == null || appState.company.verified == 0 ? '(未认证)' : appState.company.verified == 1 ? '(已认证)' : '(未通过)',
                                            style: TextStyle(
                                              fontSize: 26.0*factor,
                                              color: appState.company != null && appState.company.verified == 1 ? Colors.green : Colors.red,
                                            )
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  new Icon(Icons.chevron_right, size: 32.0*factor,),
                                ],
                              ),
                            )
                          ),

                          
                        ]
                      )
                    ],
                  ),
                ),
              ),
              
              userName != '' ? new Positioned(
                bottom: 30.0*factor,
                left: 20.0*factor,
                width: MediaQuery.of(context).size.width - 40*factor,
                child: FlatButton(
                  child: new Container(
                    height: 70*factor,
                    child: new Center(
                      child: Text(
                        "退出登录",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.0*factor,
                        ),
                      ),
                    ),
                  ),
                  color: Colors.orange[400],
                  onPressed: () async {
                    if (isRequesting) return;
                    setState(() {
                      isRequesting = true;
                    });
                    // 发送给webview，让webview登录后再取回token
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString('userName', '');
                    setState(() {
                      isRequesting = false;
                      userName = '';
                    });
                    StoreProvider.of<AppState>(context).dispatch(SetJobsAction([]));
                    StoreProvider.of<AppState>(context).dispatch(SetCompanyAction(null));
                    Navigator
                      .of(context)
                      .pushAndRemoveUntil(new MaterialPageRoute(
                        builder: (BuildContext context) => new SplashPage()), (
                        Route route) => route == null
                      );
                  }
                ),
              ) : Container(),
            ],
          )
        );
      }
    );
  }

  _login() {
    Navigator
      .of(context)
      .push(new MaterialPageRoute(builder: (context) {
        return new NewLoginPage();
      }));
  }

  _navToViewerList() {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new ResumeTab('简历查看列表', null, 2);
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

  _navToCompanyEdit(Company company) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new CompanyEdit(company);
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

  _navToVerification(Company company) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new Verification(company);
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

  _navToPubJobList() {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new PubJobList();
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
}
