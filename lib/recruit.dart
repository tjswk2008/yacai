import 'package:flutter/material.dart';
import 'package:flutter_app/app/component/icon_tab.dart';
import 'package:flutter_app/app/recruit_view/pub_list.dart';
import 'package:flutter_app/app/recruit_view/resume_list.dart';
import 'package:flutter_app/app/recruit_view/mine_view.dart';
import 'package:flutter_app/app/recruit_view/msg_list.dart';
import 'dart:io';
// import 'package:amap_base/amap_base.dart';
// import 'package:flutter_2d_amap/flutter_2d_amap.dart';

const double _kTabTextSize = 11.0;
const int INDEX_RESUME = 0;
const int INDEX_PUB = 1;
const int INDEX_MSG = 2;
const int INDEX_MINE = 3;


class Recruit extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<Recruit> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  TabController _controller;
  VoidCallback onChanged;

  @override
  void initState() {
    super.initState();
    _controller =
        new TabController(initialIndex: _currentIndex, length: 4, vsync: this);
    onChanged = () {
      setState(() {
        _currentIndex = this._controller.index;
      });
    };

    _controller.addListener(onChanged);

    if(Platform.isIOS) {
      // AMap.init('c55ccc3e7e0e767fb718b90f592a75f2');
    } 
  }

  @override
  void dispose() {
    _controller.removeListener(onChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    Color _kPrimaryColor = Theme.of(context).primaryColor;
    return new Scaffold(
      body: new TabBarView(
        children: <Widget>[
          new ResumeTab('精英简历', null, 1),
          new PubTab('我的职位'),
          new MsgList(),
          new MineTab(),
        ],
        controller: _controller,
      ),
      bottomNavigationBar: new Material(
        color: Colors.white,
        elevation: 4.0,
        child: SafeArea(
          bottom: true,
          child: new TabBar(
            controller: _controller,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: new TextStyle(fontSize: _kTabTextSize*factor),
            tabs: <IconTab>[
              new IconTab(
                  color: _currentIndex == INDEX_RESUME ? _kPrimaryColor : Colors.grey[900],
                  text: "简历大厅",
                  iconData: Icon(Icons.school, size: 50.0*factor, color: _currentIndex == INDEX_RESUME ? _kPrimaryColor : Colors.grey[900],)
              ),
              new IconTab(
                  color: _currentIndex == INDEX_PUB ? _kPrimaryColor : Colors.grey[900],
                  iconData: Icon(Icons.work, size: 50.0*factor, color: _currentIndex == INDEX_PUB ? _kPrimaryColor : Colors.grey[900],),
                  text: "职位"
              ),
              new IconTab(
                  color: _currentIndex == INDEX_MSG ? _kPrimaryColor : Colors.grey[900],
                  iconData: Icon(Icons.message, size: 50.0*factor, color: _currentIndex == INDEX_MSG ? _kPrimaryColor : Colors.grey[900],),
                  text: "消息"
              ),
              new IconTab(
                  color: _currentIndex == INDEX_MINE ? _kPrimaryColor : Colors.grey[900],
                  iconData: Icon(Icons.person, size: 50.0*factor, color: _currentIndex == INDEX_MINE ? _kPrimaryColor : Colors.grey[900],),
                  text: "我的"
              )
            ],
          ),
        )
      ),
    );
  }
}
