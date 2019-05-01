import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/company.dart';
import 'package:flutter_app/app/component/common_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_app/app/model/constants.dart';
import 'package:flutter_app/app/component/select.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/actions/actions.dart';
import 'package:flutter_app/app/model/app.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_cropper/image_cropper.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

class CompanyEdit extends StatefulWidget {

  final Company _company;
  CompanyEdit(this._company);

  @override
  CompanyEditState createState() => new CompanyEditState();
}

class CompanyEditState extends State<CompanyEdit>
    with TickerProviderStateMixin {

  VoidCallback onChanged;
  Company _company;
  final nameCtrl = new TextEditingController(text: '');
  final addrCtrl = new TextEditingController(text: '');
  bool isRequesting = false;
  String date = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
  String timereq = '不限';
  String academic = '不限';
  String province = '上海市';
  String city = '上海市';
  String area = '徐汇区';
  int start = 1;
  int end = 2;
  Company company;
  String userName;
  List<String> areas = areaArr.sublist(1);
  List<String> employees = employeeArr.sublist(1);
  List<String> companyTypes = companyTypeArr.sublist(1);

  @override
  void initState() {
    super.initState();
    setState(() {
      company = Company.copy(widget._company);
      if (company.imgs == null || company.imgs.length == 0) {
        company.imgs = [{'url': ''}];
      } else if (company.imgs != null && company.imgs[company.imgs.length - 1]['url'] != '') {
        Map<String, String> item = {'url': ''};
        company.imgs.add(item);
      }
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
    return new Scaffold(
        appBar: new AppBar(
          elevation: 0.0,
          leading: IconButton(
            icon: const BackButtonIcon(),
            iconSize: 40*factor,
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: () {
              company = null;
              Navigator.maybePop(context);
            }
          ),
          title: new Text('公司信息',
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
                    '公司名称：',
                    textAlign: TextAlign.left,
                    style: new TextStyle(fontSize: 28.0*factor),
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(bottom: 16.0*factor),
                  child: TypeAheadField(
                    hideOnEmpty: true,
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                          text: company.name,
                          selection: TextSelection.fromPosition(
                            TextPosition(
                              affinity: TextAffinity.downstream,
                              offset: company.name.length
                            )
                          )
                        )
                      ),
                      style: TextStyle(fontSize: 26.0*factor),
                      decoration: new InputDecoration(
                        hintText: "请输入公司名称",
                        hintStyle: new TextStyle(
                            color: const Color(0xFF808080)
                        ),
                        border: new UnderlineInputBorder(
                          borderSide: BorderSide(width: factor)
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
                       company = Company.fromMap(suggestion);
                       if (company.imgs == null || company.imgs.length == 0) {
                          company.imgs = [{'url': ''}];
                        } else if (company.imgs != null && company.imgs[company.imgs.length - 1]['url'] != '') {
                          Map<String, String> item = {'url': ''};
                          company.imgs.add(item);
                        }
                      });
                    },
                  )
                ),
                new Padding(
                  padding: EdgeInsets.only(top:10.0*factor, bottom: 10.0*factor),
                  child: new Text(
                    '公司位置：',
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
                          company.area = res;
                        });
                      },
                      data: areas,
                    );
                  },
                  child: Text((company.province == null || company.province == '') && (company.area == null || company.area == '') ? '请选择地址' : '上海市 ${company.area}', style: TextStyle(fontSize: 26.0*factor, color: Colors.grey),),
                ),
                new Padding(
                  padding: EdgeInsets.only(bottom: 36.0*factor),
                  child: new TextField(
                    style: TextStyle(fontSize: 26.0*factor),
                    controller: TextEditingController.fromValue(
                      TextEditingValue(
                        text: company.location,
                        selection: TextSelection.fromPosition(
                          TextPosition(
                            affinity: TextAffinity.downstream,
                            offset: company.location.length
                          )
                        )
                      )
                    ),
                    onChanged: (val) {
                      setState(() {
                        company.location = val;
                      });
                    },
                    decoration: new InputDecoration(
                      hintText: "请输入详细地址",
                      hintStyle: new TextStyle(
                          color: const Color(0xFF808080)
                      ),
                      border: new UnderlineInputBorder(
                        borderSide: BorderSide(width: factor)
                      ),
                      contentPadding: EdgeInsets.all(10.0*factor)
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.only(top: 20.0*factor, bottom: 10.0*factor),
                      child: new Text(
                        '公司性质：',
                        textAlign: TextAlign.left,
                        style: new TextStyle(fontSize: 28.0*factor),
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
                                company.type =  res;
                              });
                            },
                            data: companyTypes,
                          );
                        },
                        child: new Text(company.type == null || company.type == '' ? '请选择' : company.type, style: TextStyle(fontSize: 26.0*factor),),
                      ) 
                    ),
                  ],
                ),
                new Container(
                  height: 10*factor,
                ),
                new Divider(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.only(top: 20.0*factor, bottom: 10.0*factor),
                      child: new Text(
                        '公司人数：',
                        textAlign: TextAlign.left,
                        style: new TextStyle(fontSize: 28.0*factor),
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
                                company.employee =  res;
                              });
                            },
                            data: employees,
                          );
                        },
                        child: new Text(company.employee == null || company.employee == ''  ? '请选择' : company.employee, style: TextStyle(fontSize: 26.0*factor),),
                      ) 
                    ),
                  ],
                ),
                new Container(
                  height: 10*factor,
                ),
                new Divider(),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Text(
                      '公司logo:',
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
                            maxHeight: 200
                          );
                        }).then((image) {
                          return Api().upload(image, '${userName}_company_logo${image.path.substring(image.path.lastIndexOf("."))}');
                        }).then((Response response) {
                          if(response.data['code'] != 1) {
                            return;
                          }
                          setState(() {
                            company.logo = response.data['imgurl'];
                          });
                        })
                        .catchError((e) {
                          print(e);
                        });
                      },
                      child: company.logo != null ? new CircleAvatar(
                        radius: 45.0*factor,
                        backgroundImage: new NetworkImage(company.logo)
                      ) : Container(
                        width: 90*factor,
                        height: 90*factor,
                        decoration: BoxDecoration(
                          border: Border.all(width: factor),
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(45*factor))
                        ),
                      ),
                    )
                  ],
                ),
                new Container(
                  height: 10*factor,
                ),
                new Divider(),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0*factor),
                      child: new Text(
                        '详情图：',
                        textAlign: TextAlign.left,
                        style: new TextStyle(fontSize: 28.0*factor),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0*factor),
                      child: new Text(
                        '(为了更好地显示效果，请上传16:9的图片)',
                        textAlign: TextAlign.left,
                        style: new TextStyle(fontSize: 24.0*factor, color: Colors.red),
                      ),
                    ),
                  ],
                ),
                GridView.builder(
                  padding: EdgeInsets.all(30.0*factor),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 16 / 9,
                    mainAxisSpacing: 30.0 * factor,
                    crossAxisSpacing: 30.0 * factor,
                  ),
                  itemCount: company.imgs == null ? 1 : (company.imgs.length),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        ImagePicker.pickImage(source: ImageSource.gallery).then((imageFile) {
                          return ImageCropper.cropImage(
                            sourcePath: imageFile.path,
                            ratioX: 0.16,
                            ratioY: 0.09,
                            maxWidth: 384,
                            maxHeight: 216,
                          );
                        }).then((image) {
                          return Api().upload(image, '${userName}_company_detail${DateTime.now().microsecondsSinceEpoch}${image.path.substring(image.path.lastIndexOf("."))}');
                        }).then((Response response) {
                          if(response.data['code'] != 1) {
                            return;
                          }
                          setState(() {
                            if(company.imgs[index]['url'] == '') {
                              Map<String, String> item = {'url': ''};
                              company.imgs.add(item);
                            }
                            // company.imgs[index]['url'] = response.data['imgurl'];
                            company.imgs.replaceRange(index, index+1, [{'id': company.imgs[index]['id'], 'url': response.data['imgurl']}]);
                          });
                        })
                        .catchError((e) {
                          print(e);
                        });
                      },
                      child: company.imgs != null && company.imgs[index]['url'] != '' ? Stack(
                        children: <Widget>[
                          SizedBox.expand(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: factor,
                                  color: Colors.grey
                                )
                              ),
                              child: Image.network(company.imgs[index]['url'], width: 192*factor)
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              child: Icon(Icons.close, size: 45*factor, color: Colors.red,),
                              onTap: () {
                                if (isRequesting) return;
                                String imgName;
                                RegExp exp = new RegExp(r"https:");
                                if (!exp.hasMatch(company.imgs[index]['url'])) {
                                  List<String> nameArr = company.imgs[index]['url'].split('/');
                                  imgName = nameArr[nameArr.length - 1];
                                }
                                showDialog<Null>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return new AlertDialog(
                                      content: Text("确认要删除么？", style: TextStyle(fontSize: 28*factor),),
                                      actions: <Widget>[
                                        new FlatButton(
                                          child: new Text('取消', style: TextStyle(fontSize: 24*factor),),
                                          onPressed: () {
                                              Navigator.of(context).pop();
                                          },
                                        ),
                                        new FlatButton(
                                          child: new Text('确定', style: TextStyle(fontSize: 24*factor, color: Colors.orange),),
                                          onPressed: () {
                                              Navigator.of(context).pop();
                                              setState(() {
                                                isRequesting = true;
                                              });
                                              // 发送给webview，让webview登录后再取回token

                                              Api().deleteImage(company.imgs[index]['id'], imgName)
                                                .then((Response response) {
                                                  if(response.data['code'] != 1) {
                                                    return;
                                                  }
                                                  setState(() {
                                                    company.imgs.removeAt(index);
                                                  });
                                                })
                                                .catchError((e) {
                                                  print(e);
                                                });
                                            },
                                        ),
                                      ],
                                    );
                                  },
                                );
                                
                              },
                            ),
                          )
                        ],
                      ) : Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: factor,
                            color: Colors.grey
                          )
                        ),
                        child: Icon(Icons.add, size: 50*factor)
                      ),
                    );
                  },
                ),
                
                new Container(
                  height: 10*factor,
                ),
                new Divider(),
                
                new Padding(
                  padding: EdgeInsets.only(bottom: 20.0*factor),
                  child: new Text(
                    '详情描述：',
                    textAlign: TextAlign.left,
                    style: new TextStyle(fontSize: 28.0*factor),
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(bottom: 36.0*factor),
                  child: new TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                    style: TextStyle(fontSize: 26.0*factor),
                    controller: TextEditingController.fromValue(
                      TextEditingValue(
                        text: company.inc,
                        selection: TextSelection.fromPosition(
                          TextPosition(
                            affinity: TextAffinity.downstream,
                            offset: company.inc.length
                          )
                        )
                      )
                    ),
                    onChanged: (val) {
                      setState(() {
                        company.inc = val;
                      });
                    },
                    decoration: new InputDecoration(
                      hintText: "请输入详情描述",
                      hintStyle: new TextStyle(
                          color: const Color(0xFF808080)
                      ),
                      border: new OutlineInputBorder(
                        borderSide: BorderSide(width: 1.0*factor),
                        borderRadius: BorderRadius.all(Radius.circular(6*factor))
                      ),
                      contentPadding: EdgeInsets.all(15.0*factor)
                    ),
                  ),
                ),
                
                new Container(
                  height: 36*factor,
                ),
                new Builder(builder: (ctx) {
                  return new CommonButton(
                    text: "保存",
                    color: new Color.fromARGB(255, 0, 215, 198),
                    onTap: () async {
                      if (isRequesting) return;
                      setState(() {
                        isRequesting = true;
                      });
                      try {
                        Response response = await Api().saveCompanyInfo(
                          company.name,
                          '上海市',
                          '上海市',
                          company.area,
                          company.location,
                          company.type,
                          company.employee,
                          company.inc,
                          company.logo,
                          company.imgs.sublist(0, company.imgs.length - 1),
                          userName,
                          company.id
                        );

                        setState(() {
                          isRequesting = false;
                        });
                        if(response.data['code'] != 1) {
                          if(response.data['code'] == -20) {
                            Scaffold.of(ctx).showSnackBar(new SnackBar(
                              content: new Text(response.data['msg']),
                            ));
                            return;
                          }
                          Scaffold.of(ctx).showSnackBar(new SnackBar(
                            content: new Text("保存失败！"),
                          ));
                          return;
                        }
                        company.id = response.data['info']['id'];
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
                })
              ],
            ),
          )
        )
    );
  }
}