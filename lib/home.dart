import 'package:flutter/material.dart';
import 'package:flutter_app/app/component/icon_tab.dart';
import 'package:flutter_app/app/view/jobs_view.dart';
import 'package:flutter_app/app/view/message_view.dart';
import 'package:flutter_app/app/view/mine_view.dart';
import 'dart:io';
// import 'package:flutter_2d_amap/flutter_2d_amap.dart';
// import 'package:amap_base/amap_base.dart';

const int INDEX_JOB = 0;
const int INDEX_COMPANY = 1;
const int INDEX_STUDY = 2;
const int INDEX_MESSAGE = 3;
const int INDEX_MINE = 4;


class BossApp extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<BossApp> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  TabController _controller;
  VoidCallback onChanged;
  Widget mine = new MineTab();

  @override
  void initState() {
    super.initState();
    _controller =
        new TabController(initialIndex: _currentIndex, length: 5, vsync: this);
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
    double _kTabTextSize = 20.0 * factor;
    Color _kPrimaryColor = Theme.of(context).primaryColor;
    return new Scaffold(
      body: new TabBarView(
        children: <Widget>[
          new JobsTab(1, '全职'),
          new JobsTab(2, '兼职'),
          new JobsTab(3, '实习'),
          new MessageTab(),
          mine
        ],
        controller: _controller,
      ),
      bottomNavigationBar: new Material(
        color: Colors.white,
        elevation: 4.0,
        shadowColor: Color(0xFF788db4),
        child: SafeArea(
          child: new TabBar(
            controller: _controller,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: new TextStyle(fontSize: _kTabTextSize),
            tabs: <IconTab>[
              new IconTab(
                  color: _currentIndex == INDEX_JOB ? _kPrimaryColor : Colors.black,
                  text: "全职",
                  iconData: _currentIndex == INDEX_JOB
                      ? Image.asset('assets/images/full_active.png', width: 50.0*factor)
                      : Image.asset('assets/images/full.png', width: 50.0*factor)
              ),
              new IconTab(
                  color: _currentIndex == INDEX_COMPANY ? _kPrimaryColor : Colors.black,
                  text: "兼职",
                  iconData: _currentIndex == INDEX_COMPANY
                      ? Image.asset('assets/images/parttime_active.png', width: 50.0*factor)
                      : Image.asset('assets/images/parttime.png', width: 50.0*factor)
              ),
              new IconTab(
                  color: _currentIndex == INDEX_STUDY ? _kPrimaryColor : Colors.black,
                  text: "实习",
                  iconData: _currentIndex == INDEX_STUDY
                      ? Image.asset('assets/images/practice_active.png', width: 50.0*factor)
                      : Image.asset('assets/images/practice.png', width: 50.0*factor)
              ),
              new IconTab(
                  color: _currentIndex == INDEX_MESSAGE ? _kPrimaryColor : Colors.black,
                  text: "交流",
                  iconData: _currentIndex == INDEX_MESSAGE
                      ? Image.asset('assets/images/msg_active.png', width: 50.0*factor)
                      : Image.asset('assets/images/msg.png', width: 50.0*factor)
              ),
              new IconTab(
                  color: _currentIndex == INDEX_MINE ? _kPrimaryColor : Colors.black,
                  text: "我的",
                  iconData: (_currentIndex == INDEX_MINE)
                      ? Image.asset('assets/images/mine_active.png', width: 50.0*factor)
                      : Image.asset('assets/images/mine.png', width: 50.0*factor)
              )
            ],
          ),
        )
      ),
    );
  }
}

void main() {
  runApp(new MaterialApp(
      title: "丫财",
      theme: new ThemeData(
        primaryIconTheme: const IconThemeData(color: Colors.white),
        brightness: Brightness.light,
        primaryColor: new Color.fromRGBO(90, 169, 226, 1),
        accentColor: Colors.cyan[300],
      ),
      home: new BossApp()
  ));
}
