import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_app/app/component/common_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/app/model/app.dart';
import 'package:flutter_app/actions/actions.dart';
import 'package:custom_radio/custom_radio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_cropper/image_cropper.dart';

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
  String userName = '';

  static List<String> genders = [
    "男",
    "女",
    "其他",
  ];

  @override
  void initState() {
    super.initState();
    setState(() {
      personalInfo = widget.personalInfo;
    });
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      setState(() {
        userName = prefs.getString('userName');
      });
    });
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
            title: new Text('个人信息',
                style: new TextStyle(fontSize: 30.0*factor, color: Colors.white)),
          ),
          body: new SingleChildScrollView(
            child: new Padding(
              padding: EdgeInsets.all(10.0*factor),
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
                        style: new TextStyle(fontSize: 24.0*factor),
                      ),

                      new InkWell(
                        onTap: () {
                          ImagePicker.pickImage(source: ImageSource.gallery).then((imageFile) {
                            return ImageCropper.cropImage(
                              sourcePath: imageFile.path,
                              ratioX: 1,
                              ratioY: 1,
                              maxWidth: 200,
                              maxHeight: 200,
                            );
                          }).then((image) {
                            return Api().upload(image, '${userName}_avatar${image.path.substring(image.path.lastIndexOf("."))}');
                          }).then((Response response) {
                            if(response.data['code'] != 1) {
                              return;
                            }
                            setState(() {
                              personalInfo.avatar = response.data['imgurl'];
                            });
                            Resume resume = state.resume;
                            resume.personalInfo = personalInfo;
                            StoreProvider.of<AppState>(context).dispatch(SetResumeAction(resume));
                          })
                          .catchError((e) {
                            print(e);
                          });
                        },
                        child: personalInfo.avatar != null ? new CircleAvatar(
                          radius: 45.0*factor,
                          backgroundImage: new NetworkImage(personalInfo.avatar)
                        ) : new Image.asset(
                          "assets/images/ic_avatar_default.png",
                          width: 90.0*factor,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    ],
                  ),
                  new Divider(),
                  new Padding(
                    padding: EdgeInsets.only(bottom: 10.0*factor),
                    child: new Text(
                      '姓名：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 24.0*factor),
                    ),
                  ),
                  new Padding(
                    padding: EdgeInsets.only(bottom: 16.0*factor),
                    child: new TextField(
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                          // 设置内容
                          text: personalInfo.name == null ? '' : personalInfo.name,
                          // 保持光标在最后
                          selection: TextSelection.fromPosition(
                            TextPosition(
                              affinity: TextAffinity.downstream,
                              offset: personalInfo.name == null ? 0 : personalInfo.name.length
                            )
                          )
                        )
                      ),
                      style: new TextStyle(fontSize: 20.0*factor),
                      onChanged: (val) {
                        setState(() {
                          personalInfo.name = val;
                        });
                      },
                      decoration: new InputDecoration(
                        hintText: "请输入您的姓名",
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
                  new Padding(
                    padding: EdgeInsets.only(bottom: 10.0*factor),
                    child: new Text(
                      '性别：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 24.0*factor),
                    ),
                  ),
                  
                  Container(
                    height: 80*factor,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 3,
                      itemBuilder: (BuildContext context, int index) {
                        return new Row(
                          children: <Widget>[
                            CustomRadio<String, dynamic>(
                              value: genders[index],
                              groupValue: personalInfo.gender,
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
                              builder: (BuildContext context, List<dynamic> animValues, Function updateState, String value) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      personalInfo.gender = value;
                                    });
                                  },
                                  child: Container(
                                    width: 24.0*factor,
                                    height: 24.0*factor,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(
                                      top: 10.0*factor,
                                      bottom: 10*factor,
                                      right: 10*factor,
                                      left: 146.5*factor
                                    ),
                                    padding: EdgeInsets.all(3.0*factor),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: personalInfo.gender == value ? Colors.cyan[300] : Colors.grey[600],
                                        width: 1.0*factor
                                      )
                                    ),
                                    child: personalInfo.gender == value ? Container(
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
                            new Text(genders[index], style: new TextStyle(fontSize: 24.0*factor),),
                          ]
                        );
                      },
                      scrollDirection: Axis.horizontal,
                      physics: NeverScrollableScrollPhysics(),
                    ),
                  ),
                  
                  new Divider(),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Text(
                        '参加工作时间：',
                        textAlign: TextAlign.left,
                        style: new TextStyle(fontSize: 24.0*factor),
                      ),

                      new InkWell(
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: personalInfo.firstJobTime == null ? DateTime.now() : DateTime.parse(personalInfo.firstJobTime),
                            firstDate: personalInfo.firstJobTime == null ? DateTime.parse('1950-01-01') : DateTime.parse(personalInfo.firstJobTime).subtract(new Duration(days: 30)), // 减 30 天
                            lastDate: new DateTime.now(),       // 加 30 天
                          ).then((DateTime val) {
                            setState(() {
                              personalInfo.firstJobTime = formatDate(val, [yyyy, '-', mm, '-', dd]);
                            });
                          }).catchError((err) {
                            print(err);
                          });
                        },
                        child: new Text(personalInfo.firstJobTime == null ? '请选择' : personalInfo.firstJobTime, style: TextStyle(fontSize: 24.0*factor),),
                      )
                    ],
                  ),
                  new Divider(),
                  new Padding(
                    padding: EdgeInsets.only(bottom: 10.0*factor),
                    child: new Text(
                      '微信号：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 24.0*factor),
                    ),
                  ),
                  new Padding(
                    padding: EdgeInsets.only(bottom: 16.0*factor),
                    child: new TextField(
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                          // 设置内容
                          text: personalInfo.wechatId == null ? '' : personalInfo.wechatId,
                          // 保持光标在最后
                          selection: TextSelection.fromPosition(
                            TextPosition(
                              affinity: TextAffinity.downstream,
                              offset: personalInfo.wechatId == null ? 0 : personalInfo.wechatId.length
                            )
                          )
                        )
                      ),
                      style: TextStyle(fontSize: 20.0*factor),
                      onChanged: (val) {
                        setState(() {
                          personalInfo.wechatId = val;
                        });
                      },
                      decoration: new InputDecoration(
                        hintText: "请输入您的微信号",
                        hintStyle: new TextStyle(
                            color: const Color(0xFF808080),
                            fontSize: 20.0*factor
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
                        '出生年月：',
                        textAlign: TextAlign.left,
                        style: new TextStyle(fontSize: 24.0*factor),
                      ),

                      new InkWell(
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: personalInfo.birthDay == null ? DateTime.now() : DateTime.parse(personalInfo.birthDay),
                            firstDate: personalInfo.birthDay == null ? DateTime.parse('1950-01-01') : DateTime.parse(personalInfo.birthDay).subtract(new Duration(days: 30)), // 减 30 天
                            lastDate: new DateTime.now(),       // 加 30 天
                          ).then((DateTime val) {
                            setState(() {
                              personalInfo.birthDay = formatDate(val, [yyyy, '-', mm, '-', dd]);
                            });
                          }).catchError((err) {
                            print(err);
                          });
                        },
                        child: new Text(personalInfo.birthDay == null ? '请选择' : personalInfo.birthDay, style: TextStyle(fontSize: 24.0*factor),),
                      )
                    ],
                  ),
                  new Divider(),
                  new Padding(
                    padding: EdgeInsets.only(bottom: 10.0*factor),
                    child: new Text(
                      '我的优势：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 24.0*factor),
                    ),
                  ),
                  new TextField(
                    controller: TextEditingController.fromValue(
                      TextEditingValue(
                        // 设置内容
                        text: personalInfo.summarize == null ? '' : personalInfo.summarize,
                        // 保持光标在最后
                        selection: TextSelection.fromPosition(
                          TextPosition(
                            affinity: TextAffinity.downstream,
                            offset: personalInfo.summarize == null ? 0 : personalInfo.summarize.length
                          )
                        )
                      )
                    ),
                    onChanged: (val) {
                      setState(() {
                        personalInfo.summarize = val;
                      });
                    },
                    style: TextStyle(fontSize: 20.0*factor),
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    decoration: new InputDecoration(
                      hintText: "请输入您的优势",
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
                        Api().savePersonalInfo(
                          personalInfo.name,
                          personalInfo.gender,
                          personalInfo.firstJobTime,
                          personalInfo.wechatId,
                          personalInfo.birthDay,
                          personalInfo.summarize,
                          personalInfo.avatar,
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
                            resume.personalInfo = personalInfo;
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