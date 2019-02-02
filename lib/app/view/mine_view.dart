import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/app/view/login_view.dart';
import 'package:flutter_app/app/view/resume/resume_detail.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_app/actions/actions.dart';
import 'package:flutter_app/app/model/app.dart';

class MineTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MineTabState();
}

class MineTabState extends State<MineTab> {

  final double _appBarHeight = 150.0;
  String userAvatar;
  String userName;
  String jobStatus;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      Set keys = prefs.getKeys();
      if (keys.length != 0) {
        setState(() {
          userAvatar = 'https://img.bosszhipin.com/beijin/mcs/useravatar/20171211/4d147d8bb3e2a3478e20b50ad614f4d02062e3aec7ce2519b427d24a3f300d68_s.jpg';
          userName = 'Kimi He';
          jobStatus = '在职-考虑机会';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, String>(
      converter: (store) => store.state.userName,
      builder: (context, userName) {
        return new Scaffold(
          backgroundColor: new Color.fromARGB(255, 242, 242, 245),
          body: new CustomScrollView(
            slivers: <Widget>[
              new SliverAppBar(
                expandedHeight: _appBarHeight,
                flexibleSpace: new FlexibleSpaceBar(
                  background: new Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      const DecoratedBox(
                        decoration: const BoxDecoration(
                          gradient: const LinearGradient(
                            begin: const Alignment(0.0, -1.0),
                            end: const Alignment(0.0, -0.4),
                            colors: const <Color>[
                              const Color(0x00000000), const Color(0x00000000)],
                          ),
                        ),
                      ),

                      new GestureDetector(
                        onTap: () {
                          if(userName != '') return;
                          _login();
                        },
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            new Padding(
                              padding: const EdgeInsets.only(
                                top: 20.0,
                                left: 30.0,
                                right: 20.0,
                              ),
                              child: userName == ''
                                ? new Image.asset(
                                    "assets/images/ic_avatar_default.png",
                                    width: 60.0,
                                  )
                                : new CircleAvatar(
                                  radius: 35.0,
                                  backgroundImage: new NetworkImage(userAvatar)
                                )
                            ),

                            new Row(
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    new Padding(
                                        padding: const EdgeInsets.only(
                                          top: 10.0,
                                          bottom: 10.0,
                                        ),
                                        child: new Text(
                                            userName == '' ? "点击头像登录" : userName,
                                            style: new TextStyle(
                                                color: Colors.white, fontSize: 18.0))
                                    ),
                                    new Text(
                                        userName == '' ? "" : jobStatus,
                                        style: new TextStyle(
                                            color: Colors.white, fontSize: 12.0)
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),

              new SliverList(
                  delegate: new SliverChildListDelegate(<Widget>[
                    new InkWell(
                      onTap: _navToResumeDetail,
                      child: new Container(
                        height: 45.0,
                        margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        decoration: new BoxDecoration(
                          color: Colors.white,
                        ),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: new Row(
                                children: <Widget>[
                                  new Icon(
                                    IconData(0xe24d, fontFamily: 'MaterialIcons', matchTextDirection: true)
                                  ),
                                  new Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                  ),
                                  new Text('我的简历'),
                                ],
                              ),
                            ),
                            new Icon(
                              IconData(0xe5cc, fontFamily: 'MaterialIcons', matchTextDirection: true)
                            ),
                          ],
                        ),
                      )
                    ),

                    new Container(
                      color: Colors.white,
                      child: new Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            new _ContactItem(
                              onPressed: () {
                                showDialog(context: context, child: new AlertDialog(
                                    content: new Text(
                                      "沟通过",
                                      style: new TextStyle(fontSize: 20.0),
                                    )));
                              },
                              count: '590',
                              title: '沟通过',
                            ),
                            new _ContactItem(
                              onPressed: () {
                                showDialog(context: context, child: new AlertDialog(
                                    content: new Text(
                                      "已沟通",
                                      style: new TextStyle(fontSize: 20.0),
                                    )));
                              },
                              count: '71',
                              title: '已沟通',
                            ),
                            new _ContactItem(
                              onPressed: () {
                                showDialog(context: context, child: new AlertDialog(
                                    content: new Text(
                                      "已沟通",
                                      style: new TextStyle(fontSize: 20.0),
                                    )));
                              },
                              count: '0',
                              title: '待面试',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ])
              )
            ],
          ),
        );
      },
    );
  }

  _login() {
    Navigator
      .of(context)
      .push(new MaterialPageRoute(builder: (context) {
        return new NewLoginPage();
      }))
      .then((result) {
        // result为"refresh"代表登录成功
        if (result != null) {
          setState(() {
            userAvatar = 'https://img.bosszhipin.com/beijin/mcs/useravatar/20171211/4d147d8bb3e2a3478e20b50ad614f4d02062e3aec7ce2519b427d24a3f300d68_s.jpg';
            userName = 'Kimi He';
            jobStatus = '在职-考虑机会';
          });
        }
      });
  }

  _navToResumeDetail() {
    List<CompanyExperience> companyExperiences = new List<CompanyExperience>();
    companyExperiences.add(new CompanyExperience(
      cname: '阿里巴巴', // 公司名称
      industry: '电商', // 行业
      startTime: '2014-07', // 该单位的工作开始时间
      endTime: '至今', // 该单位的工作结束时间
      jobTitle: '会计', // 职位名称
      detail: '各项活动财务核算', // 工作内容
      performance: '使用excel函数加快核算流程', // 业绩
    ));

    List<Project> projects = new List<Project>();
    projects.add(new Project(
      name: '聚划算账务处理', // 项目名称
      role: '会计', // 角色
      startTime: '2014-07', // 该项目的开始时间
      endTime: '至今', // 该项目的结束时间
      detail: '聚划算账务处理', // 项目描述
      performance: '使用excel函数加快核算流程', // 业绩
    ));

    List<Education> educations = new List<Education>();
    educations.add(new Education(
      name: '上海财大', // 学校名称
      academic: '大学本科', // 学历
      major: '会计', // 专业
      endTime: '2014-07', // 就读该学校的结束时间
      startTime: '2010-09', // 就读该学校的开始时间
      detail: '曾任学生会主席，品学兼优',
    ));

    List<Certification> certificates = new List<Certification>();
    certificates.add(new Certification(
      name: '注册会计师', // 证书名
      industry: '国家财务局', // 颁发单位
      qualifiedTime: '2015-10', // 取得时间
      code: 'A156861315348743135X', // 证书编号
    ));

    Resume resume = new Resume(
      personalInfo: new PersonalInfo(
        name: 'Andy', // 姓名
        gender: '男', // 性别
        firstJobTime: '2007.07', // 首次参加工作时间
        avatar: 'https://img.bosszhipin.com/beijin/mcs/useravatar/20171211/4d147d8bb3e2a3478e20b50ad614f4d02062e3aec7ce2519b427d24a3f300d68_s.jpg', // 头像
        wechatId: 'tjswk2008', // 微信号
        birthDay: '1986.01', // 出生年月
        academic: '本科', // 学历
        summarize: '超强的学习力，有规划，为人nice', // 优势
      ), // 个人信息
      jobStatus: '在职-考虑机会',
      jobExpect: new JobExpect(
        jobTitle: '架构师', // 职位
        industry: '电子商务, 新零售, 互联网', // 行业
        city: '上海', // 工作城市
        salary: '35k-40k', // 薪资待遇
      ),
      companyExperiences: companyExperiences,
      projects: projects, // 发布人
      educations: educations, // 发布人
      certificates: certificates, // 证书列表
    );
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new ResumeDetail(resume);
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return new FadeTransition(
            opacity: animation,
            child: new SlideTransition(position: new Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(animation), child: child),
          );
        }
    ));
  }
}

class _ContactItem extends StatelessWidget {
  _ContactItem({ Key key, this.count, this.title, this.onPressed })
      : super(key: key);

  final String count;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        onTap: onPressed,
        child: new Column(
          children: [
            new Padding(
              padding: const EdgeInsets.only(
                bottom: 10.0,
              ),
              child: new Text(count, style: new TextStyle(
                  fontSize: 22.0)),
            ),
            new Text(title),
          ],
        )
    );
  }
}
