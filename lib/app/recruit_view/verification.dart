import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/company.dart';
import 'package:flutter_app/app/component/common_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/app/model/app.dart';
import 'package:flutter_app/actions/actions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/app/model/constants.dart';
import 'package:image_cropper/image_cropper.dart';

class Verification extends StatefulWidget {

  final Company _company;
  Verification(this._company);

  @override
  VerificationState createState() => new VerificationState();
}

class VerificationState extends State<Verification>
    with TickerProviderStateMixin {

  Company company;
  bool isRequesting = false;
  String userName = '';

  static List<bool> willings = [
    false,
    false,
    false,
  ];

  @override
  void initState() {
    super.initState();
    setState(() {
      company = widget._company;
      if(company.willing != null) {
        List<String> wills = company.willing.split(',');
        wills.forEach((will) {
          int index = int.parse(will);
          willings.replaceRange(index - 1, index, [true]);
        });
      } else {
        willings = [
          false,
          false,
          false,
        ];
      }
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
            title: new Text('企业认证',
                style: new TextStyle(fontSize: 30.0*factor, color: Colors.white)),
          ),
          body: new SingleChildScrollView(
            child: new Padding(
              padding: EdgeInsets.all(30.0*factor),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Padding(
                    padding: EdgeInsets.only(bottom: 10.0*factor),
                    child: new Text(
                      '法人姓名:',
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
                          text: company.corporator == null ? '' : company.corporator,
                          // 保持光标在最后
                          selection: TextSelection.fromPosition(
                            TextPosition(
                              affinity: TextAffinity.downstream,
                              offset: company.corporator == null ? 0 : company.corporator.length
                            )
                          )
                        )
                      ),
                      style: new TextStyle(fontSize: 26.0*factor),
                      onChanged: (val) {
                        setState(() {
                          company.corporator = val;
                        });
                      },
                      decoration: new InputDecoration(
                        hintText: "请输入法人姓名",
                        hintStyle: new TextStyle(
                            color: const Color(0xFF808080),
                            fontSize: 26.0*factor
                        ),
                        border: new UnderlineInputBorder(
                          borderSide: BorderSide(width: 1.0*factor)
                        ),
                        contentPadding: EdgeInsets.all(10.0*factor)
                      ),
                    ),
                  ),
                  new Padding(
                    padding: EdgeInsets.only(top: 20*factor, bottom: 10.0*factor),
                    child: new Text(
                      '身份证号码：',
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
                          text: company.idCard == null ? '' : company.idCard,
                          // 保持光标在最后
                          selection: TextSelection.fromPosition(
                            TextPosition(
                              affinity: TextAffinity.downstream,
                              offset: company.idCard == null ? 0 : company.idCard.length
                            )
                          )
                        )
                      ),
                      style: new TextStyle(fontSize: 26.0*factor),
                      onChanged: (val) {
                        setState(() {
                          company.idCard = val;
                        });
                      },
                      decoration: new InputDecoration(
                        hintText: "请输入身份证",
                        hintStyle: new TextStyle(
                            color: const Color(0xFF808080),
                            fontSize: 26.0*factor
                        ),
                        border: new UnderlineInputBorder(
                          borderSide: BorderSide(width: 1.0*factor)
                        ),
                        contentPadding: EdgeInsets.all(10.0*factor)
                      ),
                    ),
                  ),
                  new Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0*factor),
                    child: new Text(
                      '招聘意向：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 28.0*factor),
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
                            InkWell(
                              onTap: () {
                                setState(() {
                                  willings[index] = !willings[index];
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 10*factor, left: 104*factor),
                                decoration: BoxDecoration(
                                  border: Border.all(width: factor, color: willings[index] ? Theme.of(context).primaryColor : Colors.grey),
                                  color: willings[index] ? Theme.of(context).primaryColor : Colors.transparent
                                ),
                                child: willings[index]
                                  ? Icon(
                                      Icons.check,
                                      size: 32.0*factor,
                                      color: Colors.white,
                                    )
                                  : Container(width: 32*factor, height: 32*factor,),
                              )
                            ),
                            Text(jobTypeArr[index], style: TextStyle(fontSize: 26*factor),)
                          ]
                        );
                      },
                      scrollDirection: Axis.horizontal,
                      physics: NeverScrollableScrollPhysics(),
                    ),
                  ),
                  Divider(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      new Padding(
                        padding: EdgeInsets.only(top: 20*factor, bottom: 20.0*factor),
                        child: Text(
                          '上传法人身份证:',
                          textAlign: TextAlign.left,
                          style: new TextStyle(fontSize: 28.0*factor),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10*factor, bottom: 20.0*factor),
                        child: new Text(
                          '(请上传16:9的图片)',
                          textAlign: TextAlign.left,
                          style: new TextStyle(fontSize: 24.0*factor, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          new Padding(
                            padding: EdgeInsets.only(left: 112*factor, right: 122*factor),
                            child: InkWell(
                              onTap: () {
                                ImagePicker.pickImage(source: ImageSource.gallery).then((imageFile) {
                                  return ImageCropper.cropImage(
                                    sourcePath: imageFile.path,
                                    ratioX: 16,
                                    ratioY: 9,
                                  );
                                }).then((image) {
                                  return Api().upload(image, '${company.id}_idFront${DateTime.now().microsecondsSinceEpoch}${image.path.substring(image.path.lastIndexOf("."))}');
                                }).then((Response response) {
                                  if(response.data['code'] != 1) {
                                    return;
                                  }
                                  setState(() {
                                    company.idFront = response.data['imgurl'];
                                  });
                                })
                                .catchError((e) {
                                  print(e);
                                });
                              },
                              child: company.idFront != null ? Image.network(company.idFront, width: 192*factor,) : Container(
                                width: 192*factor,
                                height: 108*factor,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2*factor,
                                    color: Colors.grey
                                  )
                                ),
                                child: Icon(Icons.add, size: 50*factor)
                              ),
                            ),
                          ),
                          
                          new Padding(
                            padding: EdgeInsets.only(top: 20*factor, bottom: 20.0*factor),
                            child: Text('正面照', style: TextStyle(fontSize: 26*factor)),
                          ),
                        ]
                      ),
                      Column(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              ImagePicker.pickImage(source: ImageSource.gallery).then((imageFile) {
                                return ImageCropper.cropImage(
                                  sourcePath: imageFile.path,
                                  ratioX: 16,
                                  ratioY: 9,
                                );
                              }).then((image) {
                                return Api().upload(image, '${company.id}_idBack${DateTime.now().microsecondsSinceEpoch}${image.path.substring(image.path.lastIndexOf("."))}');
                              }).then((Response response) {
                                if(response.data['code'] != 1) {
                                  return;
                                }
                                setState(() {
                                  company.idBack = response.data['imgurl'];
                                });
                              })
                              .catchError((e) {
                                print(e);
                              });
                            },
                            child: company.idBack != null ? Image.network(company.idBack, width: 192*factor,) : Container(
                              width: 192*factor,
                              height: 108*factor,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2*factor,
                                  color: Colors.grey
                                )
                              ),
                              child: Icon(Icons.add, size: 50*factor)
                            ),
                          ),
                          new Padding(
                            padding: EdgeInsets.only(top: 20*factor, bottom: 20.0*factor),
                            child: Text('背面照', style: TextStyle(fontSize: 26*factor)),
                          ),
                        ]
                      ),
                    ],
                  ),
                  new Divider(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      new Padding(
                        padding: EdgeInsets.only(top: 20*factor, bottom: 20.0*factor),
                        child: new Text(
                          '营业执照:',
                          textAlign: TextAlign.left,
                          style: new TextStyle(fontSize: 28.0*factor),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10*factor, bottom: 20.0*factor),
                        child: new Text(
                          '(请上传9:16的图片)',
                          textAlign: TextAlign.left,
                          style: new TextStyle(fontSize: 24.0*factor, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                  
                  new Padding(
                    padding: EdgeInsets.only(left: 112*factor),
                    child: InkWell(
                      onTap: () {
                        ImagePicker.pickImage(source: ImageSource.gallery).then((imageFile) {
                          return ImageCropper.cropImage(
                            sourcePath: imageFile.path,
                            ratioX: 9,
                            ratioY: 16,
                          );
                        }).then((image) {
                          return Api().upload(image, '${company.id}_license${DateTime.now().microsecondsSinceEpoch}${image.path.substring(image.path.lastIndexOf("."))}');
                        }).then((Response response) {
                          if(response.data['code'] != 1) {
                            return;
                          }
                          setState(() {
                            company.license = response.data['imgurl'];
                          });
                        })
                        .catchError((e) {
                          print(e);
                        });
                      },
                      child: company.license != null ? Image.network(company.license, width: 108*factor, height: 192*factor,) : Container(
                        width: 108*factor,
                        height: 192*factor,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2*factor,
                            color: Colors.grey
                          )
                        ),
                        child: Icon(Icons.add, size: 50*factor)
                      ),
                    ),
                  ),
                  Divider(),
                  Container(height: 20*factor,),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 5*factor),
                        child: Text('*', style: TextStyle(fontSize: 26*factor, color: Colors.red),),
                      ),
                      Text('提交资料表示您同意该用户', style: TextStyle(fontSize: 26*factor, color: Colors.grey),),
                      new InkWell(
                        onTap: () {
                          Navigator.of(context).push(new PageRouteBuilder(
                              opaque: false,
                              pageBuilder: (BuildContext context, _, __) {
                                // return new NewLoginPage();
                              },
                              transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                                return new FadeTransition(
                                  opacity: animation,
                                  child: new SlideTransition(position: new Tween<Offset>(
                                    begin: const Offset(0.0, 1.0),
                                    end: Offset.zero,
                                  ).animate(animation), child: child),
                                );
                              }
                          ));
                        },
                        child: new Text('协议', style: TextStyle(fontSize: 26.0*factor, color: Colors.blue))
                      )
                    ]
                  ),
                  company.verified == 2 ? Divider() : Container(height: 20*factor,),
                  company.verified == 2 ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 20*factor, bottom: 20.0*factor),
                        child: new Text(
                          '未通过原因:',
                          textAlign: TextAlign.left,
                          style: new TextStyle(fontSize: 26.0*factor),
                        ),
                      ),
                      new Row(
                        children: <Widget>[
                          Container(width: 20*factor,),
                          new Flexible(
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(
                                  company.reason,
                                  style: new TextStyle(
                                    fontSize: 26.0*factor,
                                    color: Colors.red
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(width: 20*factor,),
                        ]
                      ),
                      Container(height: 30*factor,)
                    ],
                  ) : Container(),
                  
                  new Builder(builder: (ctx) {
                    return new CommonButton(
                      text: "提交",
                      color: Theme.of(context).primaryColor,
                      onTap: () async {
                        if (isRequesting) return;
                        setState(() {
                          isRequesting = true;
                        });
                        try {
                          List<int> willing = [];
                          for (var i = 0; i < willings.length; i++) {
                            if(willings[i]) {
                              willing.add(i + 1);
                            }
                          }
                          company.willing = willing.join(",");
                          Response response = await Api().verification(
                            company.corporator,
                            company.idCard,
                            company.idFront,
                            company.idBack,
                            company.license,
                            company.willing,
                            company.id
                          );

                          setState(() {
                            isRequesting = false;
                          });
                          if(response.data['code'] != 1) {
                            Scaffold.of(ctx).showSnackBar(new SnackBar(
                              content: new Text(response.data['msg'] != null ? response.data['msg'] : "保存失败！"),
                            ));
                            return;
                          }
                          StoreProvider.of<AppState>(context).dispatch(SetCompanyAction(company));
                          Navigator.pop(context, response.data['info']);
                        } catch(e) {
                          setState(() {
                            isRequesting = false;
                          });
                          print(e);
                        }
                      }
                    );
                  }),

                  Padding(
                    padding: EdgeInsets.all(20*factor),
                    child: Center(
                      child: Text('提交认证后请耐心等待审核, 刷新"我的"页面获取最新状态', style: TextStyle(fontSize: 24*factor, color: Colors.grey),),
                    ),
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