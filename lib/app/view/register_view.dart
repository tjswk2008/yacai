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
import 'package:flutter_app/app/view/login_view.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:flutter_app/app/model/company.dart';
import 'package:flutter_app/app/model/job.dart';

// 新的登录界面
class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
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
      loadingView = new Center(
        child: new Padding(
          padding: EdgeInsets.fromLTRB(0, 30*factor, 0, 0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CupertinoActivityIndicator(),
              Text("注册中，请稍等...", style: TextStyle(fontSize: 20.0*factor),)
            ],
          ),
        )
      );
    } else {
      loadingView = new Center();
    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("注册", style: new TextStyle(color: Colors.white, fontSize: 30.0*factor)),
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
      body: new Container(
        padding: EdgeInsets.all(10.0*factor),
        child: new Column(
          children: <Widget>[
            new Center(child: new Text("请使用帐号密码注册", style: new TextStyle(color: Colors.white, fontSize: 22.0*factor))),
            new Container(height: 30.0*factor),
            new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Text("用户名：", style: TextStyle(fontSize: 26.0*factor)),
                new Expanded(child: new TextField(
                  controller: usernameCtrl,
                  style: TextStyle(fontSize: 26.0*factor),
                  decoration: new InputDecoration(
                    hintText: "请输入帐号",
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
                    hintText: "请输入密码",
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
                text: "注册",
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
                  try {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    int role = prefs.getInt('role');
                    Response response = await Api().register(username, password, role);
                    setState(() {
                      isOnLogin = false;
                    });
                    if(response.data['code'] != 1) {
                      Scaffold.of(ctx).showSnackBar(new SnackBar(
                        content: new Text("该账号已被注册！", style: TextStyle(fontSize: 20.0*factor),),
                      ));
                      return;
                    }
                    prefs.setString('userName', username);

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
                  } catch (e) {
                    setState(() {
                      isOnLogin = false;
                    });
                    print(e);
                  }
                }
              );
            }),
            new Padding(
              padding: EdgeInsets.only(top: 36.0*factor),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('已有账号，前往', style: TextStyle(fontSize: 24.0*factor)),
                  new InkWell(
                    onTap: () {
                      Navigator.of(context).push(new PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (BuildContext context, _, __) {
                            return new NewLoginPage();
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
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: factor, color: Colors.black))
                      ),
                      child: new Text('登陆', style: TextStyle(fontSize: 24.0*factor)),
                    )
                  ),
                ],
              )
            ),
            
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
}