import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/company.dart';
import 'package:flutter_app/app/component/common_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_app/app/model/constants.dart';
import 'package:flutter_app/app/component/city.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/actions/actions.dart';
import 'package:flutter_app/app/model/app.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

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

  @override
  void initState() {
    super.initState();
    setState(() {
      company = widget._company;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget companyTypeOption(BuildContext context, int index) {
    double factor = MediaQuery.of(context).size.width/750;
    return new InkWell(
      onTap: () {
        setState(() {
          company.type =  companyTypeArr[index];
        });
      },
      child: new Container(
        height: 40*factor,
        width: 140*factor,
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.all(new Radius.circular(6*factor)),
          border: company.type == companyTypeArr[index] ? new Border.all(
            color: const Color(0xffaaaaaa),
            width: 2*factor
          ) : Border(),
        ),
        child: new Center(
          child: new Text(companyTypeArr[index], style: TextStyle(fontSize: 22.0*factor),),
        ),
      ),
    );
  }

  Widget employeeOption(BuildContext context, int index) {
    double factor = MediaQuery.of(context).size.width/750;
    return new InkWell(
      onTap: () {
        setState(() {
          company.employee =  employeeArr[index];
        });
      },
      child: new Container(
        height: 40*factor,
        width: 170*factor,
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.all(new Radius.circular(6*factor)),
          border: company.employee == employeeArr[index] ? new Border.all(
            color: const Color(0xffaaaaaa),
            width: 2*factor
          ) : Border(),
        ),
        child: new Center(
          child: new Text(employeeArr[index], style: TextStyle(fontSize: 22.0*factor),),
        ),
      ),
    );
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
                    style: new TextStyle(fontSize: 26.0*factor),
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(bottom: 16.0*factor),
                  child: TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                      autofocus: true,
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
                      style: TextStyle(fontSize: 20.0*factor),
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
                       company.name = suggestion['name'];
                      });
                    },
                  )
                ),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Text(
                      '公司logo:',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 24.0*factor),
                    ),

                    new InkWell(
                      onTap: () {
                        ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
                          return Api().upload(image, '${company.id}_company_logo${image.path.substring(image.path.lastIndexOf("."))}');
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
                new Padding(
                  padding: EdgeInsets.only(bottom: 10.0*factor),
                  child: new Text(
                    '公司位置：',
                    textAlign: TextAlign.left,
                    style: new TextStyle(fontSize: 26.0*factor),
                  ),
                ),
                new InkWell(
                  onTap: () {
                    CityPicker.showCityPicker(
                      context,
                      selectProvince: (prov) {
                        setState(() {
                         company.province = prov['name']; 
                        });
                      },
                      selectCity: (res) {
                        setState(() {
                         company.city = res['name']; 
                        });
                      },
                      selectArea: (res) {
                        setState(() {
                          if(res['name'] == '全部') {
                            company.area = '';
                          } else {
                            company.area = res['name'];
                          }
                        });
                      },
                    );
                  },
                  child: Text(company.province == null ? '请选择地址' : '${company.province} ${company.city} ${company.area}', style: TextStyle(fontSize: 22.0*factor, color: Colors.grey),),
                ),
                new Padding(
                  padding: EdgeInsets.only(bottom: 36.0*factor),
                  child: new TextField(
                    style: TextStyle(fontSize: 20.0*factor),
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
                new Padding(
                  padding: EdgeInsets.only(bottom: 10.0*factor),
                  child: new Text(
                    '公司性质：',
                    textAlign: TextAlign.left,
                    style: new TextStyle(fontSize: 26.0*factor),
                  ),
                ),
                new Container(
                  height: 60*factor,
                  child: new ListView.builder(
                    shrinkWrap: true,
                    itemCount: companyTypeArr.length,
                    itemBuilder: companyTypeOption,
                    scrollDirection: Axis.horizontal,
                    physics: const ClampingScrollPhysics(),
                  ),
                ),
                new Container(
                  height: 10*factor,
                ),
                new Divider(),

                new Padding(
                  padding: EdgeInsets.only(bottom: 10.0*factor),
                  child: new Text(
                    '公司人数：',
                    textAlign: TextAlign.left,
                    style: new TextStyle(fontSize: 26.0*factor),
                  ),
                ),
                new Container(
                  height: 60*factor,
                  child: new ListView.builder(
                    shrinkWrap: true,
                    itemCount: employeeArr.length,
                    itemBuilder: employeeOption,
                    scrollDirection: Axis.horizontal,
                    physics: const ClampingScrollPhysics(),
                  ),
                ),
                new Container(
                  height: 10*factor,
                ),
                new Divider(),
                
                new Padding(
                  padding: EdgeInsets.only(bottom: 10.0*factor),
                  child: new Text(
                    '详情描述：',
                    textAlign: TextAlign.left,
                    style: new TextStyle(fontSize: 26.0*factor),
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(bottom: 36.0*factor),
                  child: new TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                    style: TextStyle(fontSize: 24.0*factor),
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
                        SharedPreferences prefs = await SharedPreferences.getInstance();

                        Response response = await Api().saveCompanyInfo(
                          company.name,
                          company.province,
                          company.city,
                          company.area,
                          company.location,
                          company.type,
                          company.employee,
                          company.inc,
                          company.logo,
                          prefs.getString('userName'),
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