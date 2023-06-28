import 'package:flutter/material.dart';
import 'package:flutter_app/app/item/communicatelist_item.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' as Spinkit;
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_app/app/model/communicate.dart';
import 'package:flutter_app/app/view/communicate.dart';

class MsgList extends StatefulWidget {
  MsgList();
  @override
  MsgListState createState() => new MsgListState();
}

class MsgListState extends State<MsgList> with SingleTickerProviderStateMixin {
  List<CommunicateModel> _posts = [];
  String userName = '';
  bool isRequesting = false;
  int currentPage = 1, totalPage = 1;

  @override
  void initState() {
    super.initState();
    getConversationList(1);
  }

  @override
  void dispose() {
    currentPage = 1;
    totalPage = 1;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width / 750;
    return new Scaffold(
        backgroundColor: new Color.fromARGB(255, 242, 242, 245),
        appBar: new AppBar(
          elevation: 0.0,
          title: new Text("消息",
              style:
                  new TextStyle(fontSize: 30.0 * factor, color: Colors.white)),
        ),
        body: isRequesting
            ? new Stack(children: <Widget>[
                Positioned.fill(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration:
                        BoxDecoration(color: Color.fromARGB(190, 0, 0, 0)),
                  ),
                ),
                Positioned.fill(
                  child: Spinkit.SpinKitHourGlass(
                    color: Theme.of(context).primaryColor,
                    size: 50 * factor,
                    duration: Duration(milliseconds: 1800),
                  ),
                )
              ])
            : new Stack(children: <Widget>[
                _posts.length == 0
                    ? Center(
                        child: Text(
                          "该板块还没有人发帖，快来抢沙发吧~",
                          style: TextStyle(fontSize: 28 * factor),
                        ),
                      )
                    : EasyRefresh(
                        onRefresh: () {
                          return getConversationList(1);
                        },
                        onLoad: () async {
                          getConversationList(currentPage);
                        },
                        child: new ListView.builder(
                            itemCount: _posts.length,
                            itemBuilder: buildJobItem))
              ]));
  }

  Widget _pageAnimation(_, Animation<double> animation, __, Widget child) {
    return new FadeTransition(
      opacity: animation,
      child: new SlideTransition(
          position: new Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(animation),
          child: child),
    );
  }

  Widget buildJobItem(BuildContext context, int index) {
    CommunicateModel post = _posts[index];

    return new InkWell(
        onTap: () => navPostDetail(post), child: new CommunicateListItem(post));
  }

  Future getConversationList(int page) async {
    currentPage = page;
    // if(page > totalPage) {
    //   return;
    // }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int hunterId = prefs.getInt('userId');
    return Api().getConversationList(hunterId).then((Response response) {
      if (!mounted) {
        return;
      }
      if (response.data['code'] == 1) {
        setState(() {
          _posts = CommunicateModel.fromJson(response.data['list']);
        });
      }
      setState(() {
        isRequesting = false;
      });
    }).catchError((e) {
      setState(() {
        isRequesting = false;
      });
      print(e);
    });
  }

  navPostDetail(CommunicateModel post) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new CommunicateView(post.jobId, post.jobSeekerId);
        },
        transitionsBuilder: _pageAnimation));
  }
}
