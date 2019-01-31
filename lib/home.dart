import 'package:flutter/material.dart';
import 'package:flutter_app/app/component/icon_tab.dart';
import 'package:flutter_app/app/model/job.dart';
import 'package:flutter_app/app/model/post.dart';
import 'package:flutter_app/app/view/jobs_view.dart';
import 'package:flutter_app/app/view/message_view.dart';
import 'package:flutter_app/app/view/mine_view.dart';
import 'package:dio/dio.dart';

const double _kTabTextSize = 11.0;
const int INDEX_JOB = 0;
const int INDEX_COMPANY = 1;
const int INDEX_MESSAGE = 2;
const int INDEX_MINE = 3;
Color _kPrimaryColor = new Color.fromARGB(255, 0, 215, 198);

class BossApp extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<BossApp> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  TabController _controller;
  VoidCallback onChanged;
  Widget mine = new MineTab();
  
  static String postsJson = """
      {
        "list": [
          {
            "title": "请教一下大家新的个税政策出台后，工资该如何计算呢？",
            "detail": "请教一下大家新的个税政策出台后，工资该如何计算呢？detail1",
            "viewers": "155",
            "votes": "234",
            "latestStatus": "Sandy于3分钟前回答",
            "askedBy": "sandyHe",
            "askedAt": "2019-01-01",
            "answers": [
              {
                "answer": "请教一下大家新的个税政策出台后，工资该如何计算呢？answer1",
                "answerBy": "answerBy1",
                "answerAt": "2018-12-12",
                "votes": "55",
                "commets": [
                  {
                    "answer": "请教一下大家新的个税政策出台后，工资该如何计算呢？commet1",
                    "answerBy": "byCommet1",
                    "answerAt": "2018-12-12"
                  },
                  {
                    "answer": "请教一下大家新的个税政策出台后，工资该如何计算呢？commet2",
                    "answerBy": "andy Liao",
                    "answerAt": "2018-12-12"
                  },
                  {
                    "answer": "请教一下大家新的个税政策出台后，工资该如何计算呢？commet1",
                    "answerBy": "byCommet1",
                    "answerAt": "2018-12-12"
                  },
                  {
                    "answer": "请教一下大家新的个税政策出台后，工资该如何计算呢？commet2",
                    "answerBy": "andy Liao",
                    "answerAt": "2018-12-12"
                  }
                ]
              }
            ]
          },
          {
            "title": "请教一下大家该怎么写兼职简历呢",
            "detail": "detail1",
            "viewers": "155",
            "votes": "234",
            "latestStatus": "Sandy He在3分钟前回答",
            "askedBy": "sandyHe1",
            "askedAt": "2019-01-01",
            "answers": [
              {
                "answer": "answer1",
                "answerBy": "answerBy1",
                "answerAt": "2018-12-12",
                "votes": "55",
                "commets": [
                  {
                    "answer": "commet1",
                    "answerBy": "answerByCommet1",
                    "answerAt": "2018-12-12"
                  }
                ]
              }
            ]
          },
          {
            "title": "请教一下大家新的个税政策出台后，工资该如何计算呢？",
            "detail": "detail1",
            "viewers": "155",
            "votes": "234",
            "latestStatus": "Sandy于3分钟前回答",
            "askedBy": "sandyHe2",
            "askedAt": "2019-01-01",
            "answers": [
              {
                "answer": "answer1",
                "answerBy": "answerBy1",
                "answerAt": "2018-12-12",
                "votes": "55",
                "commets": [
                  {
                    "answer": "commet1",
                    "answerBy": "answerByCommet1",
                    "answerAt": "2018-12-12"
                  }
                ]
              }
            ]
          },
          {
            "title": "请教一下大家新的个税政策出台后，工资该如何计算呢？",
            "detail": "detail1",
            "viewers": "155",
            "votes": "234",
            "latestStatus": "Sandy于3分钟前回答",
            "askedBy": "sandyHe3",
            "askedAt": "2019-01-01",
            "answers": [
              {
                "answer": "answer1",
                "answerBy": "answerBy1",
                "answerAt": "2018-12-12",
                "votes": "55",
                "commets": [
                  {
                    "answer": "commet1",
                    "answerBy": "answerByCommet1",
                    "answerAt": "2018-12-12"
                  }
                ]
              }
            ]
          },
          {
            "title": "请教一下大家新的个税政策出台后，工资该如何计算呢？",
            "detail": "detail1",
            "viewers": "155",
            "votes": "234",
            "latestStatus": "Sandy于3分钟前回答",
            "askedBy": "sandyHe4",
            "askedAt": "2019-01-01",
            "answers": [
              {
                "answer": "answer1",
                "answerBy": "answerBy1",
                "answerAt": "2018-12-12",
                "votes": "55",
                "commets": [
                  {
                    "answer": "commet1",
                    "answerBy": "answerByCommet1",
                    "answerAt": "2018-12-12"
                  }
                ]
              }
            ]
          },
          {
            "title": "请教一下大家新的个税政策出台后，工资该如何计算呢？",
            "detail": "detail1",
            "viewers": "155",
            "votes": "234",
            "latestStatus": "Sandy于3分钟前回答",
            "askedBy": "sandyHe5",
            "askedAt": "2019-01-01",
            "answers": [
              {
                "answer": "answer1",
                "answerBy": "answerBy1",
                "answerAt": "2018-12-12",
                "votes": "55",
                "commets": [
                  {
                    "answer": "commet1",
                    "answerBy": "answerByCommet1",
                    "answerAt": "2018-12-12"
                  }
                ]
              }
            ]
          }
        ]
      }
  """;
  List<Post> posts = Post.fromJson(postsJson);
  List<Job> fullTime = [];
  List<Job> partTime = [];

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

    Dio().get("http://192.168.140.56:3000/api/jobs/jobsList")
      .then((Response response) {
        setState(() {
          fullTime = Job.fromJson(response.data['list']);
          partTime = Job.fromJson(response.data['list']);
        });
      })
     .catchError((e) => 499);
  }

  @override
  void dispose() {
    _controller.removeListener(onChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new TabBarView(
        children: <Widget>[
          new JobsTab(fullTime, '全职'),
          new JobsTab(partTime, '兼职/实习'),
          new MessageTab(posts, '交流'),
          mine
        ],
        controller: _controller,
      ),
      bottomNavigationBar: new Material(
        color: Colors.white,
        child: new TabBar(
          controller: _controller,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: new TextStyle(fontSize: _kTabTextSize),
          tabs: <IconTab>[
            new IconTab(
                icon: _currentIndex == INDEX_JOB
                    ? "assets/images/ic_main_tab_company_pre.png"
                    : "assets/images/ic_main_tab_company_nor.png",
                text: "全职",
                color: _currentIndex == INDEX_JOB
                    ? _kPrimaryColor
                    : Colors.grey[900]),
            new IconTab(
                icon: _currentIndex == INDEX_COMPANY
                    ? "assets/images/ic_main_tab_contacts_pre.png"
                    : "assets/images/ic_main_tab_contacts_nor.png",
                text: "兼职/实习",
                color: _currentIndex == INDEX_COMPANY
                    ? _kPrimaryColor
                    : Colors.grey[900]),
            new IconTab(
                icon: _currentIndex == INDEX_MESSAGE
                    ? "assets/images/ic_main_tab_find_pre.png"
                    : "assets/images/ic_main_tab_find_nor.png",
                text: "交流",
                color: _currentIndex == INDEX_MESSAGE
                    ? _kPrimaryColor
                    : Colors.grey[900]),
            new IconTab(
                icon: _currentIndex == INDEX_MINE
                    ? "assets/images/ic_main_tab_my_pre.png"
                    : "assets/images/ic_main_tab_my_nor.png",
                text: "我的",
                color: (_currentIndex == INDEX_MINE)
                    ? _kPrimaryColor
                    : Colors.grey[900]),
          ],
        ),
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
        primaryColor: _kPrimaryColor,
        accentColor: Colors.cyan[300],
      ),
      home: new BossApp()
  ));
}
