import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/app/model/app.dart';
import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:flutter_app/actions/actions.dart';
import 'package:flutter_app/app/model/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_app/app/component/select.dart';


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
  String userName = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      _companyExperience = CompanyExperience.copy(widget._companyExperience);
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
                _companyExperience = null;
                Navigator.maybePop(context);
              }
            ),
            title: new Text('工作经历',
                style: new TextStyle(fontSize: 30.0*factor, color: Colors.white)),
          ),
          body: new SingleChildScrollView(
            child: new Padding(
              padding: EdgeInsets.all(30.0*factor),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Padding(
                    padding: EdgeInsets.only(bottom: 20.0*factor),
                    child: new Text(
                      '公司名：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 28.0*factor),
                    ),
                  ),
                  new Padding(
                    padding: EdgeInsets.only(bottom: 16.0*factor),
                    child: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
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
                        style: TextStyle(fontSize: 26*factor),
                        decoration: new InputDecoration(
                          hintText: "请输入公司名",
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
                        Response response = await Api().getCompanySuggestions(pattern);
                        return response.data;
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          leading: Icon(Icons.business),
                          title: Text(suggestion['name']),
                          subtitle: Text('${suggestion['location']}'),
                        );
                      },
                      onSuggestionSelected: (suggestion) {
                        setState(() {
                        _companyExperience.cname = suggestion['name'];
                        });
                      },
                    )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0*factor),
                        child: new Text(
                          '职位名称：',
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
                                  _companyExperience.jobTitle =  res;
                                });
                              },
                              data: titleArr,
                            );
                          },
                          child: new Text(_companyExperience.jobTitle == null || _companyExperience.jobTitle == '' ? '请选择' : _companyExperience.jobTitle, style: TextStyle(fontSize: 22.0*factor),),
                        ) 
                      ),
                    ],
                  ),
                  Divider(),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20*factor),
                        child: new Text(
                          '开始时间：',
                          textAlign: TextAlign.left,
                          style: new TextStyle(fontSize: 28.0*factor),
                        ),
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
                        child: new Text(_companyExperience.startTime, style: TextStyle(fontSize: 28*factor),),
                      )
                    ],
                  ),
                  new Divider(),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20*factor),
                        child: new Text(
                          '结束时间：',
                          textAlign: TextAlign.left,
                          style: new TextStyle(fontSize: 28.0*factor),
                        ),
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
                        child: new Text(_companyExperience.endTime == null ? '至今' : _companyExperience.endTime, style: TextStyle(fontSize: 28*factor),),
                      )
                    ],
                  ),
                  new Divider(),
                  new Padding(
                    padding: EdgeInsets.only(bottom: 20.0*factor),
                    child: new Text(
                      '工作内容：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 28.0*factor),
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
                    style: TextStyle(fontSize: 26.0*factor),
                    decoration: new InputDecoration(
                      hintText: "请输入您的工作内容",
                      hintStyle: new TextStyle(
                          color: const Color(0xFF808080),
                          fontSize: 26.0*factor
                      ),
                      border: new OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6.0*factor))
                      ),
                      contentPadding: EdgeInsets.all(20.0*factor)
                    ),
                  ),
                  new Divider(),
                  new Padding(
                    padding: EdgeInsets.only(bottom: 20.0*factor),
                    child: new Text(
                      '工作业绩：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 28.0*factor),
                    ),
                  ),
                  new TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    style: TextStyle(fontSize: 26.0*factor),
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
                          color: const Color(0xFF808080),
                          fontSize: 26.0*factor
                      ),
                      border: new OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6.0*factor))
                      ),
                      contentPadding: EdgeInsets.all(20.0*factor)
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
                                      Api().deleteCompanyExperience(_companyExperience.id)
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
                                          resume.companyExperiences.removeWhere((CompanyExperience companyExperience) => companyExperience.id == _companyExperience.id);
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
                          if(_companyExperience.cname == null || _companyExperience.cname == '') {
                            Scaffold.of(context).showSnackBar(new SnackBar(
                              content: new Text("请填写公司名~"),
                            ));
                            return;
                          }
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
                            userName,
                            _companyExperience.id,
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