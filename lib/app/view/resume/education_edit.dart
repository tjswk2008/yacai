import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:flutter_app/app/component/common_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:flutter_app/actions/actions.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/app/model/app.dart';
import 'package:date_format/date_format.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

class EducationEditView extends StatefulWidget {

  final Education _education;

  EducationEditView(this._education);

  @override
  EducationEditViewState createState() => new EducationEditViewState();
}

class EducationEditViewState extends State<EducationEditView>
    with TickerProviderStateMixin {

  VoidCallback onChanged;
  Education _education;
  bool isRequesting = false;

  @override
  void initState() {
    super.initState();
    setState(() {
     _education = widget._education; 
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
            title: new Text('教育经历',
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
                      '学校名称：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 18.0),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: new TextField(
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                          text: _education.name,
                          selection: TextSelection.fromPosition(
                            TextPosition(
                              affinity: TextAffinity.downstream,
                              offset: _education.name.length
                            )
                          )
                        )
                      ),
                      onChanged: (val) {
                        setState(() {
                          _education.name = val;
                        });
                      },
                      decoration: new InputDecoration(
                        hintText: "请输入学校名称",
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
                      '学历：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 18.0),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: new TextField(
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                          text: _education.academic,
                          selection: TextSelection.fromPosition(
                            TextPosition(
                              affinity: TextAffinity.downstream,
                              offset: _education.academic.length
                            )
                          )
                        )
                      ),
                      onChanged: (val) {
                        setState(() {
                          _education.academic = val;
                        });
                      },
                      decoration: new InputDecoration(
                        hintText: "请选择学历",
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
                      '专业：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 18.0),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: new TextField(
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                          text: _education.major,
                          selection: TextSelection.fromPosition(
                            TextPosition(
                              affinity: TextAffinity.downstream,
                              offset: _education.major.length
                            )
                          )
                        )
                      ),
                      onChanged: (val) {
                        setState(() {
                          _education.major = val;
                        });
                      },
                      decoration: new InputDecoration(
                        hintText: "请输入专业名称",
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
                            initialDate: DateTime.parse(_education.startTime),
                            firstDate: DateTime.parse('1900-01-01'), // 减 30 天
                            lastDate: new DateTime.now(),       // 加 30 天
                          ).then((DateTime val) {
                            setState(() {
                              _education.startTime = formatDate(val, [yyyy, '-', mm, '-', dd]);
                            });
                          }).catchError((err) {
                            print(err);
                          });
                        },
                        child: new Text(_education.startTime),
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
                              _education.endTime == null ? formatDate(new DateTime.now(), [yyyy, '-', mm, '-', dd]) : _education.endTime
                            ),
                            firstDate: DateTime.parse('1900-01-01'), // 减 30 天
                            lastDate: new DateTime.now(),       // 加 30 天
                          ).then((DateTime val) {
                            setState(() {
                              String currentDate = formatDate(new DateTime.now(), [yyyy, '-', mm, '-', dd]);
                              if (formatDate(val, [yyyy, '-', mm, '-', dd]) == currentDate) {
                                _education.endTime = null;
                              } else {
                                _education.endTime = formatDate(val, [yyyy, '-', mm, '-', dd]);
                              }
                            });
                          }).catchError((err) {
                            print(err);
                          });
                        },
                        child: new Text(_education.endTime == null ? '至今' : _education.endTime),
                      )
                    ],
                  ),
                  new Divider(),
                  new Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: new Text(
                      '在校经历：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 18.0),
                    ),
                  ),
                  new TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    controller: TextEditingController.fromValue(
                      TextEditingValue(
                        text: _education.detail,
                        selection: TextSelection.fromPosition(
                          TextPosition(
                            affinity: TextAffinity.downstream,
                            offset: _education.detail.length
                          )
                        )
                      )
                    ),
                    onChanged: (val) {
                      setState(() {
                        _education.detail = val;
                      });
                    },
                    decoration: new InputDecoration(
                      hintText: "请输入在校经历",
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
                        Api().saveEducation(
                          _education.name,
                          _education.academic,
                          _education.major,
                          _education.startTime,
                          _education.endTime,
                          _education.detail,
                          state.userName,
                          _education.id,
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
                            if(_education.id == null) {
                              resume.educations.add(Education.fromMap(response.data['info']));
                              StoreProvider.of<AppState>(context).dispatch(SetResumeAction(resume));
                            } else {
                              for (var i = 0; i < resume.educations.length; i++) {
                                if(resume.educations[i].id == _education.id) {
                                  resume.educations[i] = _education;
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