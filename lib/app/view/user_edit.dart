import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/app/model/app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_app/util/util.dart';

class UserEditView extends StatefulWidget {

  final PersonalInfo personalInfo;

  UserEditView(this.personalInfo);

  @override
  UserEditViewState createState() => new UserEditViewState();
}

class UserEditViewState extends State<UserEditView>
    with TickerProviderStateMixin {

  PersonalInfo personalInfo;
  bool isRequesting = false;
  String userName = '';
  int role;

  @override
  void initState() {
    super.initState();
    setState(() {
      personalInfo = PersonalInfo.copy(widget.personalInfo);
    });
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      setState(() {
        userName = prefs.getString('userName');
        role = prefs.getInt('role');
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
            title: new Text('基本信息',
                style: new TextStyle(fontSize: 30.0*factor, color: Colors.white)),
          ),
          body: new Stack(
            fit: StackFit.expand,
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
                      role == 2 ? new Padding(
                        padding: EdgeInsets.symmetric(vertical: 30.0*factor),
                        child: new Text(
                          '姓名：',
                          textAlign: TextAlign.left,
                          style: new TextStyle(fontSize: 28.0*factor),
                        ),
                      ) : Container(),
                      role == 2 ? new Padding(
                        padding: EdgeInsets.only(bottom: 8.0*factor),
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
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 20.0*factor)
                          ),
                        ),
                      ) : Container(),
                      role == 2 ? Divider() : Container(),
                      new Padding(
                        padding: EdgeInsets.only(top: 30*factor,bottom: 30.0*factor),
                        child: new Text(
                          '昵称：（用于交流区）',
                          textAlign: TextAlign.left,
                          style: new TextStyle(fontSize: 28.0*factor),
                        ),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(bottom: 8.0*factor),
                        child: new TextField(
                          controller: TextEditingController.fromValue(
                            TextEditingValue(
                              // 设置内容
                              text: personalInfo.nickname == null ? '' : personalInfo.nickname,
                              // 保持光标在最后
                              selection: TextSelection.fromPosition(
                                TextPosition(
                                  affinity: TextAffinity.downstream,
                                  offset: personalInfo.nickname == null ? 0 : personalInfo.nickname.length
                                )
                              )
                            )
                          ),
                          style: TextStyle(fontSize: 26.0*factor),
                          onChanged: (val) {
                            setState(() {
                              personalInfo.nickname = val;
                            });
                          },
                          decoration: new InputDecoration(
                            hintText: "请输入您的昵称",
                            hintStyle: new TextStyle(
                                color: const Color(0xFF808080),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 20.0*factor)
                          ),
                        ),
                      ),
                      Divider()
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
                    Api().savePersonalBaseInfo(
                      personalInfo.name,
                      personalInfo.nickname,
                      personalInfo.avatar,
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