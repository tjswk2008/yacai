import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/app/model/app.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_app/app/component/common_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:flutter_app/actions/actions.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

class CompanyExperienceEditView extends StatefulWidget {

  final CompanyExperience _companyExperience;

  CompanyExperienceEditView(this._companyExperience);

  @override
  CompanyExperienceEditViewState createState() => new CompanyExperienceEditViewState();
}

class CompanyExperienceEditViewState extends State<CompanyExperienceEditView>
    with TickerProviderStateMixin {

  CompanyExperience _companyExperience;
  bool isRequesting = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _companyExperience = widget._companyExperience;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return new Scaffold(
          backgroundColor: Colors.white,
          appBar: new AppBar(
            elevation: 0.0,
            title: new Text('工作经历',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
          ),
          body: new SingleChildScrollView(
            child: new Padding(
              padding: const EdgeInsets.all(10.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: new Text(
                      '公司名：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 18.0),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: new TextField(
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                          text: _companyExperience.cname,
                          selection: TextSelection.fromPosition(
                            TextPosition(
                              affinity: TextAffinity.downstream,
                              offset: _companyExperience.cname.length
                            )
                          )
                        )
                      ),
                      onChanged: (val) {
                        setState(() {
                          _companyExperience.cname = val;
                        });
                      },
                      decoration: new InputDecoration(
                        hintText: "请输入公司名",
                        hintStyle: new TextStyle(
                            color: const Color(0xFF808080)
                        ),
                        border: new UnderlineInputBorder(),
                        contentPadding: const EdgeInsets.all(10.0)
                      ),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: new Text(
                      '职位名称：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 18.0),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: new TextField(
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                          text: _companyExperience.jobTitle,
                          selection: TextSelection.fromPosition(
                            TextPosition(
                              affinity: TextAffinity.downstream,
                              offset: _companyExperience.jobTitle.length
                            )
                          )
                        )
                      ),
                      onChanged: (val) {
                        setState(() {
                          _companyExperience.jobTitle = val;
                        });
                      },
                      decoration: new InputDecoration(
                        hintText: "请输入职位名称",
                        hintStyle: new TextStyle(
                            color: const Color(0xFF808080)
                        ),
                        border: new UnderlineInputBorder(),
                        contentPadding: const EdgeInsets.all(10.0)
                      ),
                    ),
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Text(
                        '开始时间：',
                        textAlign: TextAlign.left,
                        style: new TextStyle(fontSize: 18.0),
                      ),

                      new InkWell(
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.parse(_companyExperience.startTime),
                            firstDate: DateTime.parse('1900-01-01'), // 减 30 天
                            lastDate: new DateTime.now(),       // 加 30 天
                          ).then((DateTime val) {
                            setState(() {
                              _companyExperience.startTime = formatDate(val, [yyyy, '-', mm, '-', dd]);
                            });
                          }).catchError((err) {
                            print(err);
                          });
                        },
                        child: new Text(_companyExperience.startTime),
                      )
                    ],
                  ),
                  new Divider(),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Text(
                        '结束时间：',
                        textAlign: TextAlign.left,
                        style: new TextStyle(fontSize: 18.0),
                      ),

                      new InkWell(
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.parse(
                              _companyExperience.endTime == null ? formatDate(new DateTime.now(), [yyyy, '-', mm, '-', dd]) : _companyExperience.endTime
                            ),
                            firstDate: DateTime.parse('1900-01-01'), // 减 30 天
                            lastDate: new DateTime.now(),       // 加 30 天
                          ).then((DateTime val) {
                            setState(() {
                              String currentDate = formatDate(new DateTime.now(), [yyyy, '-', mm, '-', dd]);
                              if (formatDate(val, [yyyy, '-', mm, '-', dd]) == currentDate) {
                                _companyExperience.endTime = null;
                              } else {
                                _companyExperience.endTime = formatDate(val, [yyyy, '-', mm, '-', dd]);
                              }
                            });
                          }).catchError((err) {
                            print(err);
                          });
                        },
                        child: new Text(_companyExperience.endTime == null ? '至今' : _companyExperience.endTime),
                      )
                    ],
                  ),
                  new Divider(),
                  new Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: new Text(
                      '工作内容：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 18.0),
                    ),
                  ),
                  new TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    controller: TextEditingController.fromValue(
                      TextEditingValue(
                        text: _companyExperience.detail,
                        selection: TextSelection.fromPosition(
                          TextPosition(
                            affinity: TextAffinity.downstream,
                            offset: _companyExperience.detail.length
                          )
                        )
                      )
                    ),
                    onChanged: (val) {
                      setState(() {
                        _companyExperience.detail = val;
                      });
                    },
                    decoration: new InputDecoration(
                      hintText: "请输入您的工作内容",
                      hintStyle: new TextStyle(
                          color: const Color(0xFF808080)
                      ),
                      border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(const Radius.circular(6.0))
                      ),
                      contentPadding: const EdgeInsets.all(10.0)
                    ),
                  ),
                  new Divider(),
                  new Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: new Text(
                      '工作业绩：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 18.0),
                    ),
                  ),
                  new TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    controller: TextEditingController.fromValue(
                      TextEditingValue(
                        text: _companyExperience.performance == null ? '' : _companyExperience.performance,
                        selection: TextSelection.fromPosition(
                          TextPosition(
                            affinity: TextAffinity.downstream,
                            offset: _companyExperience.performance.length
                          )
                        )
                      )
                    ),
                    onChanged: (val) {
                      setState(() {
                        _companyExperience.performance = val;
                      });
                    },
                    decoration: new InputDecoration(
                      hintText: "请输入您的工作业绩",
                      hintStyle: new TextStyle(
                          color: const Color(0xFF808080)
                      ),
                      border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(const Radius.circular(6.0))
                      ),
                      contentPadding: const EdgeInsets.all(10.0)
                    ),
                  ),
                  new Divider(),
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
                        Api().saveCompanyExperience(
                          _companyExperience.cname,
                          _companyExperience.jobTitle,
                          _companyExperience.startTime,
                          _companyExperience.endTime,
                          _companyExperience.detail,
                          _companyExperience.performance,
                          state.userName,
                          _companyExperience.id,
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
                            if(_companyExperience.id == null) {
                              resume.companyExperiences.add(CompanyExperience.fromMap(response.data['info']));
                              StoreProvider.of<AppState>(context).dispatch(SetResumeAction(resume));
                            } else {
                              for (var i = 0; i < resume.companyExperiences.length; i++) {
                                if(resume.companyExperiences[i].id == _companyExperience.id) {
                                  resume.companyExperiences[i] = _companyExperience;
                                  break;
                                }
                              }
                              StoreProvider.of<AppState>(context).dispatch(SetResumeAction(resume));
                            }
                            Navigator.pop(context, response.data['info']);
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