import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_app/app/model/constants.dart';
import 'package:flutter_app/app/view/resume/resume_preview.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/app/component/select.dart';

const List<String> MARKERS = [
  '-请选择-',
  '有意向',
  '已电联',
];

class UserListItem extends StatefulWidget {
  final PersonalInfo personalInfo;
  final int jobId;

  UserListItem(this.personalInfo, this.jobId);
  @override
  UserListItemState createState() => new UserListItemState();
}

class UserListItemState extends State<UserListItem> {
  PersonalInfo personalInfo;
  bool isRequesting = false;
  String userName;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      personalInfo = widget.personalInfo;
    });
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      setState(() {
        userName = prefs.getString('userName');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return new Padding(
      padding: EdgeInsets.only(
        top: 10.0*factor,
        left: 10.0*factor,
        right: 10.0*factor,
        bottom: 10.0*factor,
      ),

      child: new Card(
        elevation: 2,
        child: new Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new InkWell(
                onTap: () => navResumePreview(personalInfo.id),
                child: new Padding(
                  padding: EdgeInsets.only(
                    top: 20.0*factor,
                    left: 20.0*factor,
                    right: 10.0*factor,
                    bottom: 15.0*factor,
                  ),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 10*factor),
                                child: Text(
                                  personalInfo.name,
                                  style: new TextStyle(fontSize: 26.0*factor)
                                ),
                              ),
                              
                              widget.jobId == null ? Container() : personalInfo.accepted == 2 ? Text("(已拒绝邀请)", style: new TextStyle(fontSize: 24.0*factor, color: Colors.red))
                                : personalInfo.accepted == 1 ? Text("(已接受邀请)", style: new TextStyle(fontSize: 24.0*factor, color: Colors.green))
                                : Container()
                            ],
                          ),
                          new Row(
                            children: <Widget>[
                              new Padding(
                                padding: EdgeInsets.only(
                                  top: 15.0*factor,
                                  right: 10.0*factor,
                                ),
                                child: new Text(
                                  personalInfo.gender,
                                  textAlign: TextAlign.left,
                                  style: new TextStyle(
                                      fontSize: 22.0*factor, color: Colors.grey),
                                )
                              ),
                              new Padding(
                                padding: EdgeInsets.only(
                                  top: 15.0*factor,
                                  right: 10.0*factor,
                                ),
                                child: new Text(
                                  yearsOffset(personalInfo.birthDay).toString() + "岁",
                                  style: new TextStyle(fontSize: 22.0*factor, color: Colors.red)
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      personalInfo.avatar == null ? new Image.asset(
                        "assets/images/ic_avatar_default.png",
                        width: 90.0*factor,
                      ) : new CircleAvatar(
                        radius: 45.0*factor,
                        backgroundImage: new NetworkImage(personalInfo.avatar)
                      )
                    ],
                  ),
                ),
            ),
            
            new Divider(),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.only(
                        top: 10.0*factor,
                        left: 20.0*factor,
                        right: 10.0*factor,
                        bottom: 15.0*factor,
                      ),
                      child: new Text(yearsOffset(personalInfo.firstJobTime).toString() + "年经验",
                          style: new TextStyle(fontSize: 22*factor, color: new Color.fromARGB(
                              255, 0, 215, 198))),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(
                        top: 10.0*factor,
                        bottom: 15.0*factor,
                      ),
                      child: new Text(personalInfo.academic != null ? academicArr[personalInfo.academic + 1] : '', style: new TextStyle(fontSize: 22*factor))
                    ),
                    personalInfo.school != null ? new Padding(
                      padding: EdgeInsets.only(
                        top: 10.0*factor,
                        right: 10.0*factor,
                        bottom: 15.0*factor,
                      ),
                      child: new Text('(${personalInfo.school})', style: new TextStyle(fontSize: 22*factor))
                    ) : Container(),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 10*factor),
                      child: Text('标记为:', style: TextStyle(fontSize: 22*factor),),
                    ),
                    InkWell(
                      child: Text(personalInfo.mark == null ? MARKERS[0] : MARKERS[personalInfo.mark], style: TextStyle(fontSize: 22*factor),),
                      onTap: () {
                        YCPicker.showYCPicker(
                          context,
                          selectItem: (res) async {
                            setState(() {
                              personalInfo.mark = MARKERS.indexOf(res);
                            });
                            if (isRequesting) return;
                            setState(() {
                              isRequesting = true;
                            });
                            // 发送给webview，让webview登录后再取回token
                            try {
                              await Api().mark(userName, personalInfo.id, MARKERS.indexOf(res));
                              setState(() {
                                isRequesting = false;
                              });
                            } catch (e) {
                              setState(() {
                                isRequesting = false;
                              });
                              print(e);
                            }
                          },
                          data: MARKERS,
                        );
                      },
                    ),
                    Container(width: 20*factor,)
                  ]
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  navResumePreview(int userId) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new ResumePreview(userId, widget.jobId);
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

  static int yearsOffset(String dateTime) {
    DateTime now = DateTime.parse(formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]));
    int v = now.millisecondsSinceEpoch - DateTime.parse(dateTime).millisecondsSinceEpoch;
    if (v < 0) v = -v;
    return v ~/ (86400000 * 30 * 12);
  }
}
//You can use any Widget
class MySelectionItem extends StatelessWidget {
  final String title;
  final bool isForList;

  const MySelectionItem({this.title, this.isForList = true});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      child: isForList
          ? Padding(
              child: _buildItem(context),
              padding: EdgeInsets.all(10.0),
            )
          : Card(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: Stack(
                children: <Widget>[
                  _buildItem(context),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.arrow_drop_down),
                  )
                ],
              ),
            ),
    );
  }

  _buildItem(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Text(title),
    );
  }
}
