import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'dart:ui';
import 'package:flutter_app/app/model/post.dart';
import 'package:flutter_app/app/view/post/answer_list.dart';
import 'package:flutter_app/app/component/likebutton/like_button.dart';
import 'package:flutter_app/app/view/login_view.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:dio/dio.dart';
import 'package:date_format/date_format.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/util/util.dart';
import 'dart:io';

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
  String userName = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      _post = widget._post;
    });
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      setState(() {
        userName = prefs.getString('userName');
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    YaCaiUtil.getInstance().init(context);
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
      body: Stack(
        children: <Widget>[
          new SingleChildScrollView(
            child: new Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: new Padding(
                    padding: EdgeInsets.only(
                      left: 30.0*factor,
                      right: 30.0*factor,
                      top: 30.0*factor
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new RichText(
                          text: new TextSpan(
                            text: _post.title,
                            style: new TextStyle(
                                fontSize: 32.0*factor,
                                color: Colors.black
                            ),
                          ),
                        ),
                        new Padding(
                          padding: EdgeInsets.only(bottom: 20.0*factor),
                        ),
                        new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Padding(
                              padding: EdgeInsets.only(
                                right: 10.0*factor
                              ),
                              child: new Text(_post.askedBy, style: new TextStyle(
                                fontSize: 26*factor,
                                color: Colors.grey,
                                
                              )),
                            ),
                            new Text("发布于" + formatDate(DateTime.parse(_post.askedAt), [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]),
                              style: new TextStyle(
                                fontSize: 26*factor,
                                color: Colors.grey,
                                
                              )
                            ),
                          ],
                        ),
                        Container(height: 30*factor,),
                        new RichText(
                          text: new TextSpan(
                            text: _post.detail,
                            style: new TextStyle(
                                fontSize: 26.0*factor,
                                color: Colors.grey[800],
                                height: 1.6
                            ),
                          ),
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            new Container(
                              padding: EdgeInsets.only(right: 15.0*factor),
                              child: new Column(
                                children: <Widget>[
                                  new Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      LikeButton(
                                        width: 90*factor,
                                        isLiked: _post.like == 1 ? true : false,
                                        onIconClicked: (bool isLike) {
                                          if (isRequesting) return;
                                          setState(() {
                                            isRequesting = true;
                                          });
                                          // 发送给webview，让webview登录后再取回token
                                          Api().like(userName, isLike ? 1 : 0, _post.id, null)
                                            .then((Response response) {
                                              if(response.data['code'] != 1) {
                                                Scaffold.of(context).showSnackBar(new SnackBar(
                                                  content: new Text("点赞失败！"),
                                                ));
                                                return;
                                              }
                                              setState(() {
                                                isRequesting = false;
                                                _post.like = isLike ? 1 : 0;
                                                _post.votes = isLike ? (_post.votes + 1) : (_post.votes - 1);
                                              });
                                            })
                                            .catchError((e) {
                                              setState(() {
                                                isRequesting = false;
                                              });
                                              print(e);
                                            });
                                        }
                                      ),
                                      // new Icon(Icons.favorite, color: Colors.red, size: 26*factor),
                                      new Text(_post.votes.toString(), style: new TextStyle(fontSize: 28*factor,)),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ),
                Container(height: 20*factor, color: Color.fromARGB(255, 242, 242, 245),),
                Container(
                  color: Colors.white,
                  child: new Padding(
                    padding: EdgeInsets.only(
                      left: 30.0*factor,
                      right: 30.0*factor,
                    ),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Padding(
                          padding: EdgeInsets.symmetric(vertical: 30.0*factor),
                          child: new Text('全部回答 (${_post.answers.length})', style: new TextStyle(fontSize: 30*factor)),
                        ),
                        new AnswerList(_post.answers),
                      ],
                    ),
                  )
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: Platform.isAndroid ? 100*factor : 100*factor + 34,
              color: Colors.grey[200],
              padding: prefix0.EdgeInsets.only(bottom: Platform.isAndroid ? 0 : 34),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: 550*factor,
                    child: TextField(
                      style:TextStyle(fontSize: 26.0*factor),
                      controller: detailCtrl,
                      decoration: new InputDecoration(
                        hintText: "请输入",
                        hintStyle: new TextStyle(
                            color: const Color(0xFF808080),
                            fontSize: 26*factor
                        ),
                        border: new OutlineInputBorder(
                          borderSide: BorderSide(width: 1.0*factor),
                          borderRadius: BorderRadius.all(Radius.circular(6*factor))
                        ),
                        contentPadding: EdgeInsets.all(20.0*factor)
                      ),
                    ),
                  ),
                  FlatButton(
                    child: Container(
                      height: 66*factor,
                      child: Text("提交", style: TextStyle(color: Colors.white, fontSize: 28*factor, letterSpacing: 10*factor, height: 1.9),),
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      if(userName == '') {
                          _login();
                          return;
                        }
                        if (isRequesting) return;
                        // 拿到用户输入的账号密码
                        String detail = detailCtrl.text.trim();
                        if (detail.isEmpty) {
                          YaCaiUtil.getInstance().showMsg("回复不能为空！");
                          return;
                        }
                        setState(() {
                          isRequesting = true;
                        });
                        // 发送给webview，让webview登录后再取回token
                        Api().addAnswer(detail, userName, _post.id)
                          .then((Response response) {
                            if(response.data['code'] != 1) {
                              YaCaiUtil.getInstance().showMsg("提交失败！");
                              return;
                            }
                            _post.answers.add(
                              new Answer(
                                answer: detail,// 答复详情
                                answerBy: userName,// 答复人
                                answerAt: formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]),// 答复时间
                                votes: 0 // 点赞数
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
                    },
                  )
                ],
              ),
            ),
          )
        ],
      )
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