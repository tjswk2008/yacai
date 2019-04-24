import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:flutter_app/actions/actions.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/app/model/app.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_app/app/model/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/app/component/select.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

class ProjectEditView extends StatefulWidget {

  final Project _project;

  ProjectEditView(this._project);

  @override
  ProjectEditViewState createState() => new ProjectEditViewState();
}

class ProjectEditViewState extends State<ProjectEditView>
    with TickerProviderStateMixin {

  VoidCallback onChanged;
  Project _project;
  bool isRequesting = false;
  String userName = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      _project = widget._project;
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
            title: new Text('项目经历',
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
                      '项目名：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 24.0*factor),
                    ),
                  ),
                  new Padding(
                    padding: EdgeInsets.only(bottom: 16.0*factor),
                    child: new TextField(
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                          text: _project.name,
                          selection: TextSelection.fromPosition(
                            TextPosition(
                              affinity: TextAffinity.downstream,
                              offset: _project.name.length
                            )
                          )
                        )
                      ),
                      style: TextStyle(fontSize: 20.0*factor),
                      onChanged: (val) {
                        setState(() {
                          _project.name = val;
                        });
                      },
                      decoration: new InputDecoration(
                        hintText: "请输入项目名",
                        hintStyle: new TextStyle(
                            color: const Color(0xFF808080),
                            fontSize: 20.0*factor
                        ),
                        border: new UnderlineInputBorder(
                          borderSide: BorderSide(width: 1.0*factor)
                        ),
                        contentPadding: EdgeInsets.all(10.0*factor)
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Padding(
                        padding: EdgeInsets.only(top: 20.0*factor, bottom: 10.0*factor),
                        child: new Text(
                          '角色名称：',
                          textAlign: TextAlign.left,
                          style: new TextStyle(fontSize: 24.0*factor),
                        ),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(
                          top: 20.0*factor,
                          bottom: 10.0*factor,
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
                                  _project.role =  res;
                                });
                              },
                              data: titleArr,
                            );
                          },
                          child: new Text(_project.role == null || _project.role == '' ? '请选择' : _project.role, style: TextStyle(fontSize: 22.0*factor),),
                        ) 
                      ),
                    ],
                  ),
                  Container(height: 10*factor,),
                  Divider(),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10*factor, bottom: 10*factor),
                        child: new Text(
                          '开始时间：',
                          textAlign: TextAlign.left,
                          style: new TextStyle(fontSize: 24.0*factor),
                        ),
                      ),

                      new InkWell(
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.parse(_project.startTime),
                            firstDate: DateTime.parse('1900-01-01'), // 减 30 天
                            lastDate: new DateTime.now(),       // 加 30 天
                          ).then((DateTime val) {
                            setState(() {
                              _project.startTime = formatDate(val, [yyyy, '-', mm, '-', dd]);
                            });
                          }).catchError((err) {
                            print(err);
                          });
                        },
                        child: new Text(_project.startTime, style: TextStyle(fontSize: 24.0*factor),),
                      )
                    ],
                  ),
                  new Divider(),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10*factor, bottom: 10*factor),
                        child: new Text(
                          '结束时间：',
                          textAlign: TextAlign.left,
                          style: new TextStyle(fontSize: 24.0*factor),
                        ),
                      ),

                      new InkWell(
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.parse(
                              _project.endTime == null ? formatDate(new DateTime.now(), [yyyy, '-', mm, '-', dd]) : _project.endTime
                            ),
                            firstDate: DateTime.parse('1900-01-01'), // 减 30 天
                            lastDate: new DateTime.now(),       // 加 30 天
                          ).then((DateTime val) {
                            setState(() {
                              String currentDate = formatDate(new DateTime.now(), [yyyy, '-', mm, '-', dd]);
                              if (formatDate(val, [yyyy, '-', mm, '-', dd]) == currentDate) {
                                _project.endTime = null;
                              } else {
                                _project.endTime = formatDate(val, [yyyy, '-', mm, '-', dd]);
                              }
                            });
                          }).catchError((err) {
                            print(err);
                          });
                        },
                        child: new Text(_project.endTime == null ? '至今' : _project.endTime, style: new TextStyle(fontSize: 24.0*factor),),
                      )
                    ],
                  ),
                  new Divider(),
                  new Padding(
                    padding: EdgeInsets.only(bottom: 20.0*factor),
                    child: new Text(
                      '项目描述：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 24.0*factor),
                    ),
                  ),
                  new TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    style: new TextStyle(fontSize: 20.0*factor),
                    controller: TextEditingController.fromValue(
                      TextEditingValue(
                        text: _project.detail,
                        selection: TextSelection.fromPosition(
                          TextPosition(
                            affinity: TextAffinity.downstream,
                            offset: _project.detail.length
                          )
                        )
                      )
                    ),
                    onChanged: (val) {
                      setState(() {
                        _project.detail = val;
                      });
                    },
                    decoration: new InputDecoration(
                      hintText: "请输入项目描述",
                      hintStyle: new TextStyle(
                          color: const Color(0xFF808080),
                          fontSize: 20.0*factor
                      ),
                      border: new OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6.0*factor))
                      ),
                      contentPadding: EdgeInsets.all(15.0*factor)
                    ),
                  ),
                  new Divider(),
                  new Padding(
                    padding: EdgeInsets.only(bottom: 20.0*factor),
                    child: new Text(
                      '项目业绩：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 24.0*factor),
                    ),
                  ),
                  new TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    controller: TextEditingController.fromValue(
                      TextEditingValue(
                        text: _project.performance == null ? '' : _project.performance,
                        selection: TextSelection.fromPosition(
                          TextPosition(
                            affinity: TextAffinity.downstream,
                            offset: _project.performance.length
                          )
                        )
                      )
                    ),
                    onChanged: (val) {
                      setState(() {
                        _project.performance = val;
                      });
                    },
                    style: TextStyle(fontSize: 20.0*factor),
                    decoration: new InputDecoration(
                      hintText: "请输入您的项目业绩",
                      hintStyle: new TextStyle(
                          color: const Color(0xFF808080),
                          fontSize: 20.0*factor
                      ),
                      border: new OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6.0*factor))
                      ),
                      contentPadding: EdgeInsets.all(15.0*factor)
                    ),
                  ),
                  Container(
                    height: 50*factor,
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton(
                        child: new Container(
                          width: 200*factor,
                          height: 70*factor,
                          child: new Center(
                            child: Text(
                              "删除",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28.0*factor,
                                letterSpacing: 40*factor
                              ),
                            ),
                          ),
                        ),
                        color: Colors.orange,
                        onPressed: () {
                          if (isRequesting) return;
                          showDialog<Null>(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return new AlertDialog(
                                content: Text("确认要删除么？", style: TextStyle(fontSize: 28*factor),),
                                actions: <Widget>[
                                  new FlatButton(
                                    child: new Text('确定', style: TextStyle(fontSize: 24*factor, color: Colors.orange),),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        isRequesting = true;
                                      });
                                      // 发送给webview，让webview登录后再取回token
                                      Api().deleteProject(_project.id)
                                        .then((Response response) {
                                          setState(() {
                                            isRequesting = false;
                                          });
                                          if(response.data['code'] != 1) {
                                            Scaffold.of(context).showSnackBar(new SnackBar(
                                              content: new Text("删除失败！"),
                                            ));
                                            return;
                                          }
                                          Resume resume = state.resume;
                                          resume.projects.removeWhere((Project project) => project.id == _project.id);
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
                                  new FlatButton(
                                    child: new Text('取消', style: TextStyle(fontSize: 24*factor),),
                                    onPressed: () {
                                        Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      ),
                      FlatButton(
                        child: new Container(
                          width: 200*factor,
                          height: 70*factor,
                          child: new Center(
                            child: Text(
                              "保存",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28.0*factor,
                                letterSpacing: 40*factor
                              ),
                            ),
                          ),
                        ),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          if (isRequesting) return;
                          setState(() {
                            isRequesting = true;
                          });
                          // 发送给webview，让webview登录后再取回token
                          Api().saveProject(
                            _project.name,
                            _project.role,
                            _project.startTime,
                            _project.endTime,
                            _project.detail,
                            _project.performance,
                            userName,
                            _project.id,
                          )
                            .then((Response response) {
                              setState(() {
                                isRequesting = false;
                              });
                              if(response.data['code'] != 1) {
                                Scaffold.of(context).showSnackBar(new SnackBar(
                                  content: new Text("保存失败！"),
                                ));
                                return;
                              }
                              Resume resume = state.resume;
                              if(_project.id == null) {
                                resume.projects.add(Project.fromMap(response.data['info']));
                                StoreProvider.of<AppState>(context).dispatch(SetResumeAction(resume));
                              } else {
                                for (var i = 0; i < resume.projects.length; i++) {
                                  if(resume.projects[i].id == _project.id) {
                                    resume.projects[i] = _project;
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
                      ),
                    ]
                  )
                ],
              ),
            )
          )
        );
      }
    );
  }
}