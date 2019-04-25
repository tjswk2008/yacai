import 'package:flutter/material.dart';
import 'package:flutter_app/app/item/joblist_item.dart';
import 'package:flutter_app/app/model/job.dart';
import 'package:flutter_app/app/view/job/job_detail.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' as Spinkit;
import 'package:flutter_app/app/model/constants.dart';
import 'package:flutter_app/app/component/dropdown_menu/dropdown_menu.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/bezier_hour_glass_header.dart';
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_app/app/recruit_view/invite.dart';
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

  String area = areaArr[0];
  String timeReq = timeReqArr[0];
  String academic = academicArr[0];
  String employee;
  String salary = salaryArr[0];
  String companyType;

  int index1 = 0,
      index2 = 0,
      index3 = 0,
      index4 = 0,
      index5 = 0;

  int currentPage = 1,
      totalPage = 1;

  int userId;

  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      return Api().login(prefs.getString('userName'), null);
    }).then((Response response) {
      userId = response.data['id'];
    });
    getJobList(1);
  }

  DropdownMenu buildDropdownMenu() {
    double factor = MediaQuery.of(context).size.width/750;

    return new DropdownMenu(
        maxMenuHeight: 80 * factor * 10,
        menus: [
          new DropdownMenuBuilder(
              builder: (BuildContext context) {
                return new DropdownListMenu(
                  selectedIndex: index1,
                  data: salaryArr,
                  itemBuilder: buildCheckItem,
                );
              },
              height: 80 * factor * salaryArr.length),
          new DropdownMenuBuilder(
              builder: (BuildContext context) {
                return new DropdownListMenu(
                  selectedIndex: index2,
                  data: areaArr,
                  itemBuilder: buildCheckItem,
                );
              },
              height: 80 * factor * areaArr.length),
          new DropdownMenuBuilder(
              builder: (BuildContext context) {
                return new DropdownListMenu(
                  selectedIndex: index4,
                  data: timeReqArr,
                  itemBuilder: buildCheckItem,
                );
              },
              height: 80 * factor * timeReqArr.length),
          new DropdownMenuBuilder(
            builder: (BuildContext context) {
              return new DropdownTreeMenu(
                selectedIndex: 0,
                subSelectedIndex: [0,0,0],
                itemExtent: 80*factor,
                subBackground: Colors.white,
                itemBuilder: (BuildContext context, dynamic data, bool selected, List<int> subIndexs) {
                  if (!selected) {
                    return new DecoratedBox(
                        decoration: new BoxDecoration(
                            border: new Border(
                                right: Divider.createBorderSide(context))),
                        child: new Padding(
                            padding: EdgeInsets.only(left: 15.0*factor),
                            child: new Row(
                              children: <Widget>[
                                new Text(data['title'], style: TextStyle(fontSize: 24*factor)),
                              ],
                            )));
                  }
                  return new DecoratedBox(
                    decoration: new BoxDecoration(
                      border: new Border(
                        top: Divider.createBorderSide(context),
                        bottom: Divider.createBorderSide(context)
                      )
                    ),
                    child: new Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: new Row(
                        children: <Widget>[
                          new Container(
                              color: Theme.of(context).primaryColor,
                              width: 5.0*factor,
                              height: 24.0*factor),
                          new Padding(
                              padding: EdgeInsets.only(left: 15.0*factor),
                              child: new Text(data['title'], style: TextStyle(fontSize: 24*factor))),
                        ],
                      )
                    )
                  );
                },
                subItemBuilder: (BuildContext context, dynamic data, bool selected, List<int> subIndexs) {
                  Color color = selected
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).textTheme.body1.color;

                  return new SizedBox(
                    height: 80*factor,
                    child: new Padding(
                      padding: EdgeInsets.all(26.0*factor),
                      child: new Text(
                        data,
                        style: new TextStyle(color: color, fontSize: 24*factor),
                      ),
                      
                    ),
                  );
                },
                getSubData: (dynamic data) {
                  return data['children'];
                },
                data: [
                  {'title': '学历要求', 'children': academicArr},
                  {'title': '公司规模', 'children': employeeArr},
                  {'title': '公司行业', 'children': companyTypeArr},
                ],
              );
            },
            height: 800.0*factor
          ),

        ]);
  }

  DropdownHeader buildDropdownHeader({DropdownMenuHeadTapCallback onTap}) {
    double factor = MediaQuery.of(context).size.width/750;
    return new DropdownHeader(
      onTap: onTap,
      height: 80*factor,
      titles: [salaryArr[index1], areaArr[index2], timeReqArr[index4], '更多'],
    );
  }

  Widget buildFixHeaderDropdownMenu() {
    double factor = MediaQuery.of(context).size.width/750;
    return new DefaultDropdownMenuController(
      onSelected: ({int menuIndex, int index, int subIndex, dynamic data}) {
        switch (menuIndex) {
          case 0:
            salary = data;
            break;
          case 1:
            area = data;
            break;
          case 2:
            timeReq = data;
            break;
          case 3:
            RegExp exp = new RegExp(r"不限");
            if(index == 0) {
              academic = data;
            } else if(index == 1) {
              employee = exp.hasMatch(data) ? null : data;
            } else {
              companyType = exp.hasMatch(data) ? null : data;
            }
            break;
          default:
            break;
        }
        getJobList(1);
      },
      child: new Column(
        children: <Widget>[
          buildDropdownHeader(),
          new Expanded(
            child: new Stack(
              children: <Widget>[
                (_jobs.length != 0) ? new Padding(
                  padding: EdgeInsets.only(
                    top: 15.0*factor
                  ),
                  child: EasyRefresh(
                    refreshHeader:BezierHourGlassHeader(
                      key: _headerKey,
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    refreshFooter: BezierBounceFooter(
                      key: _footerKey,
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    onRefresh: () {
                      getJobList(1);
                    },
                    loadMore: () async {
                      getJobList(currentPage);
                    },
                    child: new ListView.builder(
                      itemCount: _jobs.length,
                      itemBuilder: buildJobItem
                    )
                  )
                ) : Center(
                  child: Text('暂无记录', style: TextStyle(fontSize: 28*factor))
                ),
                buildDropdownMenu()
            ],
          ))
        ],
    ));
  }
  
  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: (widget._type == 4 || widget._type == 5 || widget._type == 6) ? new AppBar(
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
            child: Spinkit.SpinKitHourGlass(
              color: Theme.of(context).primaryColor,
              size: 50*factor,
              duration: Duration(milliseconds: 1800),
            ),
          )
        ]
      ) : (widget._type == 4 || widget._type == 5 || widget._type == 6) ? ((_jobs.length != 0) ? new Padding(
          padding: EdgeInsets.only(
            top: 15.0*factor
          ),
          child: new ListView.builder(
            itemCount: _jobs.length,
            itemBuilder: buildJobItem
          )
        ) : Center(
          child: Text('暂无记录', style: TextStyle(fontSize: 28*factor))
        )) : buildFixHeaderDropdownMenu() 
    );
  }

  Widget buildJobItem(BuildContext context, int index) {
    Job job = _jobs[index];

    var jobItem = new InkWell(
        onTap: () => widget._type != 6 ? navJobDetail(job) : navToInvitation(job.id),
        child: new JobListItem(job, false));

    return jobItem;
  }

  void getJobList(page) async {
    if(page > totalPage) {
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Api().getJobList(widget._type, prefs.getString('userName'), timeReq, academic, employee, salary, area, companyType, page)
      .then((Response response) {
        if (response.data['code'] == 1) {
          totalPage = response.data['total'] == 0 ? 1 : response.data['total'];
          if(totalPage != 1 && currentPage <= totalPage) {
            currentPage++;
          }
          setState(() {
            if (page == 1) {
              _jobs = [];
              _jobs = Job.fromJson(response.data['list']);
            } else {
              Job.fromJson(response.data['list']).forEach((item) {
                _jobs.add(item);
              });
            }
          });
        }
        setState(() {
            isRequesting = false;
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

  navToInvitation(int jobId) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new Invite(jobId, userId);
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