import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:flutter_app/app/component/common_button.dart';
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
     _education = widget._education; 
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
            title: new Text('教育经历',
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
                      '学校名称：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 24.0*factor),
                    ),
                  ),
                  new Padding(
                    padding: EdgeInsets.only(bottom: 16.0*factor),
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
                                affinity: TextAffinity.downstream,
                                offset: _education.name.length
                              )
                            )
                          )
                        ),
                        style: TextStyle(fontSize: 20*factor),
                        decoration: new InputDecoration(
                          hintText: "请输入学校名称",
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
                      suggestionsCallback: (pattern) async {
                        Response response = await Api().getSchoolSuggestions(pattern);
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
                    )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Padding(
                        padding: EdgeInsets.only(top: 20.0*factor, bottom: 10.0*factor),
                        child: new Text(
                          '学历：',
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
                                  _education.academic = academics.indexOf(res);
                                });
                              },
                              data: academics,
                            );
                          },
                          child: new Text(_education.academic == null ? '请选择' : academics[_education.academic], style: TextStyle(fontSize: 22.0*factor),),
                        ) 
                      ),
                    ],
                  ),
                  new Divider(),
                  new Padding(
                    padding: EdgeInsets.only(top: 20*factor, bottom: 10.0*factor),
                    child: new Text(
                      '专业：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 24.0*factor),
                    ),
                  ),
                  new Padding(
                    padding: EdgeInsets.only(bottom: 16.0*factor),
                    child: new TextField(
                      style: TextStyle(fontSize: 20.0*factor),
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
                            color: const Color(0xFF808080),
                            fontSize: 20*factor
                        ),
                        border: new UnderlineInputBorder(),
                        contentPadding: EdgeInsets.all(10.0*factor)
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
                        style: new TextStyle(fontSize: 24.0*factor),
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
                        child: new Text(_education.startTime, style: TextStyle(fontSize: 24*factor),),
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
                        style: new TextStyle(fontSize: 24.0*factor),
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
                        child: new Text(_education.endTime == null ? '至今' : _education.endTime, style: TextStyle(fontSize: 24*factor),),
                      )
                    ],
                  ),
                  new Divider(),
                  new Padding(
                    padding: EdgeInsets.only(bottom: 10.0*factor),
                    child: new Text(
                      '在校经历：',
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
                          userName,
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