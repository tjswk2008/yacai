import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/app/component/bubble_widget.dart';
import 'package:flutter_app/app/model/communicate.dart';
import 'dart:io';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/app/model/app.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:dio/dio.dart';

class CommunicateView extends StatefulWidget {
  final int _jobId;
  final int _userId;
  CommunicateView(this._jobId, this._userId);
  @override
  CommunicateViewState createState() => new CommunicateViewState();
}

class CommunicateViewState extends State<CommunicateView> with SingleTickerProviderStateMixin {
  String userName = '';
  bool isRequesting = false;
  final TextEditingController _textController = new TextEditingController();
  ScrollController _scrollController = ScrollController();
  List<CommunicateModel> _messageList = <CommunicateModel>[];
  String hunterAvatar = '';
  String jobSeekerAvatar = '';
  int hunterId;
  int role;

  @override
  void initState() {
    super.initState();
    getMsgList(widget._jobId);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, appState) {
        return new Scaffold(
          backgroundColor: new Color.fromARGB(255, 242, 242, 245),
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
            title: new Text("沟通详情",
                style: new TextStyle(fontSize: 30.0*factor, color: Colors.white)),
          ),
          body: new Builder(builder: (BuildContext context) {
            return new Column(children: <Widget>[
              Container(
                height: 30 * factor,
              ),
              new Flexible(
                child: new ListView.builder(
                  controller: _scrollController,
                  physics: BouncingScrollPhysics(),
                  itemCount: _messageList.length,
                  itemBuilder: (context, i) {
                    return _buildRow(_messageList[i]);
                  },
                ),
              ),
              new Divider(height: 1.0),
              new Container(
                child: _buildComposer(context),
                decoration:
                    new BoxDecoration(color: Color.fromRGBO(241, 243, 244, 0.9)),
              ),
            ]);
          }),
        );
      }
    );
  }

  Widget _buildComposer(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return new Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: Platform.isAndroid ? 100*factor : 100*factor + 34,
      color: Colors.grey[200],
      padding: EdgeInsets.only(bottom: Platform.isAndroid ? 0 : 34),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            width: 550*factor,
            child: new TextField(
              textInputAction: TextInputAction.send,
              controller: _textController,
              style:TextStyle(fontSize: 26.0*factor),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(20.0*factor),
                hintText: "想说点儿什么？",
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(6*factor)),
                ),
              ),
            ),
          ),
          FlatButton(
            child: Container(
              height: 68*factor,
              child: Text("提交", style: TextStyle(color: Colors.white, fontSize: 28*factor, letterSpacing: 10*factor, height: 1.9),),
            ),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              _submitMsg();
            }
          )
        ],
      ),
    );
  }

  void getMsgList(int jobId) async {
    try {
      
      if (!mounted) {
        return;
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        role = prefs.getInt('role');
      });
      List<Response> resList = await Future.wait([
        Api().getConversationBySeekerId(jobId, widget._userId),
        Api().getjob(jobId),
        Api().getUserAvatar(widget._userId)
      ]);
      if (resList[0].data['code'] == 1) {
        setState(() {
          _messageList = CommunicateModel.fromJson(resList[0].data['data']);
        });
      }
      if (resList[1].data['code'] == 1) {
        setState(() {
          hunterAvatar = resList[1].data['data'][0]['avatar'];
          hunterId = resList[1].data['data'][0]['userId'];
        });
      }
      if (resList[2].data['code'] == 1) {
        setState(() {
          jobSeekerAvatar = resList[2].data['info']['avatar'];
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> _getId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }
  
  void _submitMsg() async {
    String text = _textController.text.trim();
    if (text == null || text == "") {
      return;
    }
    if (isRequesting) {
      return;
    }
    Map<String, dynamic> map = {
      "jobSeekerId": widget._userId,
      "jobId": widget._jobId,
      "hunterId": hunterId,
      "msg": text,
      "role": role
    };
    if(_messageList.length == 0) {
      map['sessionId'] = await _getId();
    } else {
      map['sessionId'] = _messageList[0].sessionId;
    }
    setState(() {
      isRequesting = true;
    });
    Api().saveMsg(map)
      .then((Response response) {
        if (response.data['code'] == 1) {
          setState(() {
            _messageList.add(CommunicateModel.fromMap(map));
          });
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
          _textController.clear();
        }
        setState(() {
          isRequesting = false;
        });
      })
     .catchError((e) {
       setState(() {
          isRequesting = false;
        });
       print(e);
     });
  }

  Widget _buildRow(CommunicateModel communicateModel) {
    double factor = MediaQuery.of(context).size.width/750;
    //这个文本框长度并不能很好地自适应英文，还需要后期进行计算调整
    bool _isChoiceUser = communicateModel.role == role;// communicateModel.jobSeekerId == personalInfo.id;
    //文本类型处理
    double bubbleWidth = communicateModel.msg.length * 25.0 > 260.0
          ? 265 * 1.8 * factor
          : communicateModel.msg.length * 30.0 * 1.8 * factor;
      double bubbleHeight = 90.0 * factor;
      if (communicateModel.msg.length > 20 && communicateModel.msg.length < 30) {
        bubbleHeight = 108.0 * 1.4 * factor;
      }
      if (communicateModel.msg.length > 30 && communicateModel.msg.length < 60) {
        bubbleHeight = communicateModel.msg.length / 10 * 42.0 * factor;
      }
      if (communicateModel.msg.length >= 60) {
        bubbleHeight = communicateModel.msg.length / 10 * 33.0 * factor;
      }

      return new GestureDetector(
        child: Padding(
          padding: EdgeInsets.all(4 * 1.8 * factor),
          child: Container(
              alignment:
                  _isChoiceUser ? Alignment.centerRight : Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _isChoiceUser ? Container() : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10 * factor),
                    child: new CircleAvatar(
                      radius: 30.0*factor,
                      backgroundImage: new NetworkImage(communicateModel.role == 2 ? hunterAvatar : jobSeekerAvatar)
                    ),
                  ),
                  BubbleWidget(
                    bubbleWidth,
                    bubbleHeight,
                    _isChoiceUser
                        ? Colors.green.withOpacity(0.7)
                        : Color.fromRGBO(255, 255, 255, 0.9),
                    _isChoiceUser
                        ? BubbleArrowDirection.right
                        : BubbleArrowDirection.left,
                    arrAngle: 65,
                    child: Text(
                      communicateModel.msg,
                      style: TextStyle(color: Colors.black, fontSize: 17.0 * 1.8 * factor, height: 1.5)
                    )
                  ),
                  _isChoiceUser ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10 * factor),
                    child: new CircleAvatar(
                      radius: 30.0*factor,
                      backgroundImage: new NetworkImage(communicateModel.role == 2 ? hunterAvatar : jobSeekerAvatar)
                    ),
                  ) : Container(),
                ]
              )
            ),
      )
    );
  }
}
