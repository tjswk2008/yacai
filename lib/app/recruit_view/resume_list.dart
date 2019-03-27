import 'package:flutter/material.dart';
import 'package:flutter_app/app/item/userlist_item.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:developer';

class ResumeTab extends StatefulWidget {
  final String _title;
  final int jobId;

  ResumeTab(this._title, this.jobId);
  @override
  ResumeTabState createState() => new ResumeTabState();
}

class ResumeTabState extends State<ResumeTab> {
  List<PersonalInfo> _originalPersonalInfos = [];
  List<PersonalInfo> _personalInfos = [];

  @override
  void initState() {
    super.initState();
    getResumeList();
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
        title: new Text(widget._title,
          style: new TextStyle(fontSize: 30.0*factor, color: Colors.white)
        ),
        actions: <Widget>[
          new PopupMenuButton(
            onSelected: (int value){
               setState(() {
                 if(value == 0) {
                   _personalInfos = _originalPersonalInfos;
                 } else {
                   _personalInfos = [];
                  for (var i = 0; i < _originalPersonalInfos.length; i++) {
                    PersonalInfo element = _originalPersonalInfos[i];
                    if(element.mark == value) {
                      _personalInfos.add(element);
                    }
                  }
                 }
               });
            },
            itemBuilder: (BuildContext context) =><PopupMenuItem<int>>[
              new PopupMenuItem(
                  value: 0,
                  child: new Text("全部", style: TextStyle(fontSize: 22*factor),)
              ),
              new PopupMenuItem(
                value: 1,
                  child: new Text("有意向", style: TextStyle(fontSize: 22*factor),)
              ),
              new PopupMenuItem(
                value: 2,
                  child: new Text("已电联", style: TextStyle(fontSize: 22*factor),)
              )
            ]
          )
        ],
      ),
      body: _personalInfos.length != 0 ? new ListView.builder(
          itemCount: _personalInfos.length, itemBuilder: buildResumeItem) : Center(
            child: Text('暂无投递记录', style: TextStyle(fontSize: 28*factor),),
          ),
    );
  }

  Widget buildResumeItem(BuildContext context, int index) {
    PersonalInfo personalInfo = _personalInfos[index];

    return UserListItem(personalInfo);
  }

  void getResumeList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Api().getResumeList(prefs.getString('userName'), widget.jobId)
      .then((Response response) {
        setState(() {
          _originalPersonalInfos = PersonalInfo.fromList(response.data['list']);
          _personalInfos = PersonalInfo.fromList(response.data['list']);
        });
      })
     .catchError((e) {
       print(e);
     });
  }
}
