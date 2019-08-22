import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/app/model/constants.dart';
import 'package:flutter_app/util/util.dart';
import 'package:flutter_app/app/component/select.dart';
import 'package:flutter_app/app/component/text_area.dart';

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
  String title = '';
  String detail = '';
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
          child: new Text(postTypeArr[index], style: TextStyle(fontSize: 28.0*factor),),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    YaCaiUtil.getInstance().init(context);
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
            padding: EdgeInsets.all(50.0*factor),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(height: 20.0*factor),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.only(bottom: 20.0*factor),
                      child: new Text(
                        '分类：',
                        textAlign: TextAlign.left,
                        style: new TextStyle(fontSize: 28.0*factor),
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(bottom: 16.0*factor),
                      child: new InkWell(
                        onTap: () {
                          // _showJobStatus(context);
                          YCPicker.showYCPicker(
                            context,
                            selectItem: (res) {
                              setState(() {
                                type =  postTypeArr.indexOf(res) + 1;
                              });
                            },
                            data: postTypeArr,
                          );
                        },
                        child: new Text(postTypeArr[type - 1], style: TextStyle(fontSize: 26.0*factor),),
                      )
                    ),
                  ],
                ),
                Divider(),
                new Container(height: 40.0*factor),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text("标题：", style: new TextStyle(fontSize: 28.0*factor))
                  ],
                ),
                TextArea(
                  text: title,
                  callback: (String val) {
                    setState(() {
                      title = val;
                    });
                  },
                ),
                Divider(),
                new Container(height: 40.0*factor),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text("详情：", style: new TextStyle(fontSize: 28.0*factor))
                  ],
                ),
                TextArea(
                  text: detail,
                  callback: (String val) {
                    setState(() {
                      detail = val;
                    });
                  },
                ),
                Container(height: 40*factor,),
                
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
          ),
          Positioned(
            bottom: 50*factor,
            right: 50*factor,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(
                Icons.check,
                size: 50.0*factor,
                color: Colors.white,
              ),
              onPressed: () async {
                if (isRequesting) return;
                // 拿到用户输入的账号密码
                if (title.isEmpty || detail.isEmpty) {
                  YaCaiUtil.getInstance().showMsg("请填写完整标题和详情哦~");
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
                      YaCaiUtil.getInstance().showMsg("提交失败~");
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
              },
            ),
          )
        ],
      ),
    );
  }
}