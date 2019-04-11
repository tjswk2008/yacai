import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/app/model/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// 我要提问界面
class Invite extends StatefulWidget {

  final int jobId;
  final int userId;
  Invite(this.jobId, this.userId);

  @override
  State<StatefulWidget> createState() => new InviteState();
}

class InviteState extends State<Invite> {
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
  bool isRequesting = false;

  final titleCtrl = new TextEditingController(text: '');
  final detailCtrl = new TextEditingController(text: '');
  String userName = '';
  int type = 1;

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
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("发送邀请函", style: new TextStyle(color: Colors.white, fontSize: 30.0*factor)),
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
      body: isRequesting ? new Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Color.fromARGB(190, 0, 0, 0)
              ),
            ),
          ),
          Positioned.fill(
            child: SpinKitHourGlass(
              color: Theme.of(context).primaryColor,
              size: 50*factor,
              duration: Duration(milliseconds: 1800),
            ),
          )
        ]
      ) : Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(30.0*factor),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(height: 20.0*factor),
                Padding(
                  padding: EdgeInsets.only(bottom: 20*factor),
                  child: new Text("邀请函：", style: new TextStyle(fontSize: 24.0*factor)),
                ),
                new Expanded(child: new TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 20,
                  controller: detailCtrl,
                  style: new TextStyle(fontSize: 24.0*factor),
                  decoration: new InputDecoration(
                    hintText: "请填写邀请函内容",
                    hintStyle: new TextStyle(
                        color: const Color(0xFF808080),
                        fontSize: 22.0*factor
                    ),
                    border: new OutlineInputBorder(
                      borderSide: BorderSide(width: 1.0*factor),
                      borderRadius: BorderRadius.all(Radius.circular(6*factor))
                    ),
                    contentPadding: EdgeInsets.all(20.0*factor)
                  ),
                ))
              ],
            ),
          ),
          Positioned(
            bottom: 30.0*factor,
            left: 30.0*factor,
            width: MediaQuery.of(context).size.width - 60*factor,
            child: FlatButton(
              child: new Container(
                height: 70*factor,
                child: new Center(
                  child: Text(
                    "保存",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.0*factor,
                      letterSpacing: 40*factor
                    ),
                  ),
                ),
              ),
              color: Theme.of(context).primaryColor,
              onPressed: () async {
                if (isRequesting) return;
                // 拿到用户输入的账号密码
                String detail = detailCtrl.text.trim();
                if (detail.isEmpty) {
                  Scaffold.of(context).showSnackBar(new SnackBar(
                    content: new Text("邀请函不能为空！"),
                  ));
                  return;
                }
                setState(() {
                  isRequesting = true;
                });
                // 发送给webview，让webview登录后再取回token

                Api().invite(userName, detail, widget.jobId, widget.userId)
                  .then((Response response) {
                    setState(() {
                      isRequesting = false;
                    });
                    if(response.data['code'] != 1) {
                      Scaffold.of(context).showSnackBar(new SnackBar(
                        content: new Text("提交失败！"),
                      ));
                      return;
                    } else {
                      showDialog<Null>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                            return new AlertDialog(
                                content: Text("发送成功！", style: TextStyle(fontSize: 28*factor),),
                                actions: <Widget>[
                                    new FlatButton(
                                        child: new Text('知道了', style: TextStyle(fontSize: 24*factor),),
                                        onPressed: () {
                                            Navigator.of(context).pop();
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
              }
            ),
          )
        ],
      )
      
    );
  }
}