import 'package:flutter/material.dart';
import 'package:flutter_app/app/item/userlist_item.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:flutter_app/app/view/resume/resume_preview.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
// import 'dart:developer';

class ResumeTab extends StatefulWidget {
  final String _title;

  ResumeTab(this._title);
  @override
  ResumeTabState createState() => new ResumeTabState();
}

class ResumeTabState extends State<ResumeTab> {
  List<PersonalInfo> _personalInfos = [];

  @override
  void initState() {
    super.initState();
    getResumeList();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: new Color.fromARGB(255, 242, 242, 245),
      appBar: new AppBar(
        elevation: 0.0,
        title: new Text(widget._title,
            style: new TextStyle(fontSize: 20.0, color: Colors.white)),
      ),
      body: new ListView.builder(
          itemCount: _personalInfos.length, itemBuilder: buildResumeItem),
    );
  }

  Widget buildResumeItem(BuildContext context, int index) {
    PersonalInfo personalInfo = _personalInfos[index];

    return new InkWell(
        onTap: () => navResumePreview(personalInfo.id),
        child: new UserListItem(personalInfo)
    );
  }

  void getResumeList() {
    Api().getResumeList()
      .then((Response response) {
        setState(() {
          _personalInfos = PersonalInfo.fromList(response.data['list']);
        });
      })
     .catchError((e) {
       print(e);
     });
  }

  navResumePreview(int userId) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new ResumePreview(userId);
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
