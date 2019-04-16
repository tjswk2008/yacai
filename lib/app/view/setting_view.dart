import 'package:flutter/material.dart';
import 'package:flutter_app/app/view/login_view.dart';
import 'package:flutter_app/app/view/shield_list.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/app/model/app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/app/view/jobs_view.dart';
import 'package:flutter_app/app/view/company/company_list.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:flutter_app/splash.dart';
import 'package:flutter_app/actions/actions.dart';

class SettingView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new SettingViewState();
}

class SettingViewState extends State<SettingView> {

  String userAvatar = '';
  String jobStatus = '';
  String userName = '';
  bool isRequesting = false;
  int isOpen = 1;

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
          appBar: new AppBar(
            elevation: 0.0,
            leading: IconButton(
              icon: const BackButtonIcon(),
              iconSize: 40*factor,
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: () {
                Navigator.maybePop(context);
              }
            ),
            title: new Text('设置',
                style: new TextStyle(fontSize: 30.0*factor, color: Colors.white)),
          ),
          backgroundColor: new Color.fromARGB(255, 242, 242, 245),
          body: Container(
            padding: EdgeInsets.all(40.0*factor),
            child: Container(
              height: 520*factor + 6*16,
              padding: EdgeInsets.only(left: 30*factor),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20*factor),)
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 20*factor),
                  ),
                  
                  new InkWell(
                    onTap: () {
                      showDialog<Null>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return new AlertDialog(
                            title: Center(child: Text("注销确认", style: TextStyle(fontSize: 28*factor),),),
                            content: Text("  确认要注销您的账号吗？注销后别人无法再预览或搜索查阅到您的信息，您也无法登陆我们的app", style: TextStyle(fontSize: 24*factor),),
                            actions: <Widget>[
                              new FlatButton(
                                child: new Text('确定', style: TextStyle(fontSize: 24*factor, color: Colors.orange),),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    isRequesting = true;
                                  });
                                  // 发送给webview，让webview登录后再取回token

                                  Api().deleteUser(userName)
                                    .then((Response response) {
                                      setState(() {
                                        isRequesting = false;
                                      });
                                      if(response.data['code'] != 1) {
                                        Scaffold.of(context).showSnackBar(new SnackBar(
                                          content: new Text("注销失败，请重试！"),
                                        ));
                                        return;
                                      } else {
                                        showDialog<Null>(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return new AlertDialog(
                                              content: Text("已注销！", style: TextStyle(fontSize: 28*factor),),
                                              actions: <Widget>[
                                                new FlatButton(
                                                  child: new Text('知道了', style: TextStyle(fontSize: 24*factor),),
                                                  onPressed: () async {
                                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                                    prefs.setString('userName', '');
                                                    setState(() {
                                                      isRequesting = false;
                                                      userName = '';
                                                    });
                                                    StoreProvider.of<AppState>(context).dispatch(SetResumeAction(null));
                                                    Navigator
                                                      .of(context)
                                                      .pushAndRemoveUntil(
                                                        new MaterialPageRoute(
                                                          builder: (BuildContext context) => new SplashPage()
                                                        ),
                                                        (Route route) => route == null);
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        ).then((val) {
                                            print(val);
                                        });
                                      }
                                    })
                                    .catchError((e) {
                                      setState(() {
                                        isRequesting = false;
                                      });
                                      print(e);
                                    });
                                },
                              ),
                              new FlatButton(
                                child: new Text('取消', style: TextStyle(fontSize: 24*factor),),
                                onPressed: () {
                                    Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: new Container(
                      height: 70.0*factor,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Padding(
                            padding: EdgeInsets.only(
                              top: 10.0*factor,
                              bottom: 10.0*factor,
                              right: 20.0*factor,
                            ),
                            child: new Row(
                              children: <Widget>[
                                new Padding(
                                  padding: EdgeInsets.only(right: 15.0*factor),
                                  child: Icon(
                                    Icons.delete_forever,
                                    size: 30.0*factor,
                                    color: Colors.red
                                  ),
                                ),
                                new Text('注销账号', style: TextStyle(fontSize: 24.0*factor),),
                              ],
                            ),
                          ),
                          
                        ],
                      ),
                    )
                  ),
                  Divider(),
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
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Padding(
                            padding: EdgeInsets.only(
                              top: 10.0*factor,
                              bottom: 10.0*factor,
                              right: 20.0*factor,
                            ),
                            child: new Row(
                              children: <Widget>[
                                new Icon(Icons.lock_open, size: 30.0*factor, color: Theme.of(context).primaryColor,),
                                new Padding(
                                  padding: EdgeInsets.only(right: 15.0*factor),
                                ),
                                new Text('简历公开', style: TextStyle(fontSize: 24.0*factor),),
                              ],
                            ),
                          ),
                          new Container(
                            height: 30*factor,
                            padding: EdgeInsets.only(
                              right: 20.0*factor,
                            ),
                            child: Switch.adaptive(
                              value: isOpen == 1 ? true : false,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              activeColor: Theme.of(context).primaryColor,     // 激活时原点颜色
                              onChanged: (bool val) async {
                                
                                if (isRequesting) return;
                                setState(() {
                                  isRequesting = true;
                                });
                                try {
                                  Response response = await Api().switchOpenStatus(userName, isOpen == 1 ? 0 : 1);

                                  setState(() {
                                    isRequesting = false;
                                  });
                                  if(response.data['code'] != 1) {
                                    Scaffold.of(context).showSnackBar(new SnackBar(
                                      content: new Text("请求失败！"),
                                    ));
                                    return;
                                  }
                                  setState(() {
                                    isOpen = isOpen == 1 ? 0 : 1;
                                  });
                                } catch(e) {
                                  setState(() {
                                    isRequesting = false;
                                  });
                                  print(e);
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  ),
                  Divider(),
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
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Padding(
                            padding: EdgeInsets.only(
                              top: 10.0*factor,
                              bottom: 10.0*factor,
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
                        ],
                      ),
                    )
                  ),
                  Divider(),
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
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Padding(
                            padding: EdgeInsets.only(
                              top: 10.0*factor,
                              bottom: 10.0*factor,
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
                        ],
                      ),
                    )
                  ),
                  Divider(),
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
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Padding(
                            padding: EdgeInsets.only(
                              top: 10.0*factor,
                              bottom: 10.0*factor,
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
                        ],
                      ),
                    )
                  ),
                  Divider(),
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
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Padding(
                            padding: EdgeInsets.only(
                              top: 10.0*factor,
                              bottom: 10.0*factor,
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
                        ],
                      ),
                    )
                  ),
                  Divider(),
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
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Padding(
                            padding: EdgeInsets.only(
                              top: 10.0*factor,
                              bottom: 10.0*factor,
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
                        ],
                      ),
                    )
                  ),
                ]
              ),
            )
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