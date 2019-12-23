import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/role.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/app/model/app.dart';
import 'package:flutter_app/actions/actions.dart';
import 'package:flutter_app/app/model/job.dart';
import 'package:flutter_app/app/model/company.dart';
import 'package:flutter_app/home.dart';
import 'package:flutter_app/recruit.dart';
import 'package:dio/dio.dart';

class SplashPage extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<SplashPage> {

  Timer _t;
  bool isRequesting = false;

  @override
  void initState() {
    super.initState();
    _t = new Timer(const Duration(milliseconds: 1500), () {
      try {
        checkLoginStatus();
      } catch (e) {

      }
    });
  }

  @override
  void dispose() {
    _t.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return new Material(
      // color: new Color.fromARGB(255, 0, 215, 198),
      child: new Stack(
        children: <Widget>[
          // Positioned.fill(
          //   child: new Container(
          //     height: double.infinity,
          //     width: double.infinity,
          //     decoration: BoxDecoration(
          //       gradient: LinearGradient(
          //         begin: Alignment(0.0, -1.0),
          //         end: Alignment(0.0, 1.0),
          //         colors: <Color>[
          //           Color.fromRGBO(150, 210, 249, 1),
          //           Color.fromRGBO(90, 169, 226, 1)
          //         ],
          //       ),
          //     ),
          //   )
          // ),
          // Positioned(
          //   // top: 325*factor,
          //   bottom: 462*factor,
          //   left: 166*factor,
          //   child: new Image.asset(
          //     'assets/images/duck.png',
          //     width: 406*factor,
          //     height: 579*factor,
          //   ),
          // ),
          Positioned(
            bottom: 705*factor, //1131
            left: 182*factor,
            child: new Image.asset(
              'assets/images/title.png',
              width: 391*factor,
              height: 298*factor,
            ),
          ),
          Positioned(
            bottom: 0, //1310
            left: 0,
            child: new Image.asset(
              'assets/images/s-bottom.png',
              width: 745*factor,
              height: 741*factor,
            )
          ),
        ],
      )
      
    );
  }

  checkLoginStatus() async {
    setState(() {
      isRequesting = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int role = prefs.getInt('role');
    String username = prefs.getString('userName');
    if (username != '' && username != null) {
      Response response = await Api().login(username, null);
      prefs.setInt('userId', response.data['id']);
      if (role == 1) {
        Response resumeResponse = await Api().getUserInfo(response.data['id'], null);
        Resume resume = Resume.fromMap(resumeResponse.data['info']);
        StoreProvider.of<AppState>(context).dispatch(SetResumeAction(resume));
      } else {
        // role == 2
        List<Response> resList = await Future.wait([Api().getCompanyInfo(response.data['id']), Api().getRecruitJobList(username)]);
        StoreProvider.of<AppState>(context).dispatch(SetJobsAction(Job.fromJson(resList[1].data['list'])));
        Company company;
        if (resList[0].data['info'] == null) {
          company = new Company(
            name: '', // 公司名称
            location: '', // 公司位置
            type: '', // 公司性质
            size: '', // 公司规模
            employee: '', // 公司人数
            inc: '',
          );
        } else {
          company = Company.fromMap(resList[0].data['info']);
        }
        StoreProvider.of<AppState>(context).dispatch(SetCompanyAction(company));
      }

      setState(() {
        isRequesting = false;
      });

      Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(
        builder: (BuildContext context) => role == 1 ? new BossApp() : new Recruit()), (
        Route route) => route == null);
    } else {
      setState(() {
        isRequesting = false;
      });
      Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(
        builder: (BuildContext context) => new RolePage()), (
        Route route) => route == null);
    }
  }
}