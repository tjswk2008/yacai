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
  String userName = '';

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      if (!mounted) {
        return;
      }
      setState(() {
        userName = prefs.getString('userName');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return new Scaffold(
          backgroundColor: new Color.fromARGB(255, 242, 242, 245),
          appBar: new AppBar(
            elevation: 0.0,
            title: new Text(widget._title,
                style: new TextStyle(fontSize: 30.0*factor, color: Colors.white)),
          ),
          body: userName == '' ? new Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text("您还未登陆，请先前往登陆查看", style: TextStyle(fontSize: 24*factor),),
              new InkWell(
                onTap: _login,
                child: new Container(
                  margin: EdgeInsets.all(50.0*factor),
                  height: 60.0*factor,
                  decoration: new BoxDecoration(
                    border: new Border.all(color: const Color(0xffcccccc), width: factor),
                    borderRadius: new BorderRadius.all(new Radius.circular(6.0*factor))
                  ),
                  child: new Center(
                    child: new Text("前往登陆", style: new TextStyle(color: Colors.black, fontSize: 22.0*factor),),
                  ),
                ),
              )
            ],
          ) : state.jobs != null && state.jobs.length != 0 ? new Stack(
            children: <Widget>[
              ListView.builder(
                itemCount: state.jobs.length,
                itemBuilder: buildJobItem
              ),
              Positioned(
                bottom: 20*factor,
                right: 20*factor,
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.orange[400],
                  child: Icon(
                    Icons.add,
                    size: 50.0*factor,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(new PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (BuildContext context, _, __) {
                        return new PubJob();
                      },
                      transitionsBuilder: _pageAnimation
                    )).then((result) {
                      if(result == null) return;
                      getJobList();
                    });
                  },
                ),
              )
            ]
          ) : Stack(
            children: <Widget>[
              Center(
                child: Text('暂无记录', style: TextStyle(fontSize: 28*factor),)
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new Padding(
                    padding: EdgeInsets.only(top: 25.0*factor, right: 25.0*factor),
                    child: Container(
                      height: 60*factor,
                      width: 175*factor,
                      child: RaisedButton(
                        color: Colors.orange[400],
                        child: Text("发布职位", style: new TextStyle(fontSize: 26.0*factor, color: Colors.white),),
                        onPressed: () {
                          Navigator.of(context).push(new PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (BuildContext context, _, __) {
                              return new PubJob();
                            },
                            transitionsBuilder: _pageAnimation
                          )).then((result) {
                            if(result == null) return;
                            getJobList();
                          });
                        },
                      ),
                    )
                  )
                ],
              ),
            ],
          )
        );
      }
    );
  }

  Widget buildJobItem(BuildContext context, int index) {
    Job job = StoreProvider.of<AppState>(context).state.jobs[index];

    var jobItem = new InkWell(
        onTap: () => navJobDetail(job),
        child: new JobListItem(job, false));

    return jobItem;
  }

  Widget _pageAnimation(_, Animation<double> animation, __, Widget child) {
    return new FadeTransition(
      opacity: animation,
      child: new SlideTransition(position: new Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(animation), child: child),
    );
  }

  void getJobList() async {
    if (userName == null) return;
    Api().getRecruitJobList(userName)
      .then((Response response) {
        if(response.data['code'] != 1) {
          Scaffold.of(context).showSnackBar(new SnackBar(
            content: new Text("获取列表失败，请稍后重试~"),
          ));
          return;
        }
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
        transitionsBuilder: _pageAnimation
    ));
  }

  _login() {
    Navigator
      .of(context)
      .push(new MaterialPageRoute(builder: (context) {
        return new NewLoginPage();
      }));
  }
}
