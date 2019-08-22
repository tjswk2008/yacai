import 'package:flutter/material.dart';
import 'package:flutter_app/app/view/login_view.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/app/model/app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:flutter_app/splash.dart';
import 'package:flutter_app/actions/actions.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:open_file/open_file.dart';
// import 'package:fluwx/fluwx.dart' as fluwx;

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
  String version;
  String newestVersion;
  String versionStr = '';

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      version = packageInfo.version;
      return Api().checkAppVersion();
    })
    .then((Response response) {
      if (response.data['code'] == 1) {
        newestVersion = response.data['version'];
        if(newestVersion == version) {
          setState(() {
           versionStr = '已是最新版'; 
          });
        } else {
          versionStr = '可升级到$newestVersion';
        }
      }
      return SharedPreferences.getInstance();
    })
    .then((SharedPreferences prefs) {
      setState(() {
        userName = prefs.getString('userName');
      });
      return ;
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
              height: 320*factor + 3*16,
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
                            content: Text("  确认要注销您的账号吗？注销后别人无法再预览或搜索查阅到您的信息，您也无法登陆我们的app", style: TextStyle(fontSize: 28*factor, height: 1.6),),
                            actions: <Widget>[
                              new FlatButton(
                                child: new Text('确定', style: TextStyle(fontSize: 28*factor, color: Colors.orange),),
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
                                child: new Text('取消', style: TextStyle(fontSize: 28*factor),),
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
                                    size: 34.0*factor,
                                    color: Colors.red
                                  ),
                                ),
                                new Text('注销账号', style: TextStyle(fontSize: 28.0*factor),),
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
                                new Icon(Icons.lock_open, size: 34.0*factor, color: Theme.of(context).primaryColor,),
                                new Padding(
                                  padding: EdgeInsets.only(right: 15.0*factor),
                                ),
                                new Text('简历公开', style: TextStyle(fontSize: 28.0*factor),),
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
                        // fluwx.share(fluwx.WeChatShareTextModel(
                        //   text: "Y财，您的专业财务类求职app，请前往百度手机助手或苹果商店下载~",
                        //   transaction: "transaction}",//仅在android上有效，下同。
                        //   scene: fluwx.WeChatScene.SESSION
                        // ));
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
                                new Icon(Icons.share, size: 34.0*factor, color: Colors.orange[400],),
                                new Padding(
                                  padding: EdgeInsets.only(right: 15.0*factor),
                                ),
                                new Text('丫财应用分享', style: TextStyle(fontSize: 28.0*factor),),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ),
                  Divider(),
                  new InkWell(
                    onTap: () async {
                      if(newestVersion != version) {
                        // await _checkPermission();
                        executeDownload();
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
                                new Icon(Icons.system_update, size: 34.0*factor),
                                new Padding(
                                  padding: EdgeInsets.only(right: 15.0*factor),
                                ),
                                new Text('版本更新检查', style: TextStyle(fontSize: 28.0*factor),),
                              ],
                            ),
                          ),
                          new Padding(
                            padding: EdgeInsets.only(
                              right: 45.0*factor,
                            ),
                            child: Text(versionStr, style: TextStyle(fontSize: 28*factor, color: Colors.grey[600]),),
                          )
                        ],
                      ),
                    )
                  )
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

  // 获取安装地址
  Future<String> get _apkLocalPath async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }


  // 下载
  Future<void> executeDownload() async {
    final path = await _apkLocalPath;
    double factor = MediaQuery.of(context).size.width/750;
    // String downLoadUrl = Platform.isAndroid ? 'http://192.168.140.56:3000' : 'http://192.168.2.101:3000';
    // String downLoadUrl = 'http://192.168.43.204:3000';
    String downLoadUrl = 'http://47.101.177.244:3000';
    
    //下载
    final taskId = await FlutterDownloader.enqueue(
        url: downLoadUrl + '/app-release.apk',
        savedDir: path,
        showNotification: true,
        openFileFromNotification: true);
    FlutterDownloader.registerCallback((id, status, progress) {
      // 当下载完成时，调用安装
      if (taskId == id && status == DownloadTaskStatus.complete) {
        // _installApk();
        OpenFile.open(path + '/app-release.apk');
        // FlutterDownloader.open(taskId: id);
      } else if (status == DownloadTaskStatus.failed) {
        //下载出错
        Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text(status.toString(), style: TextStyle(fontSize: 22*factor),),
        ));
        // print(status.toString());
      }
    });
  }
}