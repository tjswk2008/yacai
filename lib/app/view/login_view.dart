import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart' as prefix1;
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart' as prefix0;
import './login_view_pwd.dart';
import './login_view_msg.dart';

// 新的登录界面
class NewLoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new NewLoginPageState();
}

class NewLoginPageState extends State<NewLoginPage> with TickerProviderStateMixin {
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

  TabController _controller;
  VoidCallback onChanged;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(onChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return new Material(
      // color: new Color.fromARGB(255, 0, 215, 198),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 60.0*factor,
            top: 66.0*factor,
            height: 37*factor,
            width: 630*factor,
            child: Padding(
              padding: EdgeInsets.only(left: 243*factor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text('短信登录', style: TextStyle(fontSize: 36*factor, color: Color.fromRGBO(34, 24, 20, 1), textBaseline: TextBaseline.ideographic),),
                  Text('密码登录', style: TextStyle(fontSize: 28*factor, color: Color.fromRGBO(90, 169, 226, 1)),),
                ],
              ),
            ),
          )
        ]
      )
    );
  }
}