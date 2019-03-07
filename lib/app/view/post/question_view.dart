import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/component/common_button.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_app/actions/actions.dart';
import 'package:flutter_app/app/model/app.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';

// 我要提问界面
class AskQuestion extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new AskQuestionState();
}

class AskQuestionState extends State<AskQuestion> {
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    var loadingView;
    if (isRequesting) {
      loadingView = new Center(
        child: new Padding(
          padding: EdgeInsets.fromLTRB(0, 30*factor, 0, 0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CupertinoActivityIndicator(),
              Text("提交中，请稍等...")
            ],
          ),
        )
      );
    } else {
      loadingView = new Center();
    }
    return StoreConnector<AppState, String>(
      converter: (Store<AppState> store) => store.state.userName,
      builder: (context, userName) {
        return new Scaffold(
          appBar: new AppBar(
            title: new Text("新的帖子", style: new TextStyle(color: Colors.white, fontSize: 30.0*factor)),
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
                new Container(height: 20.0*factor),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text("标题：", style: new TextStyle(fontSize: 22.0*factor)),
                    new Expanded(child: new TextField(
                      controller: titleCtrl,
                      keyboardType: TextInputType.multiline,
                      maxLines: 2,
                      style: new TextStyle(fontSize: 22.0*factor),
                      decoration: new InputDecoration(
                        hintText: "请输入标题",
                        hintStyle: new TextStyle(
                            color: const Color(0xFF808080),
                            fontSize: 22.0*factor
                        ),
                        border: new OutlineInputBorder(
                          borderSide: BorderSide(width: 1.0*factor),
                          borderRadius: const BorderRadius.all(const Radius.circular(0))
                        ),
                        contentPadding: const EdgeInsets.all(10.0)
                      ),
                    ))
                  ],
                ),
                new Container(height: 20.0*factor),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text("详情：", style: new TextStyle(fontSize: 22.0*factor)),
                    new Expanded(child: new TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      controller: detailCtrl,
                      style: new TextStyle(fontSize: 22.0*factor),
                      decoration: new InputDecoration(
                        hintText: "请详细描述您的问题",
                        hintStyle: new TextStyle(
                            color: const Color(0xFF808080),
                            fontSize: 22.0*factor
                        ),
                        border: new OutlineInputBorder(
                          borderSide: BorderSide(width: 1.0*factor),
                          borderRadius: const BorderRadius.all(const Radius.circular(0))
                        ),
                        contentPadding: const EdgeInsets.all(10.0)
                      ),
                    ))
                  ],
                ),
                new Container(height: 20.0),
                new Builder(builder: (ctx) {
                  return new CommonButton(
                    text: "提交",
                    color: new Color.fromARGB(255, 0, 215, 198),
                    onTap: () {
                      if (isRequesting) return;
                      // 拿到用户输入的账号密码
                      String title = titleCtrl.text.trim();
                      String detail = detailCtrl.text.trim();
                      if (title.isEmpty || detail.isEmpty) {
                        Scaffold.of(ctx).showSnackBar(new SnackBar(
                          content: new Text("标题和详情不能为空！"),
                        ));
                        return;
                      }
                      setState(() {
                        isRequesting = true;
                      });
                      // 发送给webview，让webview登录后再取回token
                      Api().addPost(userName, title, detail)
                        .then((Response response) {
                          setState(() {
                            isRequesting = false;
                          });
                          if(response.data['code'] != 1) {
                            Scaffold.of(ctx).showSnackBar(new SnackBar(
                              content: new Text("提交失败！"),
                            ));
                            return;
                          }
                          Navigator.pop(context, response.data['id']);
                        })
                        .catchError((e) {
                          setState(() {
                            isRequesting = false;
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