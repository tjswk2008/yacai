import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/app/view/login_view.dart';

class MineTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MineTabState();
}

class MineTabState extends State<MineTab> {

  final double _appBarHeight = 150.0;
  String userAvatar;
  String userName;
  String jobStatus;

  onTap() {
    SharedPreferences.getInstance().then((prefs) {
      Set keys = prefs.getKeys();
      if (keys.length == 0) {
        Navigator
          .of(context)
          .push(new MaterialPageRoute(builder: (context) {
            return new NewLoginPage();
          }))
          .then((result) {
            // result为"refresh"代表登录成功
            if (result != null && result == "refresh") {
              setState(() {
                userAvatar = 'https://img.bosszhipin.com/beijin/mcs/useravatar/20171211/4d147d8bb3e2a3478e20b50ad614f4d02062e3aec7ce2519b427d24a3f300d68_s.jpg';
                userName = 'Kimi He';
                jobStatus = '在职-考虑机会';
                // 更新用户信息
              });
            }
          });
      } else {
        // 显示登陆信息
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    onTap: onTap,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        new Padding(
                          padding: const EdgeInsets.only(
                            top: 20.0,
                            left: 30.0,
                            right: 20.0,
                          ),
                          child: userAvatar == null
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
                                        userName == null ? "点击头像登录" : userName,
                                        style: new TextStyle(
                                            color: Colors.white, fontSize: 18.0))
                                ),
                                new Text(
                                    jobStatus == null ? "" : jobStatus,
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
