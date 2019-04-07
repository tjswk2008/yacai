import 'package:flutter/material.dart';
import 'package:flutter_app/app/item/joblist_item.dart';
import 'package:flutter_app/app/model/job.dart';
import 'package:flutter_app/app/view/job/job_detail.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_app/app/model/constants.dart';
import 'package:flutter_app/app/component/select.dart';
// import 'dart:developer';

class JobsTab extends StatefulWidget {
  final int _type;
  final String _title;

  JobsTab(this._type, this._title);
  @override
  JobList createState() => new JobList();
}

class JobList extends State<JobsTab> {
  List<Job> _jobs = [];
  bool isRequesting = true;

  String timeReq = timeReqArr[0];
  String academic = academicArr[0];
  String employee = employeeArr[0];

  @override
  void initState() {
    super.initState();
    getJobList();
  }
  
  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return new Scaffold(
      backgroundColor: new Color.fromARGB(255, 242, 242, 245),
      appBar: (widget._type == 4 || widget._type == 5) ? new AppBar(
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
            style: new TextStyle(fontSize: 32.0*factor, color: Colors.white)),
      ) : new AppBar(
        elevation: 0.0,
        title: new Text(widget._title,
            style: new TextStyle(fontSize: 32.0*factor, color: Colors.white)),
      ),
      body: isRequesting ? new Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            top: 0,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Color.fromARGB(190, 0, 0, 0)
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SpinKitHourGlass(
              color: Theme.of(context).primaryColor,
              size: 50*factor,
              duration: Duration(milliseconds: 1800),
            ),
          )
        ]
      ) : SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 15*factor,
            ),
            Padding(
              padding: EdgeInsets.all(15*factor),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 20*factor),
                    child: InkWell(
                      onTap: () {
                        YCPicker.showYCPicker(
                          context,
                          selectItem: (low) {
                            setState(() {
                              timeReq = low;
                            });
                            getJobList();
                          },
                          data: timeReqArr
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(15*factor),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.all(new Radius.circular(6*factor)),
                        ),
                        child: Row(
                          children: <Widget>[
                            Text(timeReq, style: TextStyle(fontSize: 24.0*factor, color: Colors.grey),),
                            Padding(
                              padding: EdgeInsets.only(left: 10*factor),
                              child: Icon(Icons.arrow_drop_down, size: 40*factor)
                            )
                          ],
                        )
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 20*factor),
                    child: InkWell(
                      onTap: () {
                        YCPicker.showYCPicker(
                          context,
                          selectItem: (low) {
                            setState(() {
                              academic = low;
                            });
                            getJobList();
                          },
                          data: academicArr
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(15*factor),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.all(new Radius.circular(6*factor)),
                        ),
                        child: Row(
                          children: <Widget>[
                            Text(academic, style: TextStyle(fontSize: 24.0*factor, color: Colors.grey),),
                            Padding(
                              padding: EdgeInsets.only(left: 10*factor),
                              child: Icon(Icons.arrow_drop_down, size: 40*factor)
                            )
                          ],
                        )
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      YCPicker.showYCPicker(
                        context,
                        selectItem: (low) {
                          setState(() {
                            employee = low;
                          });
                          getJobList();
                        },
                        data: employeeArr
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(15*factor),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.all(new Radius.circular(6*factor)),
                      ),
                      child: Row(
                        children: <Widget>[
                          Text(employee, style: TextStyle(fontSize: 24.0*factor, color: Colors.grey),),
                          Padding(
                            padding: EdgeInsets.only(left: 10*factor),
                            child: Icon(Icons.arrow_drop_down, size: 40*factor)
                          )
                        ],
                      )
                    ),
                  )
                ],
              ),
            ),
            
            (_jobs.length != 0) ? new ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _jobs.length, itemBuilder: buildJobItem) : Center(
                child: Text('暂无记录', style: TextStyle(fontSize: 28*factor),),)
          ],
        )
      )
    );
  }

  Widget buildJobItem(BuildContext context, int index) {
    Job job = _jobs[index];

    var jobItem = new InkWell(
        onTap: () => navJobDetail(job),
        child: new JobListItem(job));

    return jobItem;
  }

  void getJobList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Api().getJobList(widget._type, prefs.getString('userName'), timeReq, academic, employee)
      .then((Response response) {
        setState(() {
          isRequesting = false;
          _jobs = Job.fromJson(response.data['list']);
        });
      })
     .catchError((e) {
       print(e);
       setState(() {
          isRequesting = false;
        });
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
}