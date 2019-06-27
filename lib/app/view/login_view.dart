import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
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
  Widget _tabContent;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabContent = new LoginWithPwd();
    _controller = new TabController(length: 2, vsync: this);
    onChanged = () {
      setState(() {
        if (_currentIndex == 0) {
          _tabContent = new LoginWithPwd();
        } else {
          _tabContent = new LoginWithMsg();
        }
        _currentIndex = this._controller.index;
      });
    };

    _controller.addListener(onChanged);
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
      body: Padding(
        padding: EdgeInsets.all(20*factor),
        child: Column(
          children: <Widget>[
            new TabBar(
              indicatorWeight: 3.0*factor,
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: new TextStyle(fontSize: 26.0*factor),
              labelColor: Colors.black,
              controller: _controller,
              tabs: [
                new Tab(child: Container(height: 50*factor, child: Text('密码登陆'),)),
                new Tab(child: Container(height: 50*factor, child: Text('短信登陆'),)),
              ],
              indicatorColor: Theme
                  .of(context)
                  .primaryColor,
            ),
            Container(
              height: MediaQuery.of(context).size.height - 185*factor - 60,
              child: _tabContent,
            ),
          ],
        ),
      ),
    );
  }
}