import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_app/app/component/common_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/app/model/app.dart';

class PersonalInfoEditView extends StatefulWidget {

  final PersonalInfo personalInfo;

  PersonalInfoEditView(this.personalInfo);

  @override
  PersonalInfoEditViewState createState() => new PersonalInfoEditViewState();
}

class PersonalInfoEditViewState extends State<PersonalInfoEditView>
    with TickerProviderStateMixin {

  PersonalInfo personalInfo;
  bool isRequesting = false;
  File _image;

  @override
  void initState() {
    super.initState();
    setState(() {
      personalInfo = widget.personalInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, String>(
      converter: (store) => store.state.userName,
      builder: (context, userName) {
        return new Scaffold(
          backgroundColor: Colors.white,
          appBar: new AppBar(
            elevation: 0.0,
            title: new Text('个人信息',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
          ),
          body: new SingleChildScrollView(
            child: new Padding(
              padding: const EdgeInsets.all(10.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Text(
                        '头像',
                        textAlign: TextAlign.left,
                        style: new TextStyle(fontSize: 18.0),
                      ),

                      new InkWell(
                        onTap: () {
                          ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
                            return Api().upload(image, image.path.substring(image.path.lastIndexOf("/") + 1));
                          }).then((Response response) {
                            if(response.data['code'] != 1) {
                              return;
                            }
                            setState(() {
                              personalInfo.avatar = response.data['imgurl'];
                            });
                          })
                          .catchError((e) {
                            print(e);
                          });
                        },
                        child: _image == null ? new CircleAvatar(
                          radius: 35.0,
                          backgroundImage: new NetworkImage(personalInfo.avatar)
                        ) : Image.file(_image, width: 35.0),
                      )
                    ],
                  ),
                  new Divider(),
                  new Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: new Text(
                      '姓名：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 18.0),
                    ),
                  ),
                  new TextField(
                    controller: TextEditingController.fromValue(
                      TextEditingValue(
                        // 设置内容
                        text: personalInfo.name,
                        // 保持光标在最后
                        selection: TextSelection.fromPosition(
                          TextPosition(
                            affinity: TextAffinity.downstream,
                            offset: personalInfo.name.length
                          )
                        )
                      )
                    ),
                    decoration: new InputDecoration(
                      hintText: "请输入您的姓名",
                      hintStyle: new TextStyle(
                          color: const Color(0xFF808080)
                      ),
                      border: new UnderlineInputBorder(),
                      contentPadding: const EdgeInsets.all(10.0)
                    ),
                  ),
                  new Divider(),
                  new Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: new Text(
                      '性别：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 18.0),
                    ),
                  ),
                  new RadioListTile(
                    value: "男",
                    title: new Text('男'),
                    groupValue: personalInfo.gender,
                    activeColor: Colors.cyan[300],
                    onChanged: (T){
                      setState(() {
                        personalInfo.gender = T;
                      });
                    }
                  ),//onChanged为null表示按钮不可用
                  new RadioListTile(
                      value: "女",
                      title: new Text('女'),
                      groupValue: personalInfo.gender,//当value和groupValue一致的时候则选中
                      activeColor: Colors.cyan[300],
                      onChanged: (T){
                        setState(() {
                          personalInfo.gender = T;
                        });
                      }
                  ),
                  new RadioListTile(
                      value: "其他",
                      title: new Text('其他'),
                      groupValue: personalInfo.gender,
                      activeColor: Colors.cyan[300],
                      onChanged: (T){
                        setState(() {
                          personalInfo.gender = T;
                        });
                      }
                  ),
                  new Divider(),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Text(
                        '参加工作时间：',
                        textAlign: TextAlign.left,
                        style: new TextStyle(fontSize: 18.0),
                      ),

                      new InkWell(
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.parse(personalInfo.firstJobTime),
                            firstDate: DateTime.parse(personalInfo.firstJobTime).subtract(new Duration(days: 30)), // 减 30 天
                            lastDate: new DateTime.now().add(new Duration(days: 30)),       // 加 30 天
                          ).then((DateTime val) {
                            setState(() {
                              personalInfo.firstJobTime = formatDate(val, [yyyy, '-', mm, '-', dd]);
                            });
                          }).catchError((err) {
                            print(err);
                          });
                        },
                        child: new Text(personalInfo.firstJobTime),
                      )
                    ],
                  ),
                  new Divider(),
                  new Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: new Text(
                      '微信号：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 18.0),
                    ),
                  ),
                  new TextField(
                    controller: TextEditingController.fromValue(
                      TextEditingValue(
                        // 设置内容
                        text: personalInfo.wechatId,
                        // 保持光标在最后
                        selection: TextSelection.fromPosition(
                          TextPosition(
                            affinity: TextAffinity.downstream,
                            offset: personalInfo.name.length
                          )
                        )
                      )
                    ),
                    decoration: new InputDecoration(
                      hintText: "请输入您的微信号",
                      hintStyle: new TextStyle(
                          color: const Color(0xFF808080)
                      ),
                      border: new UnderlineInputBorder(),
                      contentPadding: const EdgeInsets.all(10.0)
                    ),
                  ),
                  new Divider(),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Text(
                        '出生年月：',
                        textAlign: TextAlign.left,
                        style: new TextStyle(fontSize: 18.0),
                      ),

                      new InkWell(
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.parse(personalInfo.birthDay),
                            firstDate: DateTime.parse(personalInfo.birthDay).subtract(new Duration(days: 30)), // 减 30 天
                            lastDate: new DateTime.now().add(new Duration(days: 30)),       // 加 30 天
                          ).then((DateTime val) {
                            setState(() {
                              personalInfo.birthDay = formatDate(val, [yyyy, '-', mm, '-', dd]);
                            });
                          }).catchError((err) {
                            print(err);
                          });
                        },
                        child: new Text(personalInfo.birthDay),
                      )
                    ],
                  ),
                  new Divider(),
                  new Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: new Text(
                      '我的优势：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 18.0),
                    ),
                  ),
                  new TextField(
                    controller: TextEditingController.fromValue(
                      TextEditingValue(
                        // 设置内容
                        text: personalInfo.summarize,
                        // 保持光标在最后
                        selection: TextSelection.fromPosition(
                          TextPosition(
                            affinity: TextAffinity.downstream,
                            offset: personalInfo.name.length
                          )
                        )
                      )
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    decoration: new InputDecoration(
                      hintText: "请输入您的优势",
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
                        Api().savePersonalInfo(
                          personalInfo.name,
                          personalInfo.gender,
                          personalInfo.firstJobTime,
                          personalInfo.wechatId,
                          personalInfo.birthDay,
                          personalInfo.summarize,
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