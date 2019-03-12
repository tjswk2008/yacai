import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/company.dart';
import 'package:flutter_app/app/model/job.dart';
import 'package:flutter_app/app/view/company/company_info.dart';
import 'package:flutter_app/app/component/common_button.dart';
import 'package:flutter_app/app/view/company/company_edit.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_app/app/model/constants.dart';
import 'package:flutter_app/app/component/city.dart';
import 'package:flutter_app/app/component/salary.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/app/model/app.dart';
import 'package:custom_radio/custom_radio.dart';
import 'package:flutter_app/actions/actions.dart';

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
  final detailCtrl = new TextEditingController(text: '');
  final addrCtrl = new TextEditingController(text: '');
  bool isRequesting = false;
  String date = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
  String timereq = '不限';
  String academic = '不限';
  String province = '上海市';
  String city = '上海市';
  String area = '黄浦区';
  String salary = '2千以下';
  int type = 1; // 工作类型

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
        width: 120*factor,
        decoration: BoxDecoration(
          border: (index == 0 && timereq == '不限') || (index > 0 && timereq == timeReqArr[index - 1].toString() + '年') ? new Border.all(
            color: const Color(0xffaaaaaa),
            width: 2*factor
          ) : Border(),
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
        width: 120*factor,
        decoration: BoxDecoration(
          border: (index == 0 && academic == '不限') || (index > 0 && academic == academicArr[index - 1]) ? new Border.all(
            color: const Color(0xffaaaaaa),
            width: 2*factor
          ) : Border(),
        ),
        child: new Center(
          child: new Text(index == 0 ? '不限' : academicArr[index - 1], style: TextStyle(fontSize: 22.0*factor),),
        ),
      ),
    );
  }

  Widget salaryOption(BuildContext context, int index) {
    double factor = MediaQuery.of(context).size.width/750;
    return new InkWell(
      onTap: () {
        setState(() {
          salary =  salaryArr[index];
        });
      },
      child: new Container(
        height: 40*factor,
        width: 120*factor,
        decoration: BoxDecoration(
          border: salary == salaryArr[index] ? new Border.all(
            color: const Color(0xffaaaaaa),
            width: 2*factor
          ) : Border(),
        ),
        child: new Center(
          child: new Text(salaryArr[index], style: TextStyle(fontSize: 22.0*factor),),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
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
                  new Padding(
                    padding: EdgeInsets.only(bottom: 10.0*factor),
                    child: new Text(
                      '工作类型：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 26.0*factor),
                    ),
                  ),
                  
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          CustomRadio<int, dynamic>(
                            value: 1,
                            groupValue: type,
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
                            builder: (BuildContext context, List<dynamic> animValues, Function updateState, int value) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    type = value;
                                  });
                                },
                                child: Container(
                                  width: 24.0*factor,
                                  height: 24.0*factor,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(10.0*factor),
                                  padding: EdgeInsets.all(3.0*factor),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: type == value ? Colors.cyan[300] : Colors.grey[600],
                                      width: 1.0*factor
                                    )
                                  ),
                                  child: type == value ? Container(
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
                          new Text('全职', style: new TextStyle(fontSize: 24.0*factor),),
                        ]
                      ),
                      new Row(
                        children: <Widget>[
                          CustomRadio<int, dynamic>(
                            value: 2,
                            groupValue: type,
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
                            builder: (BuildContext context, List<dynamic> animValues, Function updateState, int value) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    type = value;
                                  });
                                },
                                child: Container(
                                  width: 24.0*factor,
                                  height: 24.0*factor,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(10.0*factor),
                                  padding: EdgeInsets.all(3.0*factor),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: type == value ? Colors.cyan[300] : Colors.grey[600],
                                      width: 1.0*factor
                                    )
                                  ),
                                  child: type == value ? Container(
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
                          new Text('兼职', style: new TextStyle(fontSize: 24.0*factor),),
                        ]
                      ),
                      new Row(
                        children: <Widget>[
                          CustomRadio<int, dynamic>(
                            value: 3,
                            groupValue: type,
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
                            builder: (BuildContext context, List<dynamic> animValues, Function updateState, int value) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    type = value;
                                  });
                                },
                                child: Container(
                                  width: 24.0*factor,
                                  height: 24.0*factor,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(10.0*factor),
                                  padding: EdgeInsets.all(3.0*factor),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: type == value ? Colors.cyan[300] : Colors.grey[600],
                                      width: 1.0*factor
                                    )
                                  ),
                                  child: type == value ? Container(
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
                          new Text('实习', style: new TextStyle(fontSize: 24.0*factor),),
                        ],
                      )
                    ],
                  ),
                  new Divider(),
                  new Padding(
                    padding: EdgeInsets.only(bottom: 10.0*factor),
                    child: new Text(
                      '薪资待遇：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 26.0*factor),
                    ),
                  ),
                  new Container(
                    height: 60*factor,
                    child: new ListView.builder(
                      shrinkWrap: true,
                      itemCount: salaryArr.length,
                      itemBuilder: salaryOption,
                      scrollDirection: Axis.horizontal,
                      physics: const ClampingScrollPhysics(),
                    ),
                  ),
                  new Container(
                    height: 10*factor,
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
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Text('公司', style: TextStyle(fontSize: 22.0*factor),),
                        new InkWell(
                          onTap: () {
                            navCompanyEdit();
                          },
                          child: new Row(
                            children: <Widget>[
                              new Text(state.company.name != '' ? state.company.name : '请填写公司信息', style: TextStyle(fontSize: 22.0*factor),),
                              new Icon(Icons.chevron_right, size: 30.0*factor,),
                            ],
                          ),
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
                    controller: detailCtrl,
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
                      onTap: () async {
                        if (isRequesting) return;
                        setState(() {
                          isRequesting = true;
                        });
                        try {
                          Response response = await Api().saveJobs(
                            nameCtrl.text.trim(),
                            state.company.name,
                            salary,
                            province,
                            city,
                            area,
                            addrCtrl.text.trim(),
                            timereq,
                            academic,
                            detailCtrl.text.trim(),
                            type,
                            state.company.id,
                            state.userName,
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
                          Response resList = await Api().getRecruitJobList(state.userName);
                          StoreProvider.of<AppState>(context).dispatch(SetJobsAction(Job.fromJson(resList.data['list'])));
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
    );
  }

  navCompanyEdit() {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          Company company = StoreProvider.of<AppState>(context).state.company;
          return new CompanyEdit(company);
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