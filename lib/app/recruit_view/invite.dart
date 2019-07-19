import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  String userName = '';
  int type = 1;
  String detail = '';
  int accepted = 0;

  int role = 1;

  TextEditingController invitation = new TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    Api().getInvitation(widget.jobId, widget.userId).then((Response response) {
      if(response.data['code'] == 1) {
        if(response.data['info'] != null) {
          setState(() {
            detail = response.data['info']['detail'];
            accepted = response.data['info']['accepted'];
          });
        }
      }
      setState(() {
        invitation = TextEditingController.fromValue(
          TextEditingValue(
            // 设置内容
            text: detail == null ? '' : detail,
            // 保持光标在最后
            selection: TextSelection.fromPosition(
              TextPosition(
                affinity: TextAffinity.downstream,
                offset: detail == null ? 0 : detail.length
              )
            )
          )
        );
      });
      return SharedPreferences.getInstance();
    }).then((SharedPreferences prefs) {
      setState(() {
        userName = prefs.getString('userName');
        role = prefs.getInt('role');
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(role == 1 ? "邀请函" : "发送邀请函", style: new TextStyle(color: Colors.white, fontSize: 30.0*factor)),
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
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 20*factor),
                      child: new Text("邀请函：", style: new TextStyle(fontSize: 24.0*factor)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20*factor),
                      child: accepted == 2 ? Text("(已拒绝邀请)", style: new TextStyle(fontSize: 24.0*factor, color: Colors.red))
                          : accepted == 1 ? Text("(已接受邀请)", style: new TextStyle(fontSize: 24.0*factor, color: Colors.green))
                          : Container(),
                    ),
                  ],
                ),
                
                new Expanded(
                  child: role == 1 ? RichText(
                  text: new TextSpan(
                    text: detail,
                    style: new TextStyle(
                        fontSize: 24.0*factor,
                        color: Colors.black
                    ),
                  ),
                ) : new TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 20,
                    controller: invitation,
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
                  )
                )
              ],
            ),
          ),
          Positioned(
            bottom: 30.0*factor,
            left: 30.0*factor,
            width: MediaQuery.of(context).size.width - 60*factor,
            child: role == 1 ? (accepted == 0 ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FlatButton(
                  child: new Container(
                    width: 200*factor,
                    height: 70*factor,
                    child: new Center(
                      child: Text(
                        "拒绝邀请",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.0*factor,
                        ),
                      ),
                    ),
                  ),
                  color: Colors.orange,
                  onPressed: () async {
                    if (isRequesting) return;
                    showDialog<Null>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return new AlertDialog(
                          content: Text("确认要拒绝邀请么？", style: TextStyle(fontSize: 28*factor),),
                          actions: <Widget>[
                            new FlatButton(
                              child: new Text('取消', style: TextStyle(fontSize: 24*factor),),
                              onPressed: () {
                                  Navigator.of(context).pop();
                              },
                            ),
                            new FlatButton(
                              child: new Text('确定', style: TextStyle(fontSize: 24*factor, color: Colors.orange),),
                              onPressed: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    isRequesting = true;
                                  });
                                  // 发送给webview，让webview登录后再取回token

                                  Api().updateInvitation(widget.jobId, widget.userId, 2)
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
                                              content: Text("已拒绝面试邀请！", style: TextStyle(fontSize: 28*factor),),
                                              actions: <Widget>[
                                                new FlatButton(
                                                  child: new Text('知道了', style: TextStyle(fontSize: 24*factor),),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    setState(() {
                                                      accepted = 2;
                                                    });
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
                                },
                            ),
                          ],
                        );
                      },
                    );
                    
                  }
                ),
                FlatButton(
                  child: new Container(
                    width: 200*factor,
                    height: 70*factor,
                    child: new Center(
                      child: Text(
                        "接受邀请",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.0*factor,
                        ),
                      ),
                    ),
                  ),
                  color: Theme.of(context).primaryColor,
                  onPressed: () async {
                    if (isRequesting) return;
                    if (isRequesting) return;
                    showDialog<Null>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                          return new AlertDialog(
                              content: Text("确认要接受邀请么？", style: TextStyle(fontSize: 28*factor),),
                              actions: <Widget>[
                                  new FlatButton(
                                      child: new Text('取消', style: TextStyle(fontSize: 24*factor, color: Colors.orange),),
                                      onPressed: () {
                                          Navigator.of(context).pop();
                                      },
                                  ),
                                  new FlatButton(
                                      child: new Text('确定', style: TextStyle(fontSize: 24*factor),),
                                      onPressed: () {
                                          Navigator.of(context).pop();
                                          setState(() {
                                            isRequesting = true;
                                          });
                                          // 发送给webview，让webview登录后再取回token

                                          Api().updateInvitation(widget.jobId, widget.userId, 1)
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
                                                          content: Text("已接受面试邀请！", style: TextStyle(fontSize: 28*factor),),
                                                          actions: <Widget>[
                                                              new FlatButton(
                                                                  child: new Text('知道了', style: TextStyle(fontSize: 24*factor),),
                                                                  onPressed: () {
                                                                      Navigator.of(context).pop();
                                                                      setState(() {
                                                                        accepted = 1;
                                                                      });
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
                                      },
                                  ),
                              ],
                          );
                      },
                    );
                  }
                ),
              ],
            ) : Container()): FlatButton(
              child: new Container(
                height: 70*factor,
                child: new Center(
                  child: Text(
                    "发送",
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
                if (invitation.text == '') {
                  Scaffold.of(context).showSnackBar(new SnackBar(
                    content: new Text("邀请函不能为空！"),
                  ));
                  return;
                }
                setState(() {
                  isRequesting = true;
                });
                // 发送给webview，让webview登录后再取回token

                Api().invite(userName, invitation.text, widget.jobId, widget.userId)
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