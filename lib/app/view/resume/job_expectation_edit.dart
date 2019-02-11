import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:flutter_app/app/component/common_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:flutter_app/actions/actions.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/app/model/app.dart';

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

  @override
  void initState() {
    super.initState();
    setState(() {
     _jobExpect = widget._jobExpect; 
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
            title: new Text('工作期望',
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
                      '期望职位：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 18.0),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: new TextField(
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                          // 设置内容
                          text: _jobExpect.jobTitle,
                          // 保持光标在最后
                          selection: TextSelection.fromPosition(
                            TextPosition(
                              affinity: TextAffinity.downstream,
                              offset: _jobExpect.jobTitle.length
                            )
                          )
                        )
                      ),
                      onChanged: (val) {
                        setState(() {
                          _jobExpect.jobTitle = val;
                        });
                      },
                      decoration: new InputDecoration(
                        hintText: "请输入期望职位",
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
                      '期望行业：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 18.0),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: new TextField(
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                          // 设置内容
                          text: _jobExpect.industry,
                          // 保持光标在最后
                          selection: TextSelection.fromPosition(
                            TextPosition(
                              affinity: TextAffinity.downstream,
                              offset: _jobExpect.industry.length
                            )
                          )
                        )
                      ),
                      onChanged: (val) {
                        setState(() {
                          _jobExpect.industry = val;
                        });
                      },
                      decoration: new InputDecoration(
                        hintText: "请输入您的期望行业",
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
                      '工作城市：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 18.0),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: new TextField(
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                          // 设置内容
                          text: _jobExpect.city,
                          // 保持光标在最后
                          selection: TextSelection.fromPosition(
                            TextPosition(
                              affinity: TextAffinity.downstream,
                              offset: _jobExpect.city.length
                            )
                          )
                        )
                      ),
                      onChanged: (val) {
                        setState(() {
                          _jobExpect.city = val;
                        });
                      },
                      decoration: new InputDecoration(
                        hintText: "请输入您期望的工作城市",
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
                      '薪资要求：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 18.0),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: new TextField(
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                          // 设置内容
                          text: _jobExpect.salary,
                          // 保持光标在最后
                          selection: TextSelection.fromPosition(
                            TextPosition(
                              affinity: TextAffinity.downstream,
                              offset: _jobExpect.salary.length
                            )
                          )
                        )
                      ),
                      onChanged: (val) {
                        setState(() {
                          _jobExpect.salary = val;
                        });
                      },
                      decoration: new InputDecoration(
                        hintText: "请输入您的薪资要求",
                        hintStyle: new TextStyle(
                            color: const Color(0xFF808080)
                        ),
                        border: new UnderlineInputBorder(),
                        contentPadding: const EdgeInsets.all(10.0)
                      ),
                    ),
                  ),
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
                          state.userName
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