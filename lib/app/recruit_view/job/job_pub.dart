import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/company.dart';
import 'package:flutter_app/app/model/job.dart';
import 'package:flutter_app/app/view/company/company_info.dart';
import 'package:flutter_app/app/component/common_button.dart';
import 'package:flutter_app/app/view/company/company_detail.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:date_format/date_format.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          elevation: 0.0,
          title: new Text('发布职位',
              style: new TextStyle(fontSize: 20.0, color: Colors.white)),
        ),
        body: new SingleChildScrollView(
          child: new Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: new Text(
                    '职位名称：',
                    textAlign: TextAlign.left,
                    style: new TextStyle(fontSize: 18.0),
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: new TextField(
                    controller: nameCtrl,
                    decoration: new InputDecoration(
                      hintText: "请输入职位名称",
                      hintStyle: new TextStyle(
                          color: const Color(0xFF808080)
                      ),
                      border: new UnderlineInputBorder(),
                      contentPadding: const EdgeInsets.all(10.0)
                    ),
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: new Text(
                    '薪资待遇：',
                    textAlign: TextAlign.left,
                    style: new TextStyle(fontSize: 18.0),
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: new TextField(
                    controller: salaryCtrl,
                    decoration: new InputDecoration(
                      hintText: "请输入薪资待遇",
                      hintStyle: new TextStyle(
                          color: const Color(0xFF808080)
                      ),
                      border: new UnderlineInputBorder(),
                      contentPadding: const EdgeInsets.all(10.0)
                    ),
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: new Text(
                    '工作地点：',
                    textAlign: TextAlign.left,
                    style: new TextStyle(fontSize: 18.0),
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: new TextField(
                    controller: addrCtrl,
                    decoration: new InputDecoration(
                      hintText: "请输入工作地点",
                      hintStyle: new TextStyle(
                          color: const Color(0xFF808080)
                      ),
                      border: new UnderlineInputBorder(),
                      contentPadding: const EdgeInsets.all(10.0)
                    ),
                  ),
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Text(
                      '颁发时间：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 18.0),
                    ),

                    new InkWell(
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.parse('1900-01-01'), // 减 30 天
                          lastDate: new DateTime.now().add(new Duration(days: 30)),       // 加 30 天
                        ).then((DateTime val) {
                          setState(() {
                            date = formatDate(val, [yyyy, '-', mm, '-', dd]);
                          });
                        }).catchError((err) {
                          print(err);
                        });
                      },
                      child: new Text(date),
                    )
                  ],
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