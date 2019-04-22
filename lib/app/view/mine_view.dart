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
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, appState) {
        return new Scaffold(
          appBar: PreferredSize(
            child: AppBar(elevation: 0.0,),
            preferredSize: Size.fromHeight(0)
          ),
          backgroundColor: new Color.fromARGB(255, 242, 242, 245),
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
                      Container(
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
                                    top: 20.0*factor,
                                    left: 30.0*factor,
                                    right: 20.0*factor,
                                  ),
                                  child: appState.resume == null || appState.resume.personalInfo.avatar == null || appState.resume.personalInfo.avatar == ''
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        new Padding(
                                            padding: EdgeInsets.only(
                                              top: 10.0*factor,
                                              bottom: 10.0*factor,
                                            ),
                                            child: new Text(
                                                userName == '' ? "点击头像登录" : userName,
                                                style: new TextStyle(
                                                    color: Colors.white, fontSize: 26.0*factor))
                                        ),
                                        new Text(
                                            (appState.resume == null || appState.resume.jobStatus == null || appState.resume.jobStatus == '') ? "" : appState.resume.jobStatus,
                                            style: new TextStyle(
                                                color: Colors.white, fontSize: 24.0*factor)
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        )
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
                              height: 70.0*factor,
                              margin: EdgeInsets.only(top: 15.0*factor),
                              decoration: new BoxDecoration(
                                color: Colors.white,
                              ),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Padding(
                                    padding: EdgeInsets.only(
                                      top: 10.0*factor,
                                      bottom: 10.0*factor,
                                      left: 25.0*factor,
                                      right: 20.0*factor,
                                    ),
                                    child: new Row(
                                      children: <Widget>[
                                        new Icon(Icons.insert_drive_file, size: 30.0*factor, color: Theme.of(context).primaryColor),
                                        new Padding(
                                          padding: EdgeInsets.only(right: 15.0*factor),
                                        ),
                                        new Text('我的简历', style: TextStyle(fontSize: 24.0*factor),),
                                      ],
                                    ),
                                  ),
                                  new Padding(
                                    padding: EdgeInsets.only(
                                      right: 20.0*factor,
                                    ),
                                    child: new Icon(Icons.chevron_right, size: 30.0*factor,),
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
                              height: 70.0*factor,
                              margin: EdgeInsets.only(top: 15.0*factor),
                              decoration: new BoxDecoration(
                                color: Colors.white,
                              ),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Padding(
                                    padding: EdgeInsets.only(
                                      top: 10.0*factor,
                                      bottom: 10.0*factor,
                                      left: 25.0*factor,
                                      right: 20.0*factor,
                                    ),
                                    child: new Row(
                                      children: <Widget>[
                                        new Icon(Icons.favorite_border, size: 30.0*factor, color: Colors.red[400],),
                                        new Padding(
                                          padding: EdgeInsets.only(right: 15.0*factor),
                                        ),
                                        new Text('职位收藏', style: TextStyle(fontSize: 24.0*factor),),
                                      ],
                                    ),
                                  ),
                                  new Padding(
                                    padding: EdgeInsets.only(
                                      right: 20.0*factor,
                                    ),
                                    child: new Icon(Icons.chevron_right, size: 30.0*factor,),
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
                              height: 70.0*factor,
                              margin: EdgeInsets.only(top: 15.0*factor),
                              decoration: new BoxDecoration(
                                color: Colors.white,
                              ),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Padding(
                                    padding: EdgeInsets.only(
                                      top: 10.0*factor,
                                      bottom: 10.0*factor,
                                      left: 25.0*factor,
                                      right: 20.0*factor,
                                    ),
                                    child: new Row(
                                      children: <Widget>[
                                        new Icon(Icons.email, size: 30.0*factor, color: Colors.orange[400],),
                                        new Padding(
                                          padding: EdgeInsets.only(right: 15.0*factor),
                                        ),
                                        new Text('申请记录', style: TextStyle(fontSize: 24.0*factor),),
                                      ],
                                    ),
                                  ),
                                  new Padding(
                                    padding: EdgeInsets.only(
                                      right: 20.0*factor,
                                    ),
                                    child: new Icon(Icons.chevron_right, size: 30.0*factor,),
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
                              height: 70.0*factor,
                              margin: EdgeInsets.only(top: 15.0*factor),
                              decoration: new BoxDecoration(
                                color: Colors.white,
                              ),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Padding(
                                    padding: EdgeInsets.only(
                                      top: 10.0*factor,
                                      bottom: 10.0*factor,
                                      left: 25.0*factor,
                                      right: 20.0*factor,
                                    ),
                                    child: new Row(
                                      children: <Widget>[
                                        new Icon(Icons.insert_invitation, size: 30.0*factor),
                                        new Padding(
                                          padding: EdgeInsets.only(right: 15.0*factor),
                                        ),
                                        new Text('面试邀请', style: TextStyle(fontSize: 24.0*factor),),
                                      ],
                                    ),
                                  ),
                                  new Padding(
                                    padding: EdgeInsets.only(
                                      right: 20.0*factor,
                                    ),
                                    child: new Icon(Icons.chevron_right, size: 30.0*factor,),
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
                              height: 70.0*factor,
                              margin: EdgeInsets.only(top: 15.0*factor),
                              decoration: new BoxDecoration(
                                color: Colors.white,
                              ),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Padding(
                                    padding: EdgeInsets.only(
                                      top: 10.0*factor,
                                      bottom: 10.0*factor,
                                      left: 25.0*factor,
                                      right: 20.0*factor,
                                    ),
                                    child: new Row(
                                      children: <Widget>[
                                        new Icon(Icons.remove_red_eye, size: 30.0*factor, color: Theme.of(context).primaryColor,),
                                        new Padding(
                                          padding: EdgeInsets.only(right: 15.0*factor),
                                        ),
                                        new Text('谁看过我', style: TextStyle(fontSize: 24.0*factor),),
                                      ],
                                    ),
                                  ),
                                  new Padding(
                                    padding: EdgeInsets.only(
                                      right: 20.0*factor,
                                    ),
                                    child: new Icon(Icons.chevron_right, size: 30.0*factor,),
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
                              height: 70.0*factor,
                              margin: EdgeInsets.only(top: 15.0*factor),
                              decoration: new BoxDecoration(
                                color: Colors.white,
                              ),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Padding(
                                    padding: EdgeInsets.only(
                                      top: 10.0*factor,
                                      bottom: 10.0*factor,
                                      left: 25.0*factor,
                                      right: 20.0*factor,
                                    ),
                                    child: new Row(
                                      children: <Widget>[
                                        new Icon(Icons.do_not_disturb_alt, size: 30.0*factor, color: Colors.red,),
                                        new Padding(
                                          padding: EdgeInsets.only(right: 15.0*factor),
                                        ),
                                        new Text('不让该公司看我的简历', style: TextStyle(fontSize: 24.0*factor),),
                                      ],
                                    ),
                                  ),
                                  new Padding(
                                    padding: EdgeInsets.only(
                                      right: 20.0*factor,
                                    ),
                                    child: new Icon(Icons.chevron_right, size: 30.0*factor,),
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
                              height: 70.0*factor,
                              margin: EdgeInsets.only(top: 15.0*factor),
                              decoration: new BoxDecoration(
                                color: Colors.white,
                              ),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Padding(
                                    padding: EdgeInsets.only(
                                      top: 10.0*factor,
                                      bottom: 10.0*factor,
                                      left: 25.0*factor,
                                      right: 20.0*factor,
                                    ),
                                    child: new Row(
                                      children: <Widget>[
                                        new Icon(Icons.settings, size: 30.0*factor),
                                        new Padding(
                                          padding: EdgeInsets.only(right: 15.0*factor),
                                        ),
                                        new Text('设置', style: TextStyle(fontSize: 24.0*factor),),
                                      ],
                                    ),
                                  ),
                                  new Padding(
                                    padding: EdgeInsets.only(
                                      right: 20.0*factor,
                                    ),
                                    child: new Icon(Icons.chevron_right, size: 30.0*factor,),
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

  _login() {
    Navigator
      .of(context)
      .push(new MaterialPageRoute(builder: (context) {
        return new NewLoginPage();
      }));
  }

  _navToSettingView() {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new SettingView();
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return new FadeTransition(
            opacity: animation,
            child: new SlideTransition(position: new Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation), child: child),
          );
        }
    ));
  }

  _navToViewerList() {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new CompanyTab();
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return new FadeTransition(
            opacity: animation,
            child: new SlideTransition(position: new Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation), child: child),
          );
        }
    ));
  }

  _navToResumeDetail() {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new ResumeDetail();
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return new FadeTransition(
            opacity: animation,
            child: new SlideTransition(position: new Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation), child: child),
          );
        }
    ));
  }

  _navToShieldList() {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new ShieldList();
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return new FadeTransition(
            opacity: animation,
            child: new SlideTransition(position: new Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation), child: child),
          );
        }
    ));
  }

  _navToDeliveryList(int type, String title) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new JobsTab(type, title);
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return new FadeTransition(
            opacity: animation,
            child: new SlideTransition(position: new Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation), child: child),
          );
        }
    ));
  }

  _navToFavoriteList() {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new JobsTab(5, '职位收藏');
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return new FadeTransition(
            opacity: animation,
            child: new SlideTransition(position: new Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation), child: child),
          );
        }
    ));
  }
}