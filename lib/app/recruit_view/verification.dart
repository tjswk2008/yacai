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

  @override
  void initState() {
    super.initState();
    setState(() {
      company = widget._company;
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
              padding: EdgeInsets.all(10.0*factor),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Padding(
                    padding: EdgeInsets.only(top: 20*factor, bottom: 10.0*factor),
                    child: new Text(
                      '法人姓名:',
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
                      style: new TextStyle(fontSize: 20.0*factor),
                      onChanged: (val) {
                        setState(() {
                          company.corporator = val;
                        });
                      },
                      decoration: new InputDecoration(
                        hintText: "请输入法人姓名",
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
                    padding: EdgeInsets.only(top: 20*factor, bottom: 10.0*factor),
                    child: new Text(
                      '身份证号码：',
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
                      style: new TextStyle(fontSize: 20.0*factor),
                      onChanged: (val) {
                        setState(() {
                          company.idCard = val;
                        });
                      },
                      decoration: new InputDecoration(
                        hintText: "请输入身份证",
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
                    padding: EdgeInsets.only(top: 20*factor, bottom: 20.0*factor),
                    child: Text(
                      '上传法人身份证:',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 24.0*factor),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          new Padding(
                            padding: EdgeInsets.only(left: 112*factor, right: 122*factor),
                            child: InkWell(
                              onTap: () {
                                ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
                                  return Api().upload(image, '${company.id}_idFront${image.path.substring(image.path.lastIndexOf("."))}');
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
                              ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
                                return Api().upload(image, '${company.id}_idBack${image.path.substring(image.path.lastIndexOf("."))}');
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
                  new Padding(
                    padding: EdgeInsets.only(top: 20*factor, bottom: 20.0*factor),
                    child: new Text(
                      '营业执照:',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 24.0*factor),
                    ),
                  ),
                  new Padding(
                    padding: EdgeInsets.only(left: 112*factor, bottom: 30.0*factor),
                    child: InkWell(
                      onTap: () {
                        ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
                          return Api().upload(image, '${company.id}_license${image.path.substring(image.path.lastIndexOf("."))}');
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
                      child: company.license != null ? Image.network(company.license, width: 192*factor,) : Container(
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
                  
                  new Builder(builder: (ctx) {
                    return new CommonButton(
                      text: "确认",
                      color: new Color.fromARGB(255, 0, 215, 198),
                      onTap: () async {
                        if (isRequesting) return;
                        setState(() {
                          isRequesting = true;
                        });
                        try {
                          Response response = await Api().verification(
                            company.corporator,
                            company.idCard,
                            company.idFront,
                            company.idBack,
                            company.license,
                            company.id
                          );

                          setState(() {
                            isRequesting = false;
                          });
                          if(response.data['code'] != 1) {
                            Scaffold.of(ctx).showSnackBar(new SnackBar(
                              content: new Text("保存失败！"),
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
                      child: Text('提交认证后请耐心等待审核', style: TextStyle(fontSize: 22*factor, color: Colors.grey),),
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