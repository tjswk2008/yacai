import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/app/model/app.dart';
import 'package:flutter_app/actions/actions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_app/app/component/select.dart';
import 'package:flutter_app/app/component/location_picker/location_picker.dart';
import 'package:flutter_app/app/model/constants.dart';
import 'package:flutter_app/util/util.dart';
import 'package:flutter_app/app/component/text_area.dart';

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
  List<String> areas = areaArr.sublist(1);

  static List<String> genders = [
    "男",
    "女",
    "其他",
  ];

  @override
  void initState() {
    super.initState();
    setState(() {
      personalInfo = PersonalInfo.copy(widget.personalInfo);
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
              iconSize: 40*factor,
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: () {
                personalInfo = null;
                Navigator.maybePop(context);
              }
            ),
            title: new Text('个人信息',
                style: new TextStyle(fontSize: 30.0*factor, color: Colors.white)),
          ),
          body: new Stack(
            children: <Widget>[
              new SingleChildScrollView(
                child: new Padding(
                  padding: EdgeInsets.all(50.0*factor),
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
                            style: new TextStyle(fontSize: 28.0*factor),
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
                                return Api().upload(image, '${userName}_avatar${DateTime.now().microsecondsSinceEpoch}${image.path.substring(image.path.lastIndexOf("."))}');
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
                            child: personalInfo.avatar != null ? new CircleAvatar(
                              radius: 45.0*factor,
                              backgroundImage: new NetworkImage(personalInfo.avatar)
                            ) : new Image.asset(
                              "assets/images/avatar_default.png",
                              width: 90.0*factor,
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                        ],
                      ),
                      new Divider(),
                      new Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0*factor),
                        child: new Text(
                          '姓名：',
                          textAlign: TextAlign.left,
                          style: new TextStyle(fontSize: 28.0*factor),
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
                          style: new TextStyle(fontSize: 26.0*factor),
                          onChanged: (val) {
                            setState(() {
                              personalInfo.name = val;
                            });
                          },
                          decoration: new InputDecoration(
                            hintText: "请输入您的姓名",
                            hintStyle: new TextStyle(
                                color: const Color(0xFF808080),
                            ),
                            border: new UnderlineInputBorder(
                              borderSide: BorderSide(width: 1.0*factor)
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 20.0*factor)
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Padding(
                            padding: EdgeInsets.only(top: 20.0*factor, bottom: 20.0*factor),
                            child: new Text(
                              '性别：',
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
                                      personalInfo.gender =  res;
                                    });
                                  },
                                  data: genderTypeArr,
                                );
                              },
                              child: new Text(personalInfo.gender == null ? '请选择' : personalInfo.gender, style: TextStyle(fontSize: 26.0*factor),),
                            ) 
                          ),
                        ],
                      ),
                      
                      new Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Padding(
                            padding: EdgeInsets.only(top: 20*factor,bottom: 20.0*factor),
                            child: new Text(
                              '居住地：',
                              textAlign: TextAlign.left,
                              style: new TextStyle(fontSize: 28.0*factor),
                            ),
                          ),
                          new InkWell(
                            onTap: () {
                              YCPicker.showYCPicker(
                                context,
                                selectItem: (res) {
                                  setState(() {
                                    personalInfo.residenceArea = res;
                                  });
                                },
                                data: areas,
                              );
                            },
                            child: Text(personalInfo.residenceArea == null ? '请选择' : '上海市 ${personalInfo.residenceArea}', style: TextStyle(fontSize: 26.0*factor, color: Colors.grey),),
                          ),
                        ],
                      ),
                      new Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Padding(
                            padding: EdgeInsets.only(top: 20*factor,bottom: 20.0*factor),
                            child: new Text(
                              '户口/国籍：',
                              textAlign: TextAlign.left,
                              style: new TextStyle(fontSize: 28.0*factor),
                            ),
                          ),
                          new InkWell(
                            onTap: () {
                              LocationPicker.showPicker(
                                context,
                                showTitleActions: true,
                                initialProvince: '上海',
                                initialCity: '上海',
                                initialTown: null,
                                onChanged: (p, c, t) {
                                  // print('$p $c $t');
                                },
                                onConfirm: (p, c, t) {
                                  setState(() {
                                    personalInfo.nativeProvince = p;
                                    personalInfo.nativeCity = c;
                                  });
                                },
                              );
                            },
                            child: Text(personalInfo.nativeProvince == null ? '请选择' : '${personalInfo.nativeProvince} ${personalInfo.nativeCity}', style: TextStyle(fontSize: 26.0*factor, color: Colors.grey),),
                          ),
                        ],
                      ),
                      new Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Padding(
                            padding: EdgeInsets.only(top: 20*factor,bottom: 20.0*factor),
                            child: new Text(
                              '婚姻状况：',
                              textAlign: TextAlign.left,
                              style: new TextStyle(fontSize: 28.0*factor),
                            ),
                          ),
                          new InkWell(
                            onTap: () {
                              YCPicker.showYCPicker(
                                context,
                                selectItem: (res) {
                                  setState(() {
                                    personalInfo.marriage = marriageArr.indexOf(res);
                                  });
                                },
                                data: marriageArr,
                              );
                            },
                            child: Text(personalInfo.marriage == null ? '请选择' : marriageArr[personalInfo.marriage], style: TextStyle(fontSize: 26.0*factor, color: Colors.grey),),
                          ),
                        ],
                      ),
                      new Divider(),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Padding(
                            padding: EdgeInsets.only(top: 20*factor,bottom: 20.0*factor),
                            child: new Text(
                              '参加工作时间：',
                              textAlign: TextAlign.left,
                              style: new TextStyle(fontSize: 28.0*factor),
                            ),
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
                            child: new Text(personalInfo.firstJobTime == null ? '请选择' : personalInfo.firstJobTime, style: TextStyle(fontSize: 26.0*factor),),
                          )
                        ],
                      ),
                      new Divider(),
                      new Padding(
                        padding: EdgeInsets.only(top: 20*factor,bottom: 20.0*factor),
                        child: new Text(
                          '微信号：',
                          textAlign: TextAlign.left,
                          style: new TextStyle(fontSize: 28.0*factor),
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
                          style: TextStyle(fontSize: 26.0*factor),
                          onChanged: (val) {
                            setState(() {
                              personalInfo.wechatId = val;
                            });
                          },
                          decoration: new InputDecoration(
                            hintText: "请输入您的微信号",
                            hintStyle: new TextStyle(
                                color: const Color(0xFF808080),
                            ),
                            border: new UnderlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 20.0*factor)
                          ),
                        ),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(top: 20*factor,bottom: 20.0*factor),
                        child: new Text(
                          '邮箱：',
                          textAlign: TextAlign.left,
                          style: new TextStyle(fontSize: 28.0*factor),
                        ),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(bottom: 16.0*factor),
                        child: new TextField(
                          controller: TextEditingController.fromValue(
                            TextEditingValue(
                              // 设置内容
                              text: personalInfo.email == null ? '' : personalInfo.email,
                              // 保持光标在最后
                              selection: TextSelection.fromPosition(
                                TextPosition(
                                  affinity: TextAffinity.downstream,
                                  offset: personalInfo.email == null ? 0 : personalInfo.email.length
                                )
                              )
                            )
                          ),
                          style: TextStyle(fontSize: 26.0*factor),
                          onChanged: (val) {
                            setState(() {
                              personalInfo.email = val;
                            });
                          },
                          decoration: new InputDecoration(
                            hintText: "请输入您的邮箱",
                            hintStyle: new TextStyle(
                                color: const Color(0xFF808080),
                            ),
                            border: new UnderlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 20.0*factor)
                          ),
                        ),
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Padding(
                            padding: EdgeInsets.only(top: 20*factor,bottom: 20.0*factor),
                            child: new Text(
                              '出生年月：',
                              textAlign: TextAlign.left,
                              style: new TextStyle(fontSize: 28.0*factor),
                            ),
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
                            child: new Text(personalInfo.birthDay == null ? '请选择' : personalInfo.birthDay, style: TextStyle(fontSize: 26.0*factor),),
                          )
                        ],
                      ),
                      new Divider(),
                      new Padding(
                        padding: EdgeInsets.only(top: 10*factor,bottom: 30.0*factor),
                        child: new Text(
                          '我的优势：',
                          textAlign: TextAlign.left,
                          style: new TextStyle(fontSize: 28.0*factor),
                        ),
                      ),
                      TextArea(
                        text: personalInfo.summarize,
                        callback: (String val) {
                          setState(() {
                            personalInfo.summarize = val;
                          });
                        },
                      ),
                      Divider(),
                      Container(height: 80*factor,)

                    ],
                  ),
                )
              ),
              Positioned(
                bottom: 30*factor,
                right: 50*factor,
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(
                    Icons.check,
                    size: 50.0*factor,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if(personalInfo.name == null || personalInfo.name == '') {
                      YaCaiUtil.getInstance().showMsg("请填写姓名~");
                      return;
                    }
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
                      personalInfo.residenceArea, // 区县
                      personalInfo.email, // 邮箱
                      personalInfo.nativeProvince, // 籍贯-省
                      personalInfo.nativeCity, // 籍贯-市
                      personalInfo.marriage,
                      userName
                    )
                      .then((Response response) {
                        setState(() {
                          isRequesting = false;
                        });
                        if(response.data['code'] != 1) {
                          YaCaiUtil.getInstance().showMsg("保存失败~");
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
                  },
                ),
              )
            ]
          )
        );
      }
    );
  }
}