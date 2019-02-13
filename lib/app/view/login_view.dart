import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/component/common_button.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_app/actions/actions.dart';
import 'package:flutter_app/app/model/app.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 新的登录界面
class NewLoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new NewLoginPageState();
}

class NewLoginPageState extends State<NewLoginPage> {
  // 首次加载登录页
  static const int stateFirstLoad = 1;
  // 加载完毕登录页，且当前页面是输入账号密码的页面
  static const int stateLoadedInputPage = 2;
  // 加载完毕登录页，且当前页面不是输入账号密码的页面
  static const int stateLoadedNotInputPage = 3;

  int curState = stateFirstLoad;

  // 标记是否是加载中
  bool loading = true;
  // 标记当前页面是否是我们自定义的回调页面
  bool isLoadingCallbackPage = false;
  // 是否正在登录
  bool isOnLogin = false;

  final usernameCtrl = new TextEditingController(text: '');
  final passwordCtrl = new TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var loadingView;
    if (isOnLogin) {
      loadingView = new Center(
        child: new Padding(
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CupertinoActivityIndicator(),
              Text("登录中，请稍等...")
            ],
          ),
        )
      );
    } else {
      loadingView = new Center();
    }
    return StoreConnector<AppState, Function(String userName)>(
      converter: (Store<AppState> store) {
        return (String userName) => store.dispatch(AddUserNameAction(userName));
      },
      builder: (context, callback) {
        return new Scaffold(
          appBar: new AppBar(
            title: new Text("登录", style: new TextStyle(color: Colors.white)),
            iconTheme: new IconThemeData(color: Colors.white),
          ),
          body: new Container(
            padding: const EdgeInsets.all(10.0),
            child: new Column(
              children: <Widget>[
                new Center(child: new Text("请使用帐号密码登录")),
                new Container(height: 20.0),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text("用户名："),
                    new Expanded(child: new TextField(
                      controller: usernameCtrl,
                      decoration: new InputDecoration(
                        hintText: "帐号/注册邮箱",
                        hintStyle: new TextStyle(
                            color: const Color(0xFF808080)
                        ),
                        border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(const Radius.circular(6.0))
                        ),
                        contentPadding: const EdgeInsets.all(10.0)
                      ),
                    ))
                  ],
                ),
                new Container(height: 20.0),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text("密　码："),
                    new Expanded(child: new TextField(
                      controller: passwordCtrl,
                      obscureText: true,
                      decoration: new InputDecoration(
                        hintText: "登录密码",
                        hintStyle: new TextStyle(
                            color: const Color(0xFF808080)
                        ),
                        border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(const Radius.circular(6.0))
                        ),
                        contentPadding: const EdgeInsets.all(10.0)
                      ),
                    ))
                  ],
                ),
                new Container(height: 20.0),
                new Builder(builder: (ctx) {
                  return new CommonButton(
                    text: "登录",
                    color: new Color.fromARGB(255, 0, 215, 198),
                    onTap: () {
                      if (isOnLogin) return;
                      // 拿到用户输入的账号密码
                      String username = usernameCtrl.text.trim();
                      String password = passwordCtrl.text.trim();
                      if (username.isEmpty || password.isEmpty) {
                        Scaffold.of(ctx).showSnackBar(new SnackBar(
                          content: new Text("账号和密码不能为空！"),
                        ));
                        return;
                      }
                      setState(() {
                        isOnLogin = true;
                      });
                      // 发送给webview，让webview登录后再取回token
                      Api().login(username, password)
                        .then((Response response) {
                          setState(() {
                            isOnLogin = false;
                          });
                          if(response.data['code'] != 1) {
                            Scaffold.of(ctx).showSnackBar(new SnackBar(
                              content: new Text("账号或密码不正确！"),
                            ));
                            return;
                          }
                          callback(username);
                          SharedPreferences.getInstance().then((SharedPreferences prefs) {
                            prefs.setString('userName', username);
                            Navigator.pop(context, response.data['id']);
                          });
                        })
                        .catchError((e) {
                          setState(() {
                            isOnLogin = false;
                          });
                          print(e);
                        });
                    }
                  );
                }),
                new Expanded(
                  child: new Column(
                    children: <Widget>[
                      new Expanded(
                        child: loadingView
                      )
                    ],
                  )
                )
              ],
            ),
          )
        );
      }
    );
  }
}