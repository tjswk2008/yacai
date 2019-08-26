import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
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
import 'package:flutter_app/util/util.dart';
import 'package:flutter_app/app/component/text_area.dart';

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
    YaCaiUtil.getInstance().init(context);
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
            padding: EdgeInsets.all(50.0*factor),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(bottom: 10.0*factor),
                  child: new Text(
                    '公司名称：',
                    textAlign: TextAlign.left,
                    style: new TextStyle(fontSize: 32.0*factor),
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(bottom: 0*factor),
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
                          ),
                        )
                      ),
                      style: TextStyle(fontSize: 26.0*factor),
                      onSubmitted: (val) async {
                        Response response = await Api().getCompanySuggestions('');
                        List companyMaps = response.data;
                        int index = companyMaps.indexWhere((element) => element['name'] == val);
                        if(index !=null && index >= 0) {
                          setState(() {
                            company = Company.fromMap(companyMaps[index]);
                            if (company.imgs == null || company.imgs.length == 0) {
                              company.imgs = [{'url': ''}];
                            } else if (company.imgs != null && company.imgs[company.imgs.length - 1]['url'] != '') {
                              Map<String, String> item = {'url': ''};
                              company.imgs.add(item);
                            }
                          });
                        } else {
                          setState(() {
                            company.name = val;
                            company.id = null;
                            company.imgs = [{'url': ''}];
                            company.logo = null;
                          });
                        }
                      },
                      decoration: new InputDecoration(
                        hintText: "请输入公司名称",
                        hintStyle: new TextStyle(
                            color: const Color(0xFF808080)
                        ),
                        border: prefix0.InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 30.0*factor)
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
                prefix0.Divider(),
                new Padding(
                  padding: EdgeInsets.only(top:30.0*factor, bottom: 30.0*factor),
                  child: new Text(
                    '公司位置：',
                    textAlign: TextAlign.left,
                    style: new TextStyle(fontSize: 32.0*factor),
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
                  child: Text((company.province == null || company.province == '') && (company.area == null || company.area == '') ? '请选择地址' : '上海市 ${company.area}', style: TextStyle(fontSize: 26.0*factor, color: Colors.grey[800]),),
                ),
                new Padding(
                  padding: EdgeInsets.only(top: 10*factor, bottom: 16.0*factor),
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
                      border: prefix0.InputBorder.none,
                      contentPadding: EdgeInsets.only(top: 15*factor, bottom: 20.0*factor)
                    ),
                  ),
                ),
                prefix0.Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.only(top: 30.0*factor, bottom: 20.0*factor),
                      child: new Text(
                        '公司性质：',
                        textAlign: TextAlign.left,
                        style: new TextStyle(fontSize: 32.0*factor),
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(
                        top: 20.0*factor,
                        bottom: 10.0*factor,
                        left: 10.0*factor,
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
                      padding: EdgeInsets.only(top: 30.0*factor, bottom: 20.0*factor),
                      child: new Text(
                        '公司人数：',
                        textAlign: TextAlign.left,
                        style: new TextStyle(fontSize: 32.0*factor),
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(
                        top: 20.0*factor,
                        bottom: 10.0*factor,
                        left: 10.0*factor,
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
                    new Padding(
                      padding: EdgeInsets.only(top: 30.0*factor, bottom: 20.0*factor),
                      child: new Text(
                        '公司logo:',
                        textAlign: TextAlign.left,
                        style: new TextStyle(fontSize: 32.0*factor),
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(
                        top: 20.0*factor,
                        bottom: 10.0*factor,
                        left: 10.0*factor,
                      ),
                      child: new InkWell(
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
                            return Api().upload(image, '${userName}_company_logo${DateTime.now().microsecondsSinceEpoch}${image.path.substring(image.path.lastIndexOf("."))}');
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
                      padding: EdgeInsets.only(top: 30*factor, bottom: 30.0*factor),
                      child: new Text(
                        '详情图：',
                        textAlign: TextAlign.left,
                        style: new TextStyle(fontSize: 32.0*factor),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30*factor, bottom: 30.0*factor),
                      child: new Text(
                        '(为了更好地显示效果，请上传16:9的图片)',
                        textAlign: TextAlign.left,
                        style: new TextStyle(fontSize: 26.0*factor, color: Colors.red),
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
                                setState(() {
                                  company.imgs.removeAt(index);
                                });
                                
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
                  padding: EdgeInsets.only(top: 30*factor, bottom: 30.0*factor),
                  child: new Text(
                    '详情描述：',
                    textAlign: TextAlign.left,
                    style: new TextStyle(fontSize: 32.0*factor),
                  ),
                ),
                TextArea(
                  text: company.inc,
                  callback: (String val) {
                    setState(() {
                      company.inc = val;
                    });
                  },
                ),
                prefix0.Divider(),
                prefix0.Container(height: 60*factor,)
              ],
            ),
          )
        ),
        floatingActionButton: prefix0.FloatingActionButton(
          mini: true,
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(
            Icons.check,
            size: 50.0*factor,
            color: Colors.white,
          ),
          onPressed: () async {
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
                  YaCaiUtil.getInstance().showMsg(response.data['msg']);
                  return;
                }
                YaCaiUtil.getInstance().showMsg("保存失败！");
                return;
              }
              if(response.data['info']['id'] != null) {
                company.id = response.data['info']['id'];
                company.verified = null;
                company.idBack = null;
                company.idFront = null;
                company.license = null;
                company.willing = null;
                company.corporator = null;
                company.idCard = null;
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
        ),

    );
  }
}