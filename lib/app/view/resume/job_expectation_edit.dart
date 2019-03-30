import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:flutter_app/app/component/common_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:flutter_app/actions/actions.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/app/model/app.dart';
import 'package:flutter_app/app/model/constants.dart';
import 'package:flutter_app/app/component/city.dart';
import 'package:custom_radio/custom_radio.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
     _jobExpect = widget._jobExpect; 
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

  Widget salaryOption(BuildContext context, int index) {
    double factor = MediaQuery.of(context).size.width/750;
    return new InkWell(
      onTap: () {
        setState(() {
          _jobExpect.salary =  salaryArr[index];
        });
      },
      child: new Container(
        height: 40*factor,
        width: 140*factor,
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.all(new Radius.circular(6*factor)),
          border: _jobExpect.salary == salaryArr[index] ? new Border.all(
            color: const Color(0xffaaaaaa),
            width: 2*factor
          ) : Border(),
        ),
        child: new Center(
          child: new Text(salaryArr[index], style: TextStyle(fontSize: 22.0*factor),),
        ),
      ),
    );
  }

  Widget companyTypeOption(BuildContext context, int index) {
    double factor = MediaQuery.of(context).size.width/750;
    return new InkWell(
      onTap: () {
        setState(() {
          _jobExpect.industry =  companyTypeArr[index];
        });
      },
      child: new Container(
        height: 40*factor,
        width: 140*factor,
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.all(new Radius.circular(6*factor)),
          border: _jobExpect.industry == companyTypeArr[index] ? new Border.all(
            color: const Color(0xffaaaaaa),
            width: 2*factor
          ) : Border(),
        ),
        child: new Center(
          child: new Text(companyTypeArr[index], style: TextStyle(fontSize: 22.0*factor),),
        ),
      ),
    );
  }

  Widget titleOption(BuildContext context, int index) {
    double factor = MediaQuery.of(context).size.width/750;
    return new InkWell(
      onTap: () {
        setState(() {
          _jobExpect.jobTitle =  titleArr[index];
        });
      },
      child: new Container(
        height: 40*factor,
        width: 220*factor,
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.all(new Radius.circular(6*factor)),
          border: _jobExpect.jobTitle == titleArr[index] ? new Border.all(
            color: const Color(0xffaaaaaa),
            width: 2*factor
          ) : Border(),
        ),
        child: new Center(
          child: new Text(titleArr[index], style: TextStyle(fontSize: 22.0*factor),),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
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
                Navigator.maybePop(context);
              }
            ),
            title: new Text('工作期望',
                style: new TextStyle(fontSize: 30.0*factor, color: Colors.white)),
          ),
          body: new SingleChildScrollView(
            child: new Padding(
              padding: EdgeInsets.all(10.0*factor),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Padding(
                    padding: EdgeInsets.only(bottom: 10.0*factor),
                    child: new Text(
                      '期望职位：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 24.0*factor),
                    ),
                  ),
                  new Container(
                    height: 60*factor,
                    child: new ListView.builder(
                      shrinkWrap: true,
                      itemCount: titleArr.length,
                      itemBuilder: titleOption,
                      scrollDirection: Axis.horizontal,
                      physics: const ClampingScrollPhysics(),
                    ),
                  ),
                  Container(height: 10*factor,),
                  Divider(),
                  new Padding(
                    padding: EdgeInsets.only(bottom: 10.0*factor),
                    child: new Text(
                      '期望行业：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 24.0*factor),
                    ),
                  ),
                  new Container(
                    height: 60*factor,
                    child: new ListView.builder(
                      shrinkWrap: true,
                      itemCount: companyTypeArr.length,
                      itemBuilder: companyTypeOption,
                      scrollDirection: Axis.horizontal,
                      physics: const ClampingScrollPhysics(),
                    ),
                  ),
                  new Container(
                    height: 10*factor,
                  ),
                  new Divider(),
                  new Padding(
                    padding: EdgeInsets.only(bottom: 10.0*factor),
                    child: new Text(
                      '工作城市：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 24.0*factor),
                    ),
                  ),
                  new Padding(
                    padding: EdgeInsets.only(left: 15*factor),
                    child: new InkWell(
                      onTap: () {
                        CityPicker.showCityPicker(
                          context,
                          selectProvince: (prov) {
                            
                          },
                          selectCity: (res) {
                            setState(() {
                              _jobExpect.city = res['name'];
                            });
                          },
                          selectArea: (res) {
                          },
                        );
                      },
                      child: Text('${_jobExpect.city}', style: TextStyle(fontSize: 22.0*factor, color: Colors.grey),),
                    ),
                  ),
                  new Container(
                    height: 10*factor,
                  ),
                  new Divider(),
                  new Padding(
                    padding: EdgeInsets.only(bottom: 10.0*factor),
                    child: new Text(
                      '工作类型：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 26.0*factor),
                    ),
                  ),
                  
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          CustomRadio<int, dynamic>(
                            value: 1,
                            groupValue: _jobExpect.type,
                            animsBuilder: (AnimationController controller) => [
                              CurvedAnimation(
                                parent: controller,
                                curve: Curves.easeInOut
                              ),
                              ColorTween(
                                begin: Colors.grey[600],
                                end: Colors.cyan[300]
                              ).animate(controller),
                              ColorTween(
                                begin: Colors.cyan[300],
                                end: Colors.grey[600]
                              ).animate(controller),
                            ],
                            builder: (BuildContext context, List<dynamic> animValues, Function updateState, int value) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _jobExpect.type = value;
                                  });
                                },
                                child: Container(
                                  width: 24.0*factor,
                                  height: 24.0*factor,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(10.0*factor),
                                  padding: EdgeInsets.all(3.0*factor),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: _jobExpect.type == value ? Colors.cyan[300] : Colors.grey[600],
                                      width: 1.0*factor
                                    )
                                  ),
                                  child: _jobExpect.type == value ? Container(
                                    width: 14.0*factor,
                                    height: 14.0*factor,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: animValues[1],
                                      border: Border.all(
                                        color: animValues[2],
                                        width: 1.0*factor
                                      )
                                    ),
                                  ) : Container(),
                                )
                              );
                            },
                          ),
                          new Text('全职', style: new TextStyle(fontSize: 24.0*factor),),
                        ]
                      ),
                      new Row(
                        children: <Widget>[
                          CustomRadio<int, dynamic>(
                            value: 2,
                            groupValue: _jobExpect.type,
                            animsBuilder: (AnimationController controller) => [
                              CurvedAnimation(
                                parent: controller,
                                curve: Curves.easeInOut
                              ),
                              ColorTween(
                                begin: Colors.grey[600],
                                end: Colors.cyan[300]
                              ).animate(controller),
                              ColorTween(
                                begin: Colors.cyan[300],
                                end: Colors.grey[600]
                              ).animate(controller),
                            ],
                            builder: (BuildContext context, List<dynamic> animValues, Function updateState, int value) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _jobExpect.type = value;
                                  });
                                },
                                child: Container(
                                  width: 24.0*factor,
                                  height: 24.0*factor,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(10.0*factor),
                                  padding: EdgeInsets.all(3.0*factor),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: _jobExpect.type == value ? Colors.cyan[300] : Colors.grey[600],
                                      width: 1.0*factor
                                    )
                                  ),
                                  child: _jobExpect.type == value ? Container(
                                    width: 14.0*factor,
                                    height: 14.0*factor,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: animValues[1],
                                      border: Border.all(
                                        color: animValues[2],
                                        width: 1.0*factor
                                      )
                                    ),
                                  ) : Container(),
                                )
                              );
                            },
                          ),
                          new Text('兼职', style: new TextStyle(fontSize: 24.0*factor),),
                        ]
                      ),
                      new Row(
                        children: <Widget>[
                          CustomRadio<int, dynamic>(
                            value: 3,
                            groupValue: _jobExpect.type,
                            animsBuilder: (AnimationController controller) => [
                              CurvedAnimation(
                                parent: controller,
                                curve: Curves.easeInOut
                              ),
                              ColorTween(
                                begin: Colors.grey[600],
                                end: Colors.cyan[300]
                              ).animate(controller),
                              ColorTween(
                                begin: Colors.cyan[300],
                                end: Colors.grey[600]
                              ).animate(controller),
                            ],
                            builder: (BuildContext context, List<dynamic> animValues, Function updateState, int value) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _jobExpect.type = value;
                                  });
                                },
                                child: Container(
                                  width: 24.0*factor,
                                  height: 24.0*factor,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(10.0*factor),
                                  padding: EdgeInsets.all(3.0*factor),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: _jobExpect.type == value ? Colors.cyan[300] : Colors.grey[600],
                                      width: 1.0*factor
                                    )
                                  ),
                                  child: _jobExpect.type == value ? Container(
                                    width: 14.0*factor,
                                    height: 14.0*factor,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: animValues[1],
                                      border: Border.all(
                                        color: animValues[2],
                                        width: 1.0*factor
                                      )
                                    ),
                                  ) : Container(),
                                )
                              );
                            },
                          ),
                          new Text('实习', style: new TextStyle(fontSize: 24.0*factor),),
                        ],
                      )
                    ],
                  ),
                  new Divider(),
                  new Padding(
                    padding: EdgeInsets.only(bottom: 10.0*factor),
                    child: new Text(
                      '薪资要求：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 24.0*factor),
                    ),
                  ),
                  new Container(
                    height: 60*factor,
                    child: new ListView.builder(
                      shrinkWrap: true,
                      itemCount: salaryArr.length,
                      itemBuilder: salaryOption,
                      scrollDirection: Axis.horizontal,
                      physics: const ClampingScrollPhysics(),
                    ),
                  ),
                  new Container(
                    height: 10*factor,
                  ),
                  Divider(),
                  new Builder(builder: (ctx) {
                    return new CommonButton(
                      text: "保存",
                      color: new Color.fromARGB(255, 0, 215, 198),
                      onTap: () {
                        if (isRequesting) return;
                        setState(() {
                          isRequesting = true;
                        });
                        // 发送给webview，让webview登录后再取回token
                        Api().saveJobExpectation(
                          _jobExpect.jobTitle,
                          _jobExpect.industry,
                          _jobExpect.city,
                          _jobExpect.salary,
                          _jobExpect.type,
                          userName
                        )
                          .then((Response response) {
                            setState(() {
                              isRequesting = false;
                            });
                            if(response.data['code'] != 1) {
                              Scaffold.of(ctx).showSnackBar(new SnackBar(
                                content: new Text("保存失败！"),
                              ));
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
                      }
                    );
                  })
                ],
              ),
            )
          )
        );
      }
    );
  }
}