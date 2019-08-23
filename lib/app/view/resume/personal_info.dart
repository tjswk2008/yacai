import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:flutter_app/app/model/constants.dart';
import 'package:flutter_app/app/view/resume/personal_info_edit.dart';
import 'package:date_format/date_format.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PersonalInfoView extends StatefulWidget {

  final PersonalInfo personalInfo;
  final bool _editable;
  final bool _canBeViewed;

  PersonalInfoView(this.personalInfo, this._editable, this._canBeViewed);

  @override
  PersonalInfoViewState createState() => new PersonalInfoViewState();
}

class PersonalInfoViewState extends State<PersonalInfoView>
    with TickerProviderStateMixin {

  String userName;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      setState(() {
        userName = prefs.getString('userName');
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  static int yearsOffset(String dateTime) {
    DateTime now = DateTime.parse(formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]));
    int v = now.millisecondsSinceEpoch - DateTime.parse(dateTime).millisecondsSinceEpoch;
    if (v < 0) v = -v;
    return v ~/ (86400000 * 30 * 12);
  }

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return new Padding(
      padding: EdgeInsets.only(top: 30.0*factor),
      child: new InkWell(
        onTap: () {
          if(!widget._editable) return;
          Navigator.of(context).push(new PageRouteBuilder(
            opaque: false,
            pageBuilder: (BuildContext context, _, __) {
              return new PersonalInfoEditView(widget.personalInfo);
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
        },
        child: new Card(
          elevation: 0.0,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.0*factor,
            ),
            child: new Column(
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 20.0*factor, right: 20*factor),
                              child: new Text(
                                widget.personalInfo.name == null ? 
                                  '姓名' : widget._canBeViewed ? 
                                  widget.personalInfo.name : widget.personalInfo.name.length == 2 ? 
                                  widget.personalInfo.name.replaceRange(0, 1, '*') : '*' + widget.personalInfo.name.substring(1, 2) + '*' + widget.personalInfo.name.substring(3, widget.personalInfo.name.length),
                                textAlign: TextAlign.left,
                                style: new TextStyle(fontSize: 34.0*factor,fontWeight: FontWeight.bold, color: Colors.grey[800]),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 24.0*factor, right: 10*factor),
                              child: new Text(
                                widget.personalInfo.gender == null ? '' : '(${widget.personalInfo.gender})',
                                textAlign: TextAlign.left,
                                style: new TextStyle(fontSize: 26.0*factor),
                              ),
                            ),
                            widget._canBeViewed ? Padding(
                              padding: EdgeInsets.only(bottom: 20.0*factor),
                              child: new Text(
                                widget.personalInfo.account,
                                textAlign: TextAlign.left,
                                style: new TextStyle(fontSize: 26.0*factor),
                              ),
                            ) : Container(),
                          ],
                        ),
                        Container(height: 10*factor),
                        new Row(
                          children: <Widget>[
                            new Padding(
                              padding: EdgeInsets.only(right: 10.0*factor),
                              child: new Text(
                                widget.personalInfo.firstJobTime == null ? '首次参加工作时间' : yearsOffset(widget.personalInfo.firstJobTime).toString() + "年经验",
                                textAlign: TextAlign.left,
                                style: new TextStyle(fontSize: 24.0*factor),
                              ),
                            ),
                            new Padding(
                              padding: EdgeInsets.only(right: 10.0*factor),
                              child: Container(
                                height: 24*factor,
                                width: factor,
                                decoration: new BoxDecoration(
                                  border: new Border(left: BorderSide(width: factor, color: Colors.grey[800]))
                                ),
                              ),
                            ),
                            new Padding(
                              padding: EdgeInsets.only(right: 10.0*factor),
                              child: new Text(
                                widget.personalInfo.birthDay == null ? '出生年月' : yearsOffset(widget.personalInfo.birthDay).toString() + "岁",
                                textAlign: TextAlign.left,
                                style: new TextStyle(fontSize: 24.0*factor),
                              ),
                            ),
                            new Padding(
                              padding: EdgeInsets.only(right: 10.0*factor),
                              child: Container(
                                height: 24*factor,
                                width: factor,
                                decoration: new BoxDecoration(
                                  border: new Border(left: BorderSide(width: factor, color: Colors.grey[800]))
                                ),
                              ),
                            ),
                            new Text(
                              widget.personalInfo.academic != null ? academicArr[widget.personalInfo.academic + 1] : '',
                              textAlign: TextAlign.left,
                              style: new TextStyle(fontSize: 24.0*factor),
                            ),
                          ],
                        ),
                      ]
                    ),

                    widget.personalInfo.avatar == null ? new Image.asset(
                        "assets/images/avatar_default.png",
                        width: 120.0*factor,
                        color: Theme.of(context).primaryColor,
                      )
                    : new CircleAvatar(
                      radius: 60.0*factor,
                      backgroundImage: new NetworkImage(widget.personalInfo.avatar)
                    )
                  ],
                ),
                Container(height: 20*factor),
                new Divider(),
                
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.only(
                        top: 20.0*factor,
                        bottom: 10.0*factor,
                      ),
                      child: new Text(widget.personalInfo.summarize == null ? '优势' : widget.personalInfo.summarize, style: new TextStyle(
                          fontSize: 26.0*factor, color: Colors.grey[800])),
                    ),
                  ],
                ),

                Container(height: 30*factor,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}