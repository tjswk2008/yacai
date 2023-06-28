import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
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
import 'package:flutter_app/app/component/text_area.dart';

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
      _project = Project.copy(widget._project);
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
    double factor = MediaQuery.of(context).size.width / 750;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return new Scaffold(
              backgroundColor: Colors.white,
              appBar: new AppBar(
                elevation: 0.0,
                leading: IconButton(
                    icon: const BackButtonIcon(),
                    iconSize: 40 * factor,
                    tooltip:
                        MaterialLocalizations.of(context).backButtonTooltip,
                    onPressed: () {
                      _project = null;
                      Navigator.maybePop(context);
                    }),
                title: new Text('项目经历',
                    style: new TextStyle(
                        fontSize: 30.0 * factor, color: Colors.white)),
              ),
              body: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  new SingleChildScrollView(
                      child: new Padding(
                    padding: EdgeInsets.all(50.0 * factor),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Padding(
                          padding: EdgeInsets.only(bottom: 30.0 * factor),
                          child: new Text(
                            '项目名：',
                            textAlign: TextAlign.left,
                            style: new TextStyle(fontSize: 28.0 * factor),
                          ),
                        ),
                        new Padding(
                          padding: EdgeInsets.only(bottom: 4.0 * factor),
                          child: new TextField(
                            controller: TextEditingController.fromValue(
                                TextEditingValue(
                                    text: _project.name,
                                    selection: TextSelection.fromPosition(
                                        TextPosition(
                                            affinity: TextAffinity.downstream,
                                            offset: _project.name.length)))),
                            style: TextStyle(fontSize: 26.0 * factor),
                            onChanged: (val) {
                              setState(() {
                                _project.name = val;
                              });
                            },
                            decoration: new InputDecoration(
                                hintText: "请输入项目名",
                                hintStyle: new TextStyle(
                                    color: const Color(0xFF808080),
                                    fontSize: 26.0 * factor),
                                border: prefix0.InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                  top: 20.0 * factor,
                                  bottom: 20.0 * factor,
                                )),
                          ),
                        ),
                        prefix0.Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Padding(
                              padding: EdgeInsets.only(
                                  top: 40.0 * factor, bottom: 20.0 * factor),
                              child: new Text(
                                '角色名称：',
                                textAlign: TextAlign.left,
                                style: new TextStyle(fontSize: 28.0 * factor),
                              ),
                            ),
                            new Padding(
                                padding: EdgeInsets.only(
                                    top: 20.0 * factor,
                                    bottom: 10.0 * factor,
                                    left: 10.0 * factor,
                                    right: 20.0 * factor),
                                child: new InkWell(
                                  onTap: () {
                                    // _showJobStatus(context);
                                    YCPicker.showYCPicker(
                                      context,
                                      selectItem: (res) {
                                        setState(() {
                                          _project.role = res;
                                        });
                                      },
                                      data: titleArr,
                                    );
                                  },
                                  child: new Text(
                                    _project.role == null || _project.role == ''
                                        ? '请选择'
                                        : _project.role,
                                    style: TextStyle(fontSize: 26.0 * factor),
                                  ),
                                )),
                          ],
                        ),
                        Container(
                          height: 10 * factor,
                        ),
                        Divider(),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 30 * factor, bottom: 30 * factor),
                              child: new Text(
                                '开始时间：',
                                textAlign: TextAlign.left,
                                style: new TextStyle(fontSize: 28.0 * factor),
                              ),
                            ),
                            new InkWell(
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate:
                                      DateTime.parse(_project.startTime),
                                  firstDate:
                                      DateTime.parse('1900-01-01'), // 减 30 天
                                  lastDate: new DateTime.now(), // 加 30 天
                                ).then((DateTime val) {
                                  setState(() {
                                    _project.startTime = formatDate(
                                        val, [yyyy, '-', mm, '-', dd]);
                                  });
                                }).catchError((err) {
                                  print(err);
                                });
                              },
                              child: new Text(
                                _project.startTime,
                                style: TextStyle(fontSize: 26.0 * factor),
                              ),
                            )
                          ],
                        ),
                        new Divider(),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 30 * factor, bottom: 30 * factor),
                              child: new Text(
                                '结束时间：',
                                textAlign: TextAlign.left,
                                style: new TextStyle(fontSize: 28.0 * factor),
                              ),
                            ),
                            new InkWell(
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.parse(
                                      _project.endTime == null
                                          ? formatDate(new DateTime.now(),
                                              [yyyy, '-', mm, '-', dd])
                                          : _project.endTime),
                                  firstDate:
                                      DateTime.parse('1900-01-01'), // 减 30 天
                                  lastDate: new DateTime.now(), // 加 30 天
                                ).then((DateTime val) {
                                  setState(() {
                                    String currentDate = formatDate(
                                        new DateTime.now(),
                                        [yyyy, '-', mm, '-', dd]);
                                    if (formatDate(
                                            val, [yyyy, '-', mm, '-', dd]) ==
                                        currentDate) {
                                      _project.endTime = null;
                                    } else {
                                      _project.endTime = formatDate(
                                          val, [yyyy, '-', mm, '-', dd]);
                                    }
                                  });
                                }).catchError((err) {
                                  print(err);
                                });
                              },
                              child: new Text(
                                _project.endTime == null
                                    ? '至今'
                                    : _project.endTime,
                                style: new TextStyle(fontSize: 26.0 * factor),
                              ),
                            )
                          ],
                        ),
                        new Divider(),
                        new Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 30.0 * factor),
                          child: new Text(
                            '项目描述：',
                            textAlign: TextAlign.left,
                            style: new TextStyle(fontSize: 28.0 * factor),
                          ),
                        ),
                        TextArea(
                          text: _project.detail,
                          callback: (String val) {
                            setState(() {
                              _project.detail = val;
                            });
                          },
                        ),
                        new Divider(),
                        new Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 30.0 * factor),
                          child: new Text(
                            '项目业绩：',
                            textAlign: TextAlign.left,
                            style: new TextStyle(fontSize: 28.0 * factor),
                          ),
                        ),
                        TextArea(
                          text: _project.performance,
                          callback: (String val) {
                            setState(() {
                              _project.performance = val;
                            });
                          },
                        ),
                        new Divider()
                      ],
                    ),
                  )),
                  Positioned(
                    right: 90 * factor,
                    bottom: 40 * factor,
                    child: RaisedButton(
                        shape: new CircleBorder(
                          side: new BorderSide(
                            //设置 界面效果
                            color: Theme.of(context).primaryColor,
                            style: BorderStyle.none,
                          ),
                        ),
                        child: Icon(
                          Icons.close,
                          size: 50.0 * factor,
                          color: Colors.white,
                        ),
                        color: Colors.orange,
                        onPressed: () {
                          if (isRequesting) return;
                          showDialog<Null>(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return new AlertDialog(
                                content: Text(
                                  "确认要删除么？",
                                  style: TextStyle(fontSize: 28 * factor),
                                ),
                                actions: <Widget>[
                                  new TextButton(
                                    child: new Text(
                                      '确定',
                                      style: TextStyle(
                                          fontSize: 24 * factor,
                                          color: Colors.orange),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        isRequesting = true;
                                      });
                                      // 发送给webview，让webview登录后再取回token
                                      Api()
                                          .deleteProject(_project.id)
                                          .then((Response response) {
                                        setState(() {
                                          isRequesting = false;
                                        });
                                        if (response.data['code'] != 1) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(new SnackBar(
                                            content: new Text("删除失败！"),
                                          ));
                                          return;
                                        }
                                        Resume resume = state.resume;
                                        resume.projects.removeWhere(
                                            (Project project) =>
                                                project.id == _project.id);
                                        StoreProvider.of<AppState>(context)
                                            .dispatch(SetResumeAction(resume));
                                        Navigator.pop(context);
                                      }).catchError((e) {
                                        setState(() {
                                          isRequesting = false;
                                        });
                                        print(e);
                                      });
                                    },
                                  ),
                                  new TextButton(
                                    child: new Text(
                                      '取消',
                                      style: TextStyle(fontSize: 24 * factor),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }),
                  ),
                  Positioned(
                    right: 0 * factor,
                    bottom: 40 * factor,
                    child: RaisedButton(
                        shape: new CircleBorder(
                          side: new BorderSide(
                            //设置 界面效果
                            color: Colors.orange,
                            style: BorderStyle.none,
                          ),
                        ),
                        child: Icon(
                          Icons.check,
                          size: 50.0 * factor,
                          color: Colors.white,
                        ),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          if (isRequesting) return;
                          setState(() {
                            isRequesting = true;
                          });
                          // 发送给webview，让webview登录后再取回token
                          Api()
                              .saveProject(
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
                            if (response.data['code'] != 1) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(new SnackBar(
                                content: new Text("保存失败！"),
                              ));
                              return;
                            }
                            Resume resume = state.resume;
                            if (_project.id == null) {
                              resume.projects
                                  .add(Project.fromMap(response.data['info']));
                              StoreProvider.of<AppState>(context)
                                  .dispatch(SetResumeAction(resume));
                            } else {
                              for (var i = 0; i < resume.projects.length; i++) {
                                if (resume.projects[i].id == _project.id) {
                                  resume.projects[i] = _project;
                                  break;
                                }
                              }
                              StoreProvider.of<AppState>(context)
                                  .dispatch(SetResumeAction(resume));
                            }
                            Navigator.pop(context, response.data['info']);
                          }).catchError((e) {
                            setState(() {
                              isRequesting = false;
                            });
                            print(e);
                          });
                        }),
                  )
                ],
              ));
        });
  }
}
