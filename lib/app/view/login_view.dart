import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:flutter_app/app/model/company.dart';
import 'package:flutter_app/app/model/job.dart';
import 'package:flutter_app/util/util.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/actions/actions.dart';
import 'package:flutter_app/app/model/app.dart';
import 'package:flutter_app/home.dart';
import 'package:flutter_app/recruit.dart';
import 'package:flutter_app/app/view/register_view.dart';
import 'package:flutter_app/util/dio.dart';
import 'package:steel_crypt/steel_crypt.dart';

// 新的登录界面
class NewLoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new NewLoginPageState();
}

class NewLoginPageState extends State<NewLoginPage>
    with TickerProviderStateMixin {
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
  bool isRequesting = false;
  String code;

  bool obscureText = true;
  bool isLoginWithPwd = true;

  final usernameCtrl = new TextEditingController(text: '');
  final passwordCtrl = new TextEditingController(text: '');
  final codeCtrl = new TextEditingController(text: '');

  VoidCallback onChanged;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width / 750;
    YaCaiUtil.getInstance().init(context);
    return new Material(
        // color: new Color.fromARGB(255, 0, 215, 198),
        child: Stack(children: <Widget>[
      Positioned(
        left: 60.0 * factor,
        top: 66.0 * factor,
        // height: 37*factor,
        width: 630 * factor,
        child: Padding(
          padding: EdgeInsets.only(left: 243 * factor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                isLoginWithPwd ? '密码登录' : '短信登录',
                style: TextStyle(
                    fontSize: 36 * factor,
                    color: Color.fromRGBO(34, 24, 20, 1),
                    textBaseline: TextBaseline.ideographic),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(new PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (BuildContext context, _, __) {
                        return new RegisterPage();
                      },
                      transitionsBuilder:
                          (_, Animation<double> animation, __, Widget child) {
                        return new FadeTransition(
                          opacity: animation,
                          child: new SlideTransition(
                              position: new Tween<Offset>(
                                begin: const Offset(0.0, 1.0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child),
                        );
                      }));
                },
                child: Text(
                  '注册 ',
                  style: TextStyle(
                      fontSize: 28 * factor,
                      color: Color.fromRGBO(90, 169, 226, 1)),
                ),
              )
            ],
          ),
        ),
      ),
      Positioned(
          left: 276 * factor,
          top: 236 * factor,
          width: 199 * factor,
          height: 199 * factor,
          child: new Container(
            height: 199 * factor,
            width: 199 * factor,
            decoration: new BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: new Color(0xFF593b51),
                    offset: Offset(4.0 * factor, 10.0 * factor),
                    blurRadius: 10.0 * factor)
              ],
            ),
            child: new Image.asset(
              'assets/images/logo.png',
              width: 199 * factor,
              height: 199 * factor,
            ),
          )),
      Positioned(
          left: 66 * factor,
          top: 557 * factor,
          width: 618 * factor,
          // height: 358*factor,
          child: new Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  TextField(
                    controller: usernameCtrl,
                    style: TextStyle(fontSize: 28.0 * factor),
                    decoration: new InputDecoration(
                        hintText: "手机号",
                        hintStyle: TextStyle(
                          color: const Color(0xFF5d5d5d),
                        ),
                        border: new OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 30.0 * factor)),
                  ),
                  isLoginWithPwd
                      ? Container()
                      : Positioned(
                          right: 0,
                          bottom: 20 * factor,
                          child: Container(
                            height: 70 * factor,
                            child: RaisedButton(
                              color: Colors.orange[400],
                              child: Text(
                                "发送验证码",
                                style: new TextStyle(
                                    fontSize: 26.0 * factor,
                                    color: Colors.white),
                              ),
                              onPressed: () async {
                                if (isRequesting) return;
                                // 拿到用户输入的账号密码
                                String username = usernameCtrl.text.trim();
                                if (username.isEmpty) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(new SnackBar(
                                    content: new Text(
                                      "手机号码不能为空！",
                                      style: TextStyle(fontSize: 20.0 * factor),
                                    ),
                                  ));
                                  return;
                                }
                                if (!RegExp(
                                        '^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$')
                                    .hasMatch(username)) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(new SnackBar(
                                    content: new Text(
                                      "手机号码不正确！",
                                      style: TextStyle(fontSize: 20.0 * factor),
                                    ),
                                  ));
                                  return;
                                }
                                setState(() {
                                  isRequesting = true;
                                });
                                // 发送给webview，让webview登录后再取回token
                                Response response =
                                    await Api().sendSms(username);
                                DioUtil.getInstance()
                                        .options
                                        .headers['x-token'] =
                                    response.data['token'];
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                    'token', response.data['token']);
                                try {
                                  setState(() {
                                    isRequesting = false;
                                  });
                                  if (response.data['code'] != 1) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(new SnackBar(
                                      content: new Text(
                                        "短信发送失败！",
                                        style:
                                            TextStyle(fontSize: 20.0 * factor),
                                      ),
                                    ));
                                    return;
                                  } else {
                                    code = response.data['sms'];
                                  }
                                } catch (e) {
                                  setState(() {
                                    isRequesting = false;
                                  });
                                }
                              },
                            ),
                          ))
                ],
              ),
              new Stack(
                children: <Widget>[
                  isLoginWithPwd
                      ? TextField(
                          controller: passwordCtrl,
                          style: TextStyle(fontSize: 28.0 * factor),
                          obscureText: obscureText,
                          decoration: new InputDecoration(
                              hintText: "请输入密码",
                              hintStyle: TextStyle(
                                color: const Color(0xFF5d5d5d),
                              ),
                              border: new OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 30.0 * factor)),
                        )
                      : TextField(
                          controller: codeCtrl,
                          style: TextStyle(fontSize: 28.0 * factor),
                          obscureText: obscureText,
                          decoration: new InputDecoration(
                              hintText: "请输入验证码",
                              hintStyle: TextStyle(
                                color: const Color(0xFF5d5d5d),
                              ),
                              border: new OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 30.0 * factor)),
                        ),
                  isLoginWithPwd
                      ? Positioned(
                          right: 0,
                          bottom: 30 * factor,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                            child: new Image.asset(
                              'assets/images/eye.png',
                              width: 60 * factor,
                              height: 29 * factor,
                            ),
                          ))
                      : Container()
                ],
              ),
              Container(
                height: 30 * factor,
              ),
              new InkWell(
                onTap: () async {
                  if (isOnLogin) return;
                  // 拿到用户输入的账号密码
                  String username = usernameCtrl.text.trim();
                  Response response;
                  if (isLoginWithPwd) {
                    String password = passwordCtrl.text.trim();
                    if (username.isEmpty || password.isEmpty) {
                      YaCaiUtil.getInstance().showMsg("账号和密码不能为空~");
                      return;
                    }
                    setState(() {
                      isOnLogin = true;
                    });
                    final aesEncrypter =
                        AesCrypt('46cc793c53dc451b', 'ecb', 'pkcs7');
                    // 发送给webview，让webview登录后再取回token
                    response = await Api()
                        .login(username, aesEncrypter.encrypt(password));
                    // 发送给webview，让webview登录后再取回token
                    // response = await Api().login(username, password);
                    DioUtil.getInstance().options.headers['x-token'] =
                        response.data['token'];
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString('token', response.data['token']);
                  } else {
                    String inputCode = codeCtrl.text.trim();
                    if (username.isEmpty || inputCode.isEmpty) {
                      YaCaiUtil.getInstance().showMsg("手机号和验证码不能为空~");
                      return;
                    }
                    if (inputCode != code) {
                      YaCaiUtil.getInstance().showMsg("验证码不正确~");
                      return;
                    }
                    response = await Api().login(username, null);
                  }

                  try {
                    setState(() {
                      isOnLogin = false;
                    });
                    if (response.data['code'] != 1) {
                      YaCaiUtil.getInstance().showMsg(response.data['msg']);
                      return;
                    }
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    DioUtil.getInstance().options.headers['x-token'] =
                        response.data['token'];
                    prefs.setString('token', response.data['token']);
                    prefs.setInt('role', response.data['info']['role']);
                    prefs.setString('userName', username);
                    int role = prefs.getInt('role');
                    prefs.setInt('userId', response.data['id']);
                    if (role == 1) {
                      Response resumeResponse =
                          await Api().getUserInfo(response.data['id'], null);
                      Resume resume =
                          Resume.fromMap(resumeResponse.data['info']);
                      StoreProvider.of<AppState>(context)
                          .dispatch(SetResumeAction(resume));
                    } else {
                      List<Response> resList = await Future.wait([
                        Api().getCompanyInfo(response.data['id']),
                        Api().getRecruitJobList(username)
                      ]);
                      StoreProvider.of<AppState>(context).dispatch(
                          SetJobsAction(Job.fromJson(resList[1].data['list'])));
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
                    }

                    Navigator.of(context).pushAndRemoveUntil(
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                role == 1 ? new BossApp() : new Recruit()),
                        (Route route) => route == null);
                  } catch (e) {
                    setState(() {
                      isOnLogin = false;
                    });
                    YaCaiUtil.getInstance().showMsg(e.message);
                  }
                },
                child: new Container(
                  height: 85.0 * factor,
                  decoration: new BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      boxShadow: [
                        BoxShadow(
                            color: new Color(0xFF788db4),
                            offset: Offset(10.0 * factor, 10.0 * factor),
                            blurRadius: 10.0 * factor)
                      ],
                      // border: new Border.all(color: Colors.orange[50], width: 2.0*factor),
                      borderRadius: new BorderRadius.all(
                          new Radius.circular(6.0 * factor))),
                  child: new Center(
                    child: new Text(
                      '登录',
                      style: new TextStyle(
                          color: Colors.white,
                          fontSize: 34.0 * factor,
                          letterSpacing: 10 * factor),
                    ),
                  ),
                ),
              ),
              Container(
                height: 40 * factor,
              ),
              Row(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      setState(() {
                        isLoginWithPwd = !isLoginWithPwd;
                      });
                    },
                    child: Text(
                      isLoginWithPwd ? '短信登录' : '密码登陆',
                      style: TextStyle(
                          fontSize: 28 * factor,
                          color: Color.fromRGBO(93, 93, 93, 1),
                          textBaseline: TextBaseline.ideographic),
                    ),
                  ),
                ],
              )
            ],
          ))
    ]));
  }
}
