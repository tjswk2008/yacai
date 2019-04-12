import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/company.dart';
import 'package:flutter_app/app/model/job.dart';
import 'package:flutter_app/app/view/company/company_info.dart';
import 'package:flutter_app/app/view/job/job_base.dart';
import 'package:flutter_app/app/view/job/job_desc.dart';
import 'package:flutter_app/app/view/job/job_addr.dart';
import 'package:flutter_app/app/view/company/company_detail.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

class JobDetail extends StatefulWidget {
  final Job _job;

  JobDetail(this._job);

  @override
  JobDetailState createState() => new JobDetailState();
}

class JobDetailState extends State<JobDetail>
    with TickerProviderStateMixin {

  VoidCallback onChanged;
  Company _company;
  int role;
  bool isRequesting = false;
  String userName = '';
  Job _job;

  @override
  void initState() {
    super.initState();
    setState(() {
      _job = widget._job;
    });
    getCompanyDetail();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return new Scaffold(
      backgroundColor: Colors.white,
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
        title: new Text("职位详情",
            style: new TextStyle(fontSize: 30.0*factor, color: Colors.white)),
      ),
      body: new Stack(
        children: <Widget>[
          new SingleChildScrollView(
              child: new Column(
                children: <Widget>[
                  new Container(
                    color: Colors.white,
                    child: new Column(
                      children: <Widget>[
                        new JobBase(_job),
                        new Divider(),
                        new JobDesc(_job),
                        new Divider(),
                        new JobAddr(_job),
                        new Divider(),
                        new InkWell(
                            onTap: () => navCompanyDetail(_company),
                            child: _company == null ? new Container() : new CompanyInfo(_company)
                        ),
                        Container(
                          height: 20*factor,
                        ),
                        role == 1 ? Padding(
                          padding: EdgeInsets.all(20.0*factor),
                          child: new Builder(builder: (ctx) {
                            return new FlatButton(
                              child: new Container(
                                height: 70*factor,
                                child: new Center(
                                  child: Text(
                                    _job.favorite ? "取消收藏" : "收藏",
                                    style: TextStyle(
                                      color: _job.favorite ? Colors.black : Colors.white,
                                      fontSize: 28.0*factor,
                                      letterSpacing: _job.favorite ? 5*factor : 40*factor
                                    ),
                                  ),
                                ),
                              ),
                              color: _job.favorite ? Colors.grey[300] : Colors.orange[400],
                              onPressed: () async {
                                if (isRequesting) return;
                                setState(() {
                                  isRequesting = true;
                                });
                                // 发送给webview，让webview登录后再取回token
                                Api().favorite(
                                  userName,
                                  _job.id,
                                  _job.favorite
                                )
                                  .then((Response response) {
                                    setState(() {
                                      isRequesting = false;
                                    });
                                    if(response.data['code'] != 1) {
                                      Scaffold.of(ctx).showSnackBar(new SnackBar(
                                        content: new Text("收藏失败！"),
                                      ));
                                      return;
                                    } else {
                                      setState(() {
                                        _job.favorite = !_job.favorite;
                                      });
                                    }
                                  })
                                  .catchError((e) {
                                    setState(() {
                                      isRequesting = false;
                                    });
                                    print(e);
                                  });
                              }
                            );
                          }),
                        ) : Container(),
                        role == 1 ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0*factor),
                          child: new Builder(builder: (ctx) {
                            return new FlatButton(
                              child: new Container(
                                height: 70*factor,
                                child: new Center(
                                  child: Text(
                                    _job.delivered ? "已投递" : "投递",
                                    style: TextStyle(
                                      color: _job.delivered ? Colors.black : Colors.white,
                                      fontSize: 28.0*factor,
                                      letterSpacing: _job.delivered ? 5*factor : 40*factor
                                    ),
                                  ),
                                ),
                              ),
                              color: _job.delivered ? Colors.grey[300] : new Color.fromARGB(255, 0, 215, 198),
                              onPressed: () async {
                                if (isRequesting || _job.delivered) return;
                                setState(() {
                                  isRequesting = true;
                                });
                                // 发送给webview，让webview登录后再取回token
                                Api().deliver(
                                  userName,
                                  _job.id
                                )
                                  .then((Response response) {
                                    setState(() {
                                      isRequesting = false;
                                    });
                                    if(response.data['code'] != 1) {
                                      Scaffold.of(ctx).showSnackBar(new SnackBar(
                                        content: new Text("投递失败！"),
                                      ));
                                      return;
                                    } else {
                                      setState(() {
                                        _job.delivered = !_job.delivered;
                                      });
                                    }
                                  })
                                  .catchError((e) {
                                    setState(() {
                                      isRequesting = false;
                                    });
                                    print(e);
                                  });
                              }
                            );
                          }),
                        ) : Container()
                      ],
                    ),
                  ),
                ],
              )
          ),

        ],
      )
    );
  }

  getCompanyDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getInt('role');
      userName = prefs.getString('userName');
    });
    Api().getCompanyDetail(widget._job.companyId, prefs.getString('userName'))
      .then((Response response) {
        setState(() {
          _company = Company.fromMap(response.data['data']);
        });
      })
     .catchError((e) {
       print(e);
     });
  }

  navCompanyDetail(Company company) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new CompanyDetail(company);
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