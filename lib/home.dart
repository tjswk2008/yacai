import 'package:flutter/material.dart';
import 'package:flutter_app/app/component/icon_tab.dart';
import 'package:flutter_app/app/view/jobs_view.dart';
import 'package:flutter_app/app/view/message_view.dart';
import 'package:flutter_app/app/view/mine_view.dart';

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
  }

  @override
  void dispose() {
    _controller.removeListener(onChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidthInPt = MediaQuery.of(context).size.width;
    double _kTabTextSize = 20.0 * screenWidthInPt/750;
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
        child: SafeArea(
          child: new TabBar(
            controller: _controller,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: new TextStyle(fontSize: _kTabTextSize),
            tabs: <IconTab>[
              new IconTab(
                  iconData: Icons.business,
                  text: "全职",
                  color: _currentIndex == INDEX_JOB
                      ? _kPrimaryColor
                      : Colors.grey[900]),
              new IconTab(
                  iconData: Icons.business_center,
                  text: "兼职",
                  color: _currentIndex == INDEX_COMPANY
                      ? _kPrimaryColor
                      : Colors.grey[900]),
              new IconTab(
                  iconData: Icons.school,
                  text: "实习",
                  color: _currentIndex == INDEX_STUDY
                      ? _kPrimaryColor
                      : Colors.grey[900]),
              new IconTab(
                  iconData: Icons.content_paste,
                  text: "交流",
                  color: _currentIndex == INDEX_MESSAGE
                      ? _kPrimaryColor
                      : Colors.grey[900]),
              new IconTab(
                  iconData: Icons.person_outline,
                  text: "我的",
                  color: (_currentIndex == INDEX_MINE)
                      ? _kPrimaryColor
                      : Colors.grey[900]),
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
