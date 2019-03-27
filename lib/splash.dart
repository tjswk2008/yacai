import 'package:flutter/material.dart';
import 'package:flutter_app/app/view/register_view.dart';
import 'package:dio/dio.dart';
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
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashPage extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<SplashPage> {

  // Timer _t;
  bool isRequesting = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  @override
  void dispose() {
    // _t.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidthInPt = MediaQuery.of(context).size.width;
    return new Material(
      color: new Color.fromARGB(255, 0, 215, 198),
      child: Stack(
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new Text("丫财",
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 60.0*screenWidthInPt/750,
                  fontWeight: FontWeight.bold
                ),
              ),
              new Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new Padding(
                    padding: EdgeInsets.only(
                      left: 65.0*screenWidthInPt/750,
                      right: 65.0*screenWidthInPt/750,
                      bottom: 40.0*screenWidthInPt/750
                    ),
                    child: new InkWell(
                      onTap: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setInt('role', 2);
                        Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(
                          builder: (BuildContext context) => new RegisterPage()), (
                          Route route) => route == null);
                      },
                      child: new Container(
                        height: 70.0*screenWidthInPt/750,
                        decoration: new BoxDecoration(
                          border: new Border.all(color: Colors.orange[50], width: 2.0*screenWidthInPt/750),
                          borderRadius: new BorderRadius.all(new Radius.circular(6.0*screenWidthInPt/750))
                        ),
                        child: new Center(
                          child: new Text('我是招聘者', style: new TextStyle(color: Colors.white, fontSize: 26.0*screenWidthInPt/750),),
                        ),
                      ),
                    ),
                  ),
                  new Padding(
                    padding: EdgeInsets.only(
                      left: 65.0*screenWidthInPt/750,
                      right: 65.0*screenWidthInPt/750,
                    ),
                    child: new InkWell(
                      onTap: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setInt('role', 1);
                        Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(
                          builder: (BuildContext context) => new RegisterPage()), (
                          Route route) => route == null);
                      },
                      child: new Container(
                        height: 70.0*screenWidthInPt/750,
                        decoration: new BoxDecoration(
                          border: new Border.all(color: Colors.orange[50], width: 2.0*screenWidthInPt/750),
                          borderRadius: new BorderRadius.all(new Radius.circular(6.0*screenWidthInPt/750))
                        ),
                        child: new Center(
                          child: new Text('我是求职者', style: new TextStyle(color: Colors.white, fontSize: 26.0*screenWidthInPt/750),),
                        ),
                      ),
                    ),
                  )
                ]
              )
            ],
          ),
          isRequesting ? Positioned(
            left: 0,
            top: 0,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Color.fromARGB(190, 0, 0, 0)
              ),
            ),
          ) : Container(),
          Positioned(
            left: 0,
            top: 0,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SpinKitHourGlass(
              color: Theme.of(context).primaryColor,
              size: 50*screenWidthInPt/750,
              duration: Duration(milliseconds: 1800),
            ),
          )
        ]
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
      Response response = await Api().login(username, null);;
    
      if (role == 1) {
        Response resumeResponse = await Api().getUserInfo(response.data['id']);
        Resume resume = Resume.fromMap(resumeResponse.data['info']);
        StoreProvider.of<AppState>(context).dispatch(SetResumeAction(resume));
      } else {
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
    }
  }
}