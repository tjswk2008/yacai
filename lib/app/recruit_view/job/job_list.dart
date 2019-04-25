import 'package:flutter/material.dart';
import 'package:flutter_app/app/item/joblist_item.dart';
import 'package:flutter_app/app/model/job.dart';
import 'package:flutter_app/app/model/app.dart';
import 'package:flutter_app/app/recruit_view/resume_list.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:dio/dio.dart';

class PubJobList extends StatefulWidget {
  PubJobList();

  @override
  PubJobListState createState() => new PubJobListState();
}

class PubJobListState extends State<PubJobList> {
  String userName;
  List<Job> _jobs = [];

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
      getJobList();
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
            leading: IconButton(
              icon: const BackButtonIcon(),
              iconSize: 40*factor,
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: () {
                Navigator.maybePop(context);
              }
            ),
            title: Text(
              '投递记录',
              style: TextStyle(fontSize: 30.0*factor, color: Colors.white)
            )
          ),
          body: _jobs != null && _jobs.length != 0 ? new ListView.builder(
            itemCount: _jobs.length,
            itemBuilder: buildJobItem
          ) : Center(
            child: Text('暂无投递记录', style: TextStyle(fontSize: 28*factor),),
          )
        );
      }
    );
  }

  Widget buildJobItem(BuildContext context, int index) {
    Job job = _jobs[index];

    var jobItem = new InkWell(
        onTap: () => navToResumeList(job),
        child: new JobListItem(job, true));

    return jobItem;
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
        setState(() {
          _jobs = Job.fromJson(response.data['list']);
        });
      })
     .catchError((e) {
       print(e);
     });
  }

  navToResumeList(Job job) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new ResumeTab('简历投递列表', job.id, 3);
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
