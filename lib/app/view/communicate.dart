import 'package:flutter/material.dart';
import 'package:flutter_app/app/component/bubble_widget.dart';
import 'package:flutter_app/app/model/communicate.dart';
import 'dart:io';

class CommunicateView extends StatefulWidget {
  CommunicateView();
  @override
  CommunicateViewState createState() => new CommunicateViewState();
}

class CommunicateViewState extends State<CommunicateView> with SingleTickerProviderStateMixin {
  String userName = '';
  bool isRequesting = false;
  final TextEditingController _textController = new TextEditingController();
  ScrollController _scrollController = ScrollController();
  List<CommunicateModel> _messageList = <CommunicateModel>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
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
            onPressed: _submitMsg
          )
        ],
      ),
    );
  }

  void _submitMsg() async {
    String text = _textController.text.trim();
    if (text == null || text == "") {
      return;
    }
    
    Map<String, dynamic> map = {
      "fromUserName": "Andy",
      "fromSessionId": "0",
      "msgId": new DateTime.now().millisecondsSinceEpoch.toString(),
      "msg": text,
      "to": "Sandy",
      "type": 2
    };
    CommunicateModel communicateModel = CommunicateModel.fromJson(map);
    List<String> list = [];
    if (list == null) {
      list = [];
    } else if (list.length >= 100) {
      list.removeAt(0);
    }
    list.add(communicateModel.toJsonString());
    setState(() {
      _messageList.add(CommunicateModel.fromJson(map));
    });
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
    _textController.clear();
    // TODO: 发送到服务器
  }

  Widget _buildRow(CommunicateModel communicateModel) {
    //这个文本框长度并不能很好地自适应英文，还需要后期进行计算调整
    bool _isChoiceUser = communicateModel.fromUserName != "Sandy";
    //文本类型处理
    if(communicateModel.msgType == null||communicateModel.msgType ==1) {
      double bubbleWidth = communicateModel.msg.length * 25.0 > 260.0
          ? 265
          : communicateModel.msg.length * 30.0;
      double bubbleHeight = 50.0;
      if (communicateModel.msg.length > 20 && communicateModel.msg.length < 30) {
        bubbleHeight = 60.0 * 1.4;
      }
      if (communicateModel.msg.length > 30 && communicateModel.msg.length < 60) {
        bubbleHeight = communicateModel.msg.length / 18 * 42.0;
      }
      if (communicateModel.msg.length >= 60) {
        bubbleHeight = communicateModel.msg.length / 18 * 33.0;
      }

      return new GestureDetector(
        child: Padding(
            padding: EdgeInsets.all(4.0),
            child: Container(
                alignment:
                    _isChoiceUser ? Alignment.centerRight : Alignment.centerLeft,
                child: BubbleWidget(
                    bubbleWidth,
                    bubbleHeight,
                    _isChoiceUser
                        ? Colors.green.withOpacity(0.7)
                        : Color.fromRGBO(71, 71, 71, 0.9),
                    _isChoiceUser
                        ? BubbleArrowDirection.right
                        : BubbleArrowDirection.left,
                    arrAngle: 65,
                    child: Text(communicateModel.msg,
                        style: TextStyle(color: Colors.white, fontSize: 17.0))))),
      );
    }
  }
}
