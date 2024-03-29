import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:flutter_app/actions/actions.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/app/model/app.dart';
import 'package:flutter_app/app/model/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/app/component/select.dart';
import 'package:flutter_app/util/util.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

class JobExpectationEdit extends StatefulWidget {

  final JobExpect _jobExpect;

  JobExpectationEdit(this._jobExpect);

  @override
  JobExpectationEditState createState() => new JobExpectationEditState();
}

class JobExpectationEditState extends State<JobExpectationEdit>
    with TickerProviderStateMixin {

  VoidCallback onChanged;
  JobExpect _jobExpect;
  bool isRequesting = false;
  String userName = '';

  @override
  void initState() {
    super.initState();
    setState(() {
     _jobExpect = JobExpect.copy(widget._jobExpect); 
    });
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

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    YaCaiUtil.getInstance().init(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return new Scaffold(
          backgroundColor: Colors.white,
          appBar: new AppBar(
            elevation: 0.0,
            leading: IconButton(
              icon: const BackButtonIcon(),
              iconSize: 40*factor,
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: () {
                _jobExpect = null;
                Navigator.maybePop(context);
              }
            ),
            title: new Text('工作期望',
                style: new TextStyle(fontSize: 30.0*factor, color: Colors.white)),
          ),
          body: new Stack(
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.all(50.0*factor),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Padding(
                          padding: EdgeInsets.only(top: 30.0*factor, bottom: 30.0*factor),
                          child: new Text(
                            '期望职位：',
                            textAlign: TextAlign.left,
                            style: new TextStyle(fontSize: 28.0*factor),
                          ),
                        ),
                        new Padding(
                          padding: EdgeInsets.only(
                            top: 30.0*factor,
                            bottom: 30.0*factor,
                            left: 10.0*factor,
                            right: 20.0*factor
                          ),
                          child: new InkWell(
                            onTap: () {
                              // _showJobStatus(context);
                              YCPicker.showYCPicker(
                                context,
                                selectItem: (res) {
                                  setState(() {
                                    _jobExpect.jobTitle =  res;
                                  });
                                },
                                data: titleArr,
                              );
                            },
                            child: new Text(_jobExpect.jobTitle == null ? '请选择' : _jobExpect.jobTitle, style: TextStyle(fontSize: 26.0*factor),),
                          ) 
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Padding(
                          padding: EdgeInsets.only(top: 30.0*factor, bottom: 30.0*factor),
                          child: new Text(
                            '期望行业：',
                            textAlign: TextAlign.left,
                            style: new TextStyle(fontSize: 28.0*factor),
                          ),
                        ),
                        new Padding(
                          padding: EdgeInsets.only(
                            top: 20.0*factor,
                            bottom: 20.0*factor,
                            left: 10.0*factor,
                            right: 20.0*factor
                          ),
                          child: new InkWell(
                            onTap: () {
                              // _showJobStatus(context);
                              YCPicker.showYCPicker(
                                context,
                                selectItem: (res) {
                                  setState(() {
                                    _jobExpect.industry =  res;
                                  });
                                },
                                data: companyTypeArr,
                              );
                            },
                            child: new Text(_jobExpect.industry == null ? '请选择' : _jobExpect.industry, style: TextStyle(fontSize: 26.0*factor),),
                          ) 
                        ),
                      ],
                    ),
                    new Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Padding(
                          padding: EdgeInsets.symmetric(vertical: 30.0*factor),
                          child: new Text(
                            '工作类型：',
                            textAlign: TextAlign.left,
                            style: new TextStyle(fontSize: 28.0*factor),
                          ),
                        ),
                        new Padding(
                          padding: EdgeInsets.only(top: 16.0*factor, bottom: 16*factor, right: 20*factor),
                          child: new InkWell(
                            onTap: () {
                              YCPicker.showYCPicker(
                                context,
                                selectItem: (res) {
                                  setState(() {
                                    _jobExpect.type = jobTypeArr.indexOf(res) + 1;
                                  });
                                },
                                data: jobTypeArr,
                              );
                            },
                            child: new Text(_jobExpect.type == null ? '请选择' : jobTypeArr[_jobExpect.type - 1], style: TextStyle(fontSize: 26.0*factor),),
                          )
                        ),
                      ],
                    ),
                    new Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Padding(
                          padding: EdgeInsets.only(top: 30.0*factor, bottom: 30.0*factor),
                          child: new Text(
                            '薪资要求：',
                            textAlign: TextAlign.left,
                            style: new TextStyle(fontSize: 28.0*factor),
                          ),
                        ),
                        new Padding(
                          padding: EdgeInsets.only(
                            top: 20.0*factor,
                            bottom: 20.0*factor,
                            left: 10.0*factor,
                            right: 20.0*factor
                          ),
                          child: new InkWell(
                            onTap: () {
                              // _showJobStatus(context);
                              YCPicker.showYCPicker(
                                context,
                                selectItem: (res) {
                                  setState(() {
                                    _jobExpect.salary =  res;
                                  });
                                },
                                data: salaryArr,
                              );
                            },
                            child: new Text(_jobExpect.salary == null ? '请选择' : _jobExpect.salary, style: TextStyle(fontSize: 26.0*factor),),
                          ) 
                        ),
                      ],
                    ),
                    new Container(
                      height: 10*factor,
                    ),
                    Divider()
                  ],
                ),
              ),
              Positioned(
                bottom: 40*factor,
                right: 50*factor,
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(
                    Icons.check,
                    size: 50.0*factor,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (isRequesting) return;
                    setState(() {
                      isRequesting = true;
                    });
                    // 发送给webview，让webview登录后再取回token
                    Api().saveJobExpectation(
                      _jobExpect.jobTitle,
                      _jobExpect.industry,
                      '上海市',
                      _jobExpect.salary,
                      _jobExpect.type,
                      userName
                    )
                      .then((Response response) {
                        setState(() {
                          isRequesting = false;
                        });
                        if(response.data['code'] != 1) {
                          YaCaiUtil.getInstance().showMsg("保存失败~");
                          return;
                        }
                        Resume resume = state.resume;
                        resume.jobExpect = _jobExpect;
                        StoreProvider.of<AppState>(context).dispatch(SetResumeAction(resume));
                        Navigator.pop(context);
                      })
                      .catchError((e) {
                        setState(() {
                          isRequesting = false;
                        });
                        print(e);
                      });
                  },
                ),
              )
            ]
          )
        );
      }
    );
  }
}