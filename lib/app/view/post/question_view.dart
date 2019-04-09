import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/component/common_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/app/model/constants.dart';

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

  Widget postTypeOption(BuildContext context, int index) {
    double factor = MediaQuery.of(context).size.width/750;
    return new InkWell(
      onTap: () {
        setState(() {
          type =  index + 1;
        });
      },
      child: new Container(
        height: 40*factor,
        width: 200*factor,
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.all(new Radius.circular(6*factor)),
          border: type == (index + 1) ? new Border.all(
            color: const Color(0xffaaaaaa),
            width: 2*factor
          ) : Border(),
        ),
        child: new Center(
          child: new Text(postTypeArr[index], style: TextStyle(fontSize: 22.0*factor),),
        ),
      ),
    );
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
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(30.0*factor),
            child: new Column(
              children: <Widget>[
                new Container(height: 20.0*factor),
                new Row(
                  children: <Widget>[
                    new Text("分类：", style: new TextStyle(fontSize: 22.0*factor)),
                    new Container(
                      height: 60*factor,
                      child: new ListView.builder(
                        shrinkWrap: true,
                        itemCount: postTypeArr.length,
                        itemBuilder: postTypeOption,
                        scrollDirection: Axis.horizontal,
                        physics: const ClampingScrollPhysics(),
                      ),
                    ),
                  ],
                ),
                new Container(height: 40.0*factor),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text("标题：", style: new TextStyle(fontSize: 22.0*factor)),
                    new Expanded(child: new TextField(
                      controller: titleCtrl,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      style: new TextStyle(fontSize: 22.0*factor),
                      decoration: new InputDecoration(
                        hintText: "请输入标题",
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
                new Container(height: 40.0*factor),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text("详情：", style: new TextStyle(fontSize: 22.0*factor)),
                    new Expanded(child: new TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 15,
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
                          borderRadius: BorderRadius.all(Radius.circular(6*factor))
                        ),
                        contentPadding: EdgeInsets.all(20.0*factor)
                      ),
                    ))
                  ],
                ),
                Container(height: 40*factor,),
                FlatButton(
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
                    String title = titleCtrl.text.trim();
                    String detail = detailCtrl.text.trim();
                    if (title.isEmpty || detail.isEmpty) {
                      Scaffold.of(context).showSnackBar(new SnackBar(
                        content: new Text("标题和详情不能为空！"),
                      ));
                      return;
                    }
                    setState(() {
                      isRequesting = true;
                    });
                    // 发送给webview，让webview登录后再取回token
                    Api().addPost(userName, title, detail, type)
                      .then((Response response) {
                        setState(() {
                          isRequesting = false;
                        });
                        if(response.data['code'] != 1) {
                          Scaffold.of(context).showSnackBar(new SnackBar(
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
        ],
      )
      
    );
  }
}