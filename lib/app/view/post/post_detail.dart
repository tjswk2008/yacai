import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_app/app/model/post.dart';
import 'package:flutter_app/app/view/post/answer_list.dart';
import 'package:flutter_app/app/component/common_button.dart';
import 'package:flutter_app/app/view/login_view.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/app/model/app.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:flutter_app/actions/actions.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:dio/dio.dart';
import 'package:date_format/date_format.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

class PostDetail extends StatefulWidget {

  final Post _post;

  PostDetail(this._post);

  @override
  PostDetailState createState() => new PostDetailState();
}

class PostDetailState extends State<PostDetail>
    with TickerProviderStateMixin {

  VoidCallback onChanged;
  bool isRequesting = false;
  final detailCtrl = new TextEditingController(text: '');
  Post _post;

  @override
  void initState() {
    super.initState();
    setState(() {
      _post = widget._post;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return StoreConnector<AppState, String>(
      converter: (store) => store.state.userName,
      builder: (context, userName) {
        return new Scaffold(
          backgroundColor: Colors.white,
          appBar: new AppBar(
            elevation: 0.0,
            leading: IconButton(
              icon: const BackButtonIcon(),
              iconSize: 40*factor,
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: () {
                Navigator.maybePop(context);
              }
            ),
            title: new Text("帖子详情",
                style: new TextStyle(fontSize: 30.0*factor, color: Colors.white)),
          ),
          body: new SingleChildScrollView(
            child: new Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(
                    left: 20.0*factor,
                    right: 20.0*factor,
                    top: 10.0*factor
                  ),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new RichText(
                        text: new TextSpan(
                          text: _post.title,
                          style: new TextStyle(
                              fontSize: 22.0*factor,
                              color: Colors.black
                          ),
                        ),
                      ),
                      new Divider(),
                      new Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Container(
                            width: 80.0*factor,
                            padding: EdgeInsets.only(right: 15.0*factor),
                            child: new Column(
                              children: <Widget>[
                                new Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    new Icon(Icons.favorite, color: Colors.red, size: 20*factor),
                                    new Text(_post.votes.toString(), style: new TextStyle(fontSize: 20*factor)),
                                  ],
                                )
                              ],
                            ),
                          ),
                          new Expanded(
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new RichText(
                                  text: new TextSpan(
                                    text: _post.detail,
                                    style: new TextStyle(
                                        fontSize: 16.0*factor,
                                        color: Colors.black
                                    ),
                                  ),
                                ),
                                new Padding(
                                  padding: EdgeInsets.only(bottom: 5.0*factor),
                                ),
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Padding(
                                      padding: EdgeInsets.only(
                                        right: 10.0*factor
                                      ),
                                      child: new Text(_post.askedBy, style: new TextStyle(fontSize: 20*factor)),
                                    ),
                                    new Text(_post.askedAt, style: new TextStyle(fontSize: 20*factor)),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      new Divider(),
                      new Padding(
                        padding: EdgeInsets.only(bottom: 10.0*factor),
                        child: new Text('${_post.answers.length}个回答：', style: new TextStyle(fontSize: 20*factor)),
                      ),
                      new AnswerList(_post.answers),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text("您的回答：", style: new TextStyle(fontSize: 20*factor)),
                          new Expanded(child: new TextField(
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            style:TextStyle(fontSize: 20.0*factor),
                            controller: detailCtrl,
                            decoration: new InputDecoration(
                              hintText: "请输入",
                              hintStyle: new TextStyle(
                                  color: const Color(0xFF808080),
                                  fontSize: 20*factor
                              ),
                              border: new OutlineInputBorder(
                                borderSide: BorderSide(width: 1.0*factor),
                                borderRadius: BorderRadius.all(Radius.circular(6*factor))
                              ),
                              contentPadding: EdgeInsets.all(10.0*factor)
                            ),
                          ))
                        ],
                      ),
                      new Container(height: 20.0*factor),
                      new Builder(builder: (ctx) {
                        return new CommonButton(
                          text: "提交你的回复",
                          color: new Color.fromARGB(255, 0, 215, 198),
                          onTap: () {
                            if(userName == '') {
                              _login();
                              return;
                            }
                            if (isRequesting) return;
                            // 拿到用户输入的账号密码
                            String detail = detailCtrl.text.trim();
                            if (detail.isEmpty) {
                              Scaffold.of(ctx).showSnackBar(new SnackBar(
                                content: new Text("回复不能为空！"),
                              ));
                              return;
                            }
                            setState(() {
                              isRequesting = true;
                            });
                            // 发送给webview，让webview登录后再取回token
                            Api().addAnswer(detail, userName, _post.id)
                              .then((Response response) {
                                if(response.data['code'] != 1) {
                                  Scaffold.of(ctx).showSnackBar(new SnackBar(
                                    content: new Text("提交失败！"),
                                  ));
                                  return;
                                }
                                _post.answers.add(
                                  new Answer(
                                    answer: detail,// 答复详情
                                    answerBy: userName,// 答复人
                                    answerAt: formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]),// 答复时间
                                    votes: '0' // 点赞数
                                  )
                                );
                                setState(() {
                                  isRequesting = false;
                                  // _post = _post;
                                });
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
                      new Container(height: 20.0*factor),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  _login() {
    Navigator
      .of(context)
      .push(new MaterialPageRoute(builder: (context) {
        return new NewLoginPage();
      }));
  }
}