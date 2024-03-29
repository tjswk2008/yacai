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
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_app/app/component/select.dart';
import 'package:flutter_app/app/component/text_area.dart';
import 'package:flutter_app/util/util.dart';

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
  String userName = '';
  List<String> academics = academicArr.sublist(1);

  @override
  void initState() {
    super.initState();
    setState(() {
      _education = Education.copy(widget._education);
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
                    iconSize: 40 * factor,
                    tooltip:
                        MaterialLocalizations.of(context).backButtonTooltip,
                    onPressed: () {
                      _education = null;
                      Navigator.maybePop(context);
                    }),
                title: new Text('教育经历',
                    style: new TextStyle(
                        fontSize: 30.0 * factor, color: Colors.white)),
              ),
              body: Stack(
                fit: prefix0.StackFit.expand,
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
                            '学校名称：',
                            textAlign: TextAlign.left,
                            style: new TextStyle(fontSize: 28.0 * factor),
                          ),
                        ),
                        new Padding(
                            padding: EdgeInsets.only(bottom: 4.0 * factor),
                            child: TypeAheadField(
                              textFieldConfiguration: TextFieldConfiguration(
                                autofocus: true,
                                onChanged: (val) {
                                  setState(() {
                                    _education.name = val;
                                  });
                                },
                                controller: TextEditingController.fromValue(
                                    TextEditingValue(
                                        text: _education.name,
                                        selection: TextSelection.fromPosition(
                                            TextPosition(
                                                affinity:
                                                    TextAffinity.downstream,
                                                offset:
                                                    _education.name.length)))),
                                style: TextStyle(fontSize: 26 * factor),
                                decoration: new InputDecoration(
                                    hintText: "请输入学校名称",
                                    hintStyle: new TextStyle(
                                        color: const Color(0xFF808080),
                                        fontSize: 26.0 * factor),
                                    border: prefix0.InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                      top: 20.0 * factor,
                                      bottom: 20.0 * factor,
                                    )),
                              ),
                              suggestionsCallback: (pattern) async {
                                Response response =
                                    await Api().getSchoolSuggestions(pattern);
                                return response.data;
                              },
                              itemBuilder: (context, suggestion) {
                                return ListTile(
                                  leading: Icon(Icons.school),
                                  title: Text(suggestion['name']),
                                );
                              },
                              onSuggestionSelected: (suggestion) {
                                setState(() {
                                  _education.name = suggestion['name'];
                                });
                              },
                            )),
                        prefix0.Divider(),
                        new Padding(
                          padding: EdgeInsets.only(
                              top: 30 * factor, bottom: 30.0 * factor),
                          child: new Text(
                            '专业：',
                            textAlign: TextAlign.left,
                            style: new TextStyle(fontSize: 28.0 * factor),
                          ),
                        ),
                        new Padding(
                          padding: EdgeInsets.only(bottom: 4.0 * factor),
                          child: new TextField(
                            style: TextStyle(fontSize: 26.0 * factor),
                            controller: TextEditingController.fromValue(
                                TextEditingValue(
                                    text: _education.major,
                                    selection: TextSelection.fromPosition(
                                        TextPosition(
                                            affinity: TextAffinity.downstream,
                                            offset: _education.major.length)))),
                            onChanged: (val) {
                              setState(() {
                                _education.major = val;
                              });
                            },
                            decoration: new InputDecoration(
                                hintText: "请输入专业名称",
                                hintStyle: new TextStyle(
                                    color: const Color(0xFF808080),
                                    fontSize: 26 * factor),
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
                                  top: 40.0 * factor, bottom: 30.0 * factor),
                              child: new Text(
                                '学历：',
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
                                          _education.academic =
                                              academics.indexOf(res);
                                        });
                                      },
                                      data: academics,
                                    );
                                  },
                                  child: new Text(
                                    _education.academic == null
                                        ? '请选择'
                                        : academics[_education.academic],
                                    style: TextStyle(fontSize: 26.0 * factor),
                                  ),
                                )),
                          ],
                        ),
                        new Divider(),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Padding(
                              padding: EdgeInsets.only(
                                  top: 30.0 * factor, bottom: 30.0 * factor),
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
                                      DateTime.parse(_education.startTime),
                                  firstDate:
                                      DateTime.parse('1900-01-01'), // 减 30 天
                                  lastDate: new DateTime.now(), // 加 30 天
                                ).then((DateTime val) {
                                  setState(() {
                                    _education.startTime = formatDate(
                                        val, [yyyy, '-', mm, '-', dd]);
                                  });
                                }).catchError((err) {
                                  print(err);
                                });
                              },
                              child: new Text(
                                formatDate(DateTime.parse(_education.startTime),
                                    [yyyy, '-', mm, '-', dd]),
                                style: TextStyle(fontSize: 26 * factor),
                              ),
                            )
                          ],
                        ),
                        new Divider(),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Padding(
                              padding: EdgeInsets.only(
                                  top: 30.0 * factor, bottom: 30.0 * factor),
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
                                      _education.endTime == null
                                          ? formatDate(new DateTime.now(),
                                              [yyyy, '-', mm, '-', dd])
                                          : _education.endTime),
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
                                      _education.endTime = null;
                                    } else {
                                      _education.endTime = formatDate(
                                          val, [yyyy, '-', mm, '-', dd]);
                                    }
                                  });
                                }).catchError((err) {
                                  print(err);
                                });
                              },
                              child: new Text(
                                _education.endTime == null
                                    ? '至今'
                                    : formatDate(
                                        DateTime.parse(_education.endTime),
                                        [yyyy, '-', mm, '-', dd]),
                                style: TextStyle(fontSize: 26 * factor),
                              ),
                            )
                          ],
                        ),
                        new Divider(),
                        new Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 30.0 * factor),
                          child: new Text(
                            '在校经历：',
                            textAlign: TextAlign.left,
                            style: new TextStyle(fontSize: 28.0 * factor),
                          ),
                        ),
                        TextArea(
                          text: _education.detail,
                          callback: (String val) {
                            setState(() {
                              _education.detail = val;
                            });
                          },
                        ),
                        prefix0.Divider()
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
                                      if (state.resume.educations.length == 1) {
                                        YaCaiUtil.getInstance()
                                            .showMsg("请至少保留一个教育经历哦~");
                                        return;
                                      }
                                      setState(() {
                                        isRequesting = true;
                                      });
                                      // 发送给webview，让webview登录后再取回token
                                      Api()
                                          .deleteEducation(_education.academic,
                                              _education.id, userName)
                                          .then((Response response) {
                                        setState(() {
                                          isRequesting = false;
                                        });
                                        if (response.data['code'] != 1) {
                                          YaCaiUtil.getInstance()
                                              .showMsg("删除失败！");
                                          return;
                                        }
                                        Resume resume = state.resume;
                                        resume.educations.removeWhere(
                                            (Education education) =>
                                                education.id == _education.id);
                                        if (_education.academic ==
                                            resume.personalInfo.academic) {
                                          resume.personalInfo.academic =
                                              resume.educations[0].academic;
                                          resume.educations
                                              .forEach((Education education) {
                                            if (education.academic >
                                                resume.personalInfo.academic) {
                                              resume.personalInfo.academic =
                                                  education.academic;
                                            }
                                          });
                                        }
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
                              .saveEducation(
                            _education.name,
                            _education.academic,
                            _education.major,
                            _education.startTime,
                            _education.endTime,
                            _education.detail,
                            userName,
                            _education.id,
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
                            if (_education.academic >
                                resume.personalInfo.academic) {
                              resume.personalInfo.academic =
                                  _education.academic;
                            }
                            if (_education.id == null) {
                              resume.educations.add(
                                  Education.fromMap(response.data['info']));
                              StoreProvider.of<AppState>(context)
                                  .dispatch(SetResumeAction(resume));
                            } else {
                              for (var i = 0;
                                  i < resume.educations.length;
                                  i++) {
                                if (resume.educations[i].id == _education.id) {
                                  resume.educations[i] = _education;
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
