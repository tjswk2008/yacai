import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/company.dart';
import 'package:flutter_app/app/model/job.dart';
import 'package:flutter_app/app/view/company/company_info.dart';
import 'package:flutter_app/app/component/common_button.dart';
import 'package:flutter_app/app/view/company/company_detail.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_app/app/model/constants.dart';
import 'package:flutter_app/app/component/city.dart';
import 'package:flutter_app/app/component/salary.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

class PubJob extends StatefulWidget {

  PubJob();

  @override
  PubJobState createState() => new PubJobState();
}

class PubJobState extends State<PubJob>
    with TickerProviderStateMixin {

  VoidCallback onChanged;
  Company _company;
  final nameCtrl = new TextEditingController(text: '');
  final salaryCtrl = new TextEditingController(text: '');
  final addrCtrl = new TextEditingController(text: '');
  bool isRequesting = false;
  String date = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
  String timereq = '不限';
  String academic = '不限';
  String province = '上海市';
  String city = '上海市';
  String area = '黄浦区';
  int start = 1;
  int end = 2;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget timeReqOption(BuildContext context, int index) {
    double factor = MediaQuery.of(context).size.width/750;
    return new InkWell(
      onTap: () {
        setState(() {
          timereq =  index == 0 ? '不限' : timeReqArr[index - 1].toString() + '年';
        });
      },
      child: new Container(
        height: 40*factor,
        width: 108*factor,
        decoration: BoxDecoration(
          border: new Border.all(
            color: (index == 0 && timereq == '不限') || (index > 0 && timereq == timeReqArr[index - 1].toString() + '年') ? const Color(0xffaaaaaa) : const Color(0xffffffff),
            width: 2*factor
          ),
        ),
        child: new Center(
          child: new Text(index == 0 ? '不限' : timeReqArr[index - 1].toString() + '年', style: TextStyle(fontSize: 22.0*factor),),
        ),
      ),
    );
  }

  Widget academicOption(BuildContext context, int index) {
    double factor = MediaQuery.of(context).size.width/750;
    return new InkWell(
      onTap: () {
        setState(() {
          academic =  index == 0 ? '不限' : academicArr[index - 1];
        });
      },
      child: new Container(
        height: 40*factor,
        width: 108*factor,
        decoration: BoxDecoration(
          border: new Border.all(
            color: (index == 0 && academic == '不限') || (index > 0 && academic == academicArr[index - 1]) ? const Color(0xffaaaaaa) : const Color(0xffffffff),
            width: 2*factor
          ),
        ),
        child: new Center(
          child: new Text(index == 0 ? '不限' : academicArr[index - 1], style: TextStyle(fontSize: 22.0*factor),),
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
          title: new Text('发布职位',
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
                    '职位名称：',
                    textAlign: TextAlign.left,
                    style: new TextStyle(fontSize: 26.0*factor),
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(bottom: 36.0*factor),
                  child: new TextField(
                    controller: nameCtrl,
                    style: TextStyle(fontSize: 22*factor),
                    decoration: new InputDecoration(
                      hintText: "请输入职位名称",
                      hintStyle: new TextStyle(
                          color: const Color(0xFF808080)
                      ),
                      border: new UnderlineInputBorder(
                        borderSide: BorderSide(width: 1.0*factor)
                      ),
                      contentPadding: EdgeInsets.all(10.0*factor)
                    ),
                  ),
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text(
                      '薪资待遇：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 26.0*factor),
                    ),
                    new InkWell(
                      onTap: () {
                        SalaryPicker.showSalaryPicker(
                          context,
                          selectStart: (prov) {
                            setState(() {
                              start = prov; 
                            });
                          },
                          selectEnd: (res) {
                            setState(() {
                              end = res; 
                            });
                          }
                        );
                      },
                      child: Text('${start}K ~ ${end}K', style: TextStyle(fontSize: 24.0*factor),),
                    ),
                  ],
                ),
                new Padding(
                  padding: EdgeInsets.only(bottom: 16.0*factor)
                ),
                new Divider(),
                new Padding(
                  padding: EdgeInsets.only(bottom: 10.0*factor),
                  child: new Text(
                    '工作地点：',
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
                         province = prov['name']; 
                        });
                      },
                      selectCity: (res) {
                        setState(() {
                         city = res['name']; 
                        });
                      },
                      selectArea: (res) {
                        setState(() {
                         area = res['name']; 
                        });
                      },
                    );
                  },
                  child: Text('$province $city $area', style: TextStyle(fontSize: 22.0*factor, color: Colors.grey),),
                ),
                new Padding(
                  padding: EdgeInsets.only(bottom: 36.0*factor),
                  child: new TextField(
                    controller: addrCtrl,
                    style: TextStyle(fontSize: 22*factor),
                    decoration: new InputDecoration(
                      hintText: "请输入详细地址",
                      hintStyle: new TextStyle(
                          color: const Color(0xFF808080)
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
                    '工作年限：',
                    textAlign: TextAlign.left,
                    style: new TextStyle(fontSize: 26.0*factor),
                  ),
                ),
                new Container(
                  height: 60*factor,
                  child: new ListView.builder(
                    shrinkWrap: true,
                    itemCount: timeReqArr.length + 1,
                    itemBuilder: timeReqOption,
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
                    '学历要求：',
                    textAlign: TextAlign.left,
                    style: new TextStyle(fontSize: 26.0*factor),
                  ),
                ),
                new Container(
                  height: 60*factor,
                  child: new ListView.builder(
                    shrinkWrap: true,
                    itemCount: academicArr.length + 1,
                    itemBuilder: academicOption,
                    scrollDirection: Axis.horizontal,
                    physics: const ClampingScrollPhysics(),
                  ),
                ),
                new Container(
                  height: 10*factor,
                ),
                new Divider(),
                new Container(
                  height: 50.0*factor,
                  margin: EdgeInsets.only(bottom: 10.0*factor),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                  ),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Text('公司', style: TextStyle(fontSize: 22.0*factor),),
                      new Row(
                        children: <Widget>[
                          new Text('上海容易网电子商务股份有限公司', style: TextStyle(fontSize: 22.0*factor),),
                          new Icon(Icons.chevron_right, size: 30.0*factor,),
                        ],
                      )
                    ],
                  ),
                ),
                Divider(),
                new Padding(
                  padding: EdgeInsets.only(bottom: 10.0*factor),
                  child: new Text(
                    '职位描述：',
                    textAlign: TextAlign.left,
                    style: new TextStyle(fontSize: 26.0*factor),
                  ),
                ),
                new TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                  style:TextStyle(fontSize: 24.0*factor),
                  decoration: new InputDecoration(
                    hintText: "请输入",
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
                new Container(
                  height: 36*factor,
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
                    }
                  );
                })
              ],
            ),
          )
        )
    );
  }

  navCompanyDetail(Company company) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new CompanyDetail(company);
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
  }
}