import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/component/common_button.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/actions/actions.dart';
import 'package:flutter_app/app/model/app.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/home.dart';
import 'package:flutter_app/recruit.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:flutter_app/app/model/company.dart';
import 'package:flutter_app/app/model/job.dart';

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
    double factor = MediaQuery.of(context).size.width/750;
    var loadingView;
    if (isOnLogin) {
      loadingView = SpinKitHourGlass(
        color: Theme.of(context).primaryColor,
        size: 50*factor,
        duration: Duration(milliseconds: 1800),
      );
    } else {
      loadingView = new Center();
    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("登录", style: new TextStyle(color: Colors.white, fontSize: 30.0*factor)),
        leading: IconButton(
          icon: const BackButtonIcon(),
          iconSize: 40*factor,
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () {
            Navigator.maybePop(context);
          }
        ),
        iconTheme: new IconThemeData(color: Colors.white),
      ),
      body: new Stack(
        children: <Widget>[
          new Container(
            padding: EdgeInsets.all(10.0*factor),
            child: new Column(
              children: <Widget>[
                new Center(child: new Text("请使用帐号密码登录", style: new TextStyle(color: Colors.white, fontSize: 22.0*factor))),
                new Container(height: 30.0*factor),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text("用户名：", style: TextStyle(fontSize: 26.0*factor)),
                    new Expanded(child: new TextField(
                      controller: usernameCtrl,
                      style: TextStyle(fontSize: 26.0*factor),
                      decoration: new InputDecoration(
                        hintText: "帐号/注册邮箱",
                        hintStyle: new TextStyle(
                            color: const Color(0xFF808080),
                        ),
                        border: new OutlineInputBorder(
                          borderSide: BorderSide(width: 1.0*factor),
                          borderRadius: BorderRadius.all(Radius.circular(6.0*factor))
                        ),
                        contentPadding: EdgeInsets.all(20.0*factor)
                      ),
                    ))
                  ],
                ),
                new Container(height: 30.0*factor),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text("密　码：", style: TextStyle(fontSize: 26.0*factor),),
                    new Expanded(child: new TextField(
                      controller: passwordCtrl,
                      style: TextStyle(fontSize: 26.0*factor),
                      obscureText: true,
                      decoration: new InputDecoration(
                        hintText: "登录密码",
                        hintStyle: new TextStyle(
                            color: const Color(0xFF808080),
                        ),
                        border: new OutlineInputBorder(
                          borderSide: BorderSide(width: 1.0*factor),
                          borderRadius: BorderRadius.all(Radius.circular(6.0*factor))
                        ),
                        contentPadding: EdgeInsets.all(20.0*factor)
                      ),
                    ))
                  ],
                ),
                new Container(height: 30.0*factor),
                new Builder(builder: (ctx) {
                  return new CommonButton(
                    text: "登录",
                    color: new Color.fromARGB(255, 0, 215, 198),
                    onTap: () async {
                      if (isOnLogin) return;
                      // 拿到用户输入的账号密码
                      String username = usernameCtrl.text.trim();
                      String password = passwordCtrl.text.trim();
                      if (username.isEmpty || password.isEmpty) {
                        Scaffold.of(ctx).showSnackBar(new SnackBar(
                          content: new Text("账号和密码不能为空！", style: TextStyle(fontSize: 20.0*factor),),
                        ));
                        return;
                      }
                      setState(() {
                        isOnLogin = true;
                      });
                      // 发送给webview，让webview登录后再取回token
                      Response response = await Api().login(username, password);
                      try {
                        setState(() {
                          isOnLogin = false;
                        });
                        if(response.data['code'] != 1) {
                          Scaffold.of(ctx).showSnackBar(new SnackBar(
                            content: new Text("账号或密码不正确！", style: TextStyle(fontSize: 20.0*factor),),
                          ));
                          return;
                        }
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setString('userName', username);
                        int role = prefs.getInt('role');

                        if (role == 1) {
                          Response resumeResponse = await Api().getUserInfo(response.data['id']);
                          Resume resume = Resume.fromMap(resumeResponse.data['info']);
                          StoreProvider.of<AppState>(context).dispatch(SetResumeAction(resume));
                        } else {
                          List<Response> resList = await Future.wait([Api().getCompanyInfo(response.data['id']), Api().getRecruitJobList(username)]);
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
                        }

                        Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(
                          builder: (BuildContext context) => role == 1 ? new BossApp() : new Recruit()), (
                          Route route) => route == null);
                      } catch(e) {
                        setState(() {
                          isOnLogin = false;
                        });
                        Scaffold.of(ctx).showSnackBar(new SnackBar(
                          content: new Text(e.message, style: TextStyle(fontSize: 24.0*factor),),
                        ));
                      }
                    }
                  );
                }),
                
                
              ],
            ),
          ),
          isOnLogin ? Positioned(
            left: 0,
            top: 0,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Color.fromARGB(190, 0, 0, 0)
              ),
            ),
          ) : Container(),
          Positioned(
            left: 0,
            top: 0,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: loadingView,
          )
        ],
      )
    );
  }
}