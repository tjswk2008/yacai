import 'package:flutter/material.dart';
import 'package:flutter_app/app/view/login_view.dart';
import 'package:flutter_app/app/view/resume/resume_detail.dart';
import 'package:flutter_app/app/view/shield_list.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/app/model/app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/app/view/jobs_view.dart';
import 'package:flutter_app/app/view/company/company_list.dart';
import 'package:flutter_app/actions/actions.dart';
import 'package:flutter_app/splash.dart';
import 'package:flutter_app/app/view/setting_view.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/delivery_header.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/model/resume.dart';
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
  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();
  PersonalInfo personalInfo;

  @override
  void initState() {
    super.initState();
    initInfo();
  }

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, appState) {
        return new Scaffold(
          appBar: PreferredSize(
            child: AppBar(elevation: 0.0,),
            preferredSize: Size.fromHeight(0)
          ),
          backgroundColor: Colors.grey[100],
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
                    Response resumeResponse = await Api().getUserInfo(response.data['id'], null);
                    Resume resume = Resume.fromMap(resumeResponse.data['info']);
                    StoreProvider.of<AppState>(context).dispatch(SetResumeAction(resume));
                  },
                  child: new Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          if(userName != '') {
                            _setUserInfo();
                          } else {
                            _login();
                          }
                        },
                        child: Container(
                          height: 250*factor,
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
                                  top: 20.0*factor,
                                  left: 30.0*factor,
                                  right: 20.0*factor,
                                ),
                                child: appState.resume == null || appState.resume.personalInfo.avatar == null || appState.resume.personalInfo.avatar == ''
                                  ? new Image.asset(
                                      "assets/images/avatar_default.png",
                                      width: 120.0*factor,
                                    )
                                  : new CircleAvatar(
                                    radius: 60.0*factor,
                                    backgroundImage: new NetworkImage(appState.resume.personalInfo.avatar)
                                  )
                              ),

                              new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      new Padding(
                                          padding: EdgeInsets.only(
                                            top: 20.0*factor,
                                            bottom: 20.0*factor,
                                          ),
                                          child: new Text(
                                              userName == '' ? "点击头像登录" : appState.resume.personalInfo.name == null ? '快去编辑简历填写您的姓名吧' : appState.resume.personalInfo.name,
                                              style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 36.0*factor))
                                      ),
                                      new Text(
                                          (appState.resume == null || appState.resume.jobStatus == null || appState.resume.jobStatus == '') ? "" : appState.resume.jobStatus,
                                          style: new TextStyle(color: Colors.white, fontSize: 30.0*factor)
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                            ],
                          )
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          new InkWell(
                            onTap: () {
                              if(userName == '') {
                                _login();
                              } else {
                                _navToResumeDetail();
                              }
                            },
                            child: new Container(
                              height: 100.0*factor,
                              margin: EdgeInsets.only(top: 5.0*factor),
                              decoration: new BoxDecoration(
                                color: Colors.white,
                              ),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Padding(
                                    padding: EdgeInsets.only(
                                      top: 20.0*factor,
                                      bottom: 20.0*factor,
                                      left: 25.0*factor,
                                      right: 20.0*factor,
                                    ),
                                    child: new Row(
                                      children: <Widget>[
                                        Image.asset('assets/images/resume.png', width: 42.0*factor),
                                        new Padding(
                                          padding: EdgeInsets.only(right: 15.0*factor),
                                        ),
                                        new Text('我的简历', style: TextStyle(fontSize: 34.0*factor),),
                                      ],
                                    ),
                                  ),
                                  new Padding(
                                    padding: EdgeInsets.only(
                                      right: 20.0*factor,
                                    ),
                                    child: new Icon(Icons.chevron_right, size: 42.0*factor, color: Theme.of(context).primaryColor),
                                  )
                                  
                                ],
                              ),
                            )
                          ),
                          
                          new InkWell(
                            onTap: () {
                              if(userName == '') {
                                _login();
                              } else {
                                _navToFavoriteList();
                              }
                            },
                            child: new Container(
                              height: 100.0*factor,
                              margin: EdgeInsets.only(top: 5.0*factor),
                              decoration: new BoxDecoration(
                                color: Colors.white,
                              ),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Padding(
                                    padding: EdgeInsets.only(
                                      top: 20.0*factor,
                                      bottom: 20.0*factor,
                                      left: 25.0*factor,
                                      right: 20.0*factor,
                                    ),
                                    child: new Row(
                                      children: <Widget>[
                                        new Icon(Icons.favorite_border, size: 42.0*factor, color: Theme.of(context).primaryColor),
                                        new Padding(
                                          padding: EdgeInsets.only(right: 15.0*factor),
                                        ),
                                        new Text('职位收藏', style: TextStyle(fontSize: 34.0*factor),),
                                      ],
                                    ),
                                  ),
                                  new Padding(
                                    padding: EdgeInsets.only(
                                      right: 20.0*factor,
                                    ),
                                    child: new Icon(Icons.chevron_right, size: 42.0*factor, color: Theme.of(context).primaryColor),
                                  )
                                ],
                              ),
                            )
                          ),

                          new InkWell(
                            onTap: () {
                              if(userName == '') {
                                _login();
                              } else {
                                _navToDeliveryList(4, '申请记录');
                              }
                            },
                            child: new Container(
                              height: 100.0*factor,
                              margin: EdgeInsets.only(top: 5.0*factor),
                              decoration: new BoxDecoration(
                                color: Colors.white,
                              ),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Padding(
                                    padding: EdgeInsets.only(
                                      top: 20.0*factor,
                                      bottom: 20.0*factor,
                                      left: 25.0*factor,
                                      right: 20.0*factor,
                                    ),
                                    child: new Row(
                                      children: <Widget>[
                                        Container(width: 3*factor,),
                                        Image.asset('assets/images/record.png', width: 36.0*factor),
                                        new Padding(
                                          padding: EdgeInsets.only(right: 18.0*factor),
                                        ),
                                        new Text('申请记录', style: TextStyle(fontSize: 34.0*factor),),
                                      ],
                                    ),
                                  ),
                                  new Padding(
                                    padding: EdgeInsets.only(
                                      right: 20.0*factor,
                                    ),
                                    child: new Icon(Icons.chevron_right, size: 42.0*factor, color: Theme.of(context).primaryColor),
                                  )
                                ],
                              ),
                            )
                          ),

                          new InkWell(
                            onTap: () {
                              if(userName == '') {
                                _login();
                              } else {
                                _navToDeliveryList(6, '面试邀请');
                              }
                            },
                            child: new Container(
                              height: 100.0*factor,
                              margin: EdgeInsets.only(top: 5.0*factor),
                              decoration: new BoxDecoration(
                                color: Colors.white,
                              ),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Padding(
                                    padding: EdgeInsets.only(
                                      top: 20.0*factor,
                                      bottom: 20.0*factor,
                                      left: 24.0*factor,
                                      right: 20.0*factor,
                                    ),
                                    child: new Row(
                                      children: <Widget>[
                                        new Icon(Icons.insert_invitation, size: 44.0*factor, color: Theme.of(context).primaryColor),
                                        new Padding(
                                          padding: EdgeInsets.only(right: 14.0*factor),
                                        ),
                                        new Text('面试邀请', style: TextStyle(fontSize: 34.0*factor),),
                                      ],
                                    ),
                                  ),
                                  new Padding(
                                    padding: EdgeInsets.only(
                                      right: 20.0*factor,
                                    ),
                                    child: new Icon(Icons.chevron_right, size: 42.0*factor, color: Theme.of(context).primaryColor),
                                  )
                                ],
                              ),
                            )
                          ),

                          new InkWell(
                            onTap: () {
                              if(userName == '') {
                                _login();
                              } else {
                                _navToViewerList();
                              }
                            },
                            child: new Container(
                              height: 100.0*factor,
                              margin: EdgeInsets.only(top: 5.0*factor),
                              decoration: new BoxDecoration(
                                color: Colors.white,
                              ),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Padding(
                                    padding: EdgeInsets.only(
                                      top: 20.0*factor,
                                      bottom: 20.0*factor,
                                      left: 25.0*factor,
                                      right: 20.0*factor,
                                    ),
                                    child: new Row(
                                      children: <Widget>[
                                        new Icon(Icons.remove_red_eye, size: 42.0*factor, color: Theme.of(context).primaryColor),
                                        new Padding(
                                          padding: EdgeInsets.only(right: 15.0*factor),
                                        ),
                                        new Text('谁看过我', style: TextStyle(fontSize: 34.0*factor),),
                                      ],
                                    ),
                                  ),
                                  new Padding(
                                    padding: EdgeInsets.only(
                                      right: 20.0*factor,
                                    ),
                                    child: new Icon(Icons.chevron_right, size: 42.0*factor, color: Theme.of(context).primaryColor),
                                  )
                                ],
                              ),
                            )
                          ),

                          new InkWell(
                            onTap: () {
                              if(userName == '') {
                                _login();
                              } else {
                                _navToShieldList();
                              }
                            },
                            child: new Container(
                              height: 100.0*factor,
                              margin: EdgeInsets.only(top: 5.0*factor),
                              decoration: new BoxDecoration(
                                color: Colors.white,
                              ),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Padding(
                                    padding: EdgeInsets.only(
                                      top: 20.0*factor,
                                      bottom: 20.0*factor,
                                      left: 25.0*factor,
                                      right: 20.0*factor,
                                    ),
                                    child: new Row(
                                      children: <Widget>[
                                        new Icon(Icons.do_not_disturb_alt, size: 42.0*factor, color: Theme.of(context).primaryColor),
                                        new Padding(
                                          padding: EdgeInsets.only(right: 15.0*factor),
                                        ),
                                        new Text('不让该公司看我的简历', style: TextStyle(fontSize: 34.0*factor),),
                                      ],
                                    ),
                                  ),
                                  new Padding(
                                    padding: EdgeInsets.only(
                                      right: 20.0*factor,
                                    ),
                                    child: new Icon(Icons.chevron_right, size: 42.0*factor, color: Theme.of(context).primaryColor),
                                  )
                                ],
                              ),
                            )
                          ),
                          
                          new InkWell(
                            onTap: () {
                              if(userName == '') {
                                _login();
                              } else {
                                _navToSettingView();
                              }
                            },
                            child: new Container(
                              height: 100.0*factor,
                              margin: EdgeInsets.only(top: 5.0*factor),
                              decoration: new BoxDecoration(
                                color: Colors.white,
                              ),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Padding(
                                    padding: EdgeInsets.only(
                                      top: 20.0*factor,
                                      bottom: 20.0*factor,
                                      left: 25.0*factor,
                                      right: 20.0*factor,
                                    ),
                                    child: new Row(
                                      children: <Widget>[
                                        Image.asset('assets/images/setting.png', width: 42.0*factor),
                                        new Padding(
                                          padding: EdgeInsets.only(right: 15.0*factor),
                                        ),
                                        new Text('设置', style: TextStyle(fontSize: 34.0*factor),),
                                      ],
                                    ),
                                  ),
                                  new Padding(
                                    padding: EdgeInsets.only(
                                      right: 20.0*factor,
                                    ),
                                    child: new Icon(Icons.chevron_right, size: 42.0*factor, color: Theme.of(context).primaryColor),
                                  )
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
                bottom: 0.0*factor,
                width: MediaQuery.of(context).size.width,
                child: FlatButton(
                  child: new Container(
                    height: 90*factor,
                    child: new Center(
                      child: Text(
                        "退出登录",
                        style: TextStyle(
                          color: Colors.orange[400],
                          fontSize: 36.0*factor,
                          letterSpacing: 5*factor
                        ),
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
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString('userName', '');
                    setState(() {
                      isRequesting = false;
                      userName = '';
                    });
                    StoreProvider.of<AppState>(context).dispatch(SetResumeAction(null));
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
      },
    );
  }

  initInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName');
    });
    Response response = await Api().getUserBaseInfo(prefs.getString('userName'));
    personalInfo = PersonalInfo.fromMap(response.data['info']);
  }

  _login() {
    Navigator
      .of(context)
      .push(new MaterialPageRoute(builder: (context) {
        return new NewLoginPage();
      }));
  }

  _setUserInfo() {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new UserEditView(personalInfo);
        },
        transitionsBuilder: _pageAnimation
    )).then((onValue) => {
      initInfo()
    });
  }

  Widget _pageAnimation(_, Animation<double> animation, __, Widget child) {
    return new FadeTransition(
      opacity: animation,
      child: new SlideTransition(position: new Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(animation), child: child),
    );
  }

  _navToSettingView() {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new SettingView();
        },
        transitionsBuilder: _pageAnimation
    ));
  }

  _navToViewerList() {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new CompanyTab();
        },
        transitionsBuilder: _pageAnimation
    ));
  }

  _navToResumeDetail() {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new ResumeDetail();
        },
        transitionsBuilder: _pageAnimation
    ));
  }

  _navToShieldList() {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new ShieldList();
        },
        transitionsBuilder: _pageAnimation
    ));
  }

  _navToDeliveryList(int type, String title) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new JobsTab(type, title);
        },
        transitionsBuilder: _pageAnimation
    ));
  }

  _navToFavoriteList() {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new JobsTab(5, '职位收藏');
        },
        transitionsBuilder: _pageAnimation
    ));
  }
}