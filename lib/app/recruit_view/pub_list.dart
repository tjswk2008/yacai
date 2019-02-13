import 'package:flutter/material.dart';
import 'package:flutter_app/app/view/login_view.dart';
import 'package:flutter_app/app/recruit_view/job/job_pub.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/app/model/app.dart';
import 'package:flutter_app/app/item/joblist_item.dart';
import 'package:flutter_app/app/model/job.dart';
import 'package:flutter_app/app/view/job/job_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/actions/actions.dart';
// import 'dart:developer';

class PubTab extends StatefulWidget {
  final String _title;

  PubTab(this._title);

  @override
  PubTabState createState() => new PubTabState();
}

class PubTabState extends State<PubTab> {
  List<Job> _jobs = [];

  @override
  void initState() {
    super.initState();
    getJobList();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return new Scaffold(
          backgroundColor: new Color.fromARGB(255, 242, 242, 245),
          appBar: new AppBar(
            elevation: 0.0,
            title: new Text(widget._title,
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
          ),
          body: state.userName == '' ? new Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text("您还未登陆，请先前往登陆查看"),
              new InkWell(
                onTap: _login,
                child: new Container(
                  margin: const EdgeInsets.all(50.0),
                  height: 45.0,
                  decoration: new BoxDecoration(
                    border: new Border.all(color: const Color(0xffcccccc)),
                    borderRadius: new BorderRadius.all(new Radius.circular(3.0))
                  ),
                  child: new Center(
                    child: new Text("前往登陆", style: new TextStyle(color: Colors.black, fontSize: 14.0),),
                  ),
                ),
              )
            ],
          ) : new SingleChildScrollView(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.only(top: 5.0, right: 10.0),
                      child: RaisedButton(
                        color: Colors.orange[400],
                        child: Text("发布职位", style: new TextStyle(fontSize: 16.0, color: Colors.white),),
                        onPressed: () {
                          Navigator.of(context).push(new PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (BuildContext context, _, __) {
                              return new PubJob();
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
                          )).then((result) {
                            if(result == null) return;
                            getJobList();
                          });
                        },
                      ),
                    )
                  ],
                ),
                new ListView.builder(
                  shrinkWrap: true,
                  physics: new NeverScrollableScrollPhysics(),
                  itemCount: state.jobs.length,
                  itemBuilder: buildJobItem
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget buildJobItem(BuildContext context, int index) {
    Job job = StoreProvider.of<AppState>(context).state.jobs[index];

    var jobItem = new InkWell(
        onTap: () => navJobDetail(job),
        child: new JobListItem(job));

    return jobItem;
  }

  void getJobList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userName = prefs.getString('userName');
    if (userName == null) return;
    Api().getRecruitJobList(userName)
      .then((Response response) {
        _jobs = Job.fromJson(response.data['list']);
        StoreProvider.of<AppState>(context).dispatch(SetJobsAction(_jobs));
      })
     .catchError((e) {
       print(e);
     });
  }

  navJobDetail(Job job) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new JobDetail(job);
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

  _login() {
    Navigator
      .of(context)
      .push(new MaterialPageRoute(builder: (context) {
        return new NewLoginPage();
      }))
      .then((result) {
        if(result == null) return;
        getJobList();
      });
  }
}
