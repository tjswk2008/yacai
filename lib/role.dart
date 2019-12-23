import 'package:flutter/material.dart';
// import 'package:flutter_app/app/view/register_view.dart';
import 'package:flutter_app/app/view/login_view.dart';
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
// import 'package:fluwx/fluwx.dart' as fluwx;

class RolePage extends StatefulWidget {
  @override
  RoleState createState() => new RoleState();
}

class RoleState extends State<RolePage> {

  // Timer _t;
  bool isRequesting = false;

  @override
  void initState() {
    super.initState();
    // fluwx.register(appId: "wx9d615d9c0472c7f4");
    checkLoginStatus();
  }

  @override
  void dispose() {
    // _t.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return new Material(
      // color: new Color.fromARGB(255, 0, 215, 198),
      color: Theme.of(context).primaryColor,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 276*factor,
            top: 289*factor,
            width: 199*factor,
            height: 199*factor,
            child: new Container(
              height: 199*factor,
              width: 199*factor,
              decoration: new BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: new Color(0xFF593b51),
                    offset: Offset(4.0*factor, 10.0*factor),
                    blurRadius: 10.0*factor
                  )
                ],
              ),
              child: new Image.asset(
                'assets/images/logo.png',
                width: 199*factor,
                height: 199*factor,
              ),
            )
          ),
          Positioned(
            left: 0,
            bottom: 426*factor,
            width: MediaQuery.of(context).size.width,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                // new Text("丫财",
                //   style: new TextStyle(
                //     color: Colors.white,
                //     fontSize: 60.0*factor,
                //     fontWeight: FontWeight.bold
                //   ),
                // ),
                new Column(
                  children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.only(
                        left: 83.0*factor,
                        right: 83.0*factor,
                        bottom: 47.0*factor
                      ),
                      child: new InkWell(
                        onTap: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setInt('role', 2);
                          Navigator.of(context).push(new PageRouteBuilder(
                              opaque: false,
                              pageBuilder: (BuildContext context, _, __) {
                                return new NewLoginPage();
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
                        child: new Container(
                          height: 66.0*factor,
                          decoration: new BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: new Color(0xFF593b51),
                                offset: Offset(4.0*factor, 10.0*factor),
                                blurRadius: 10.0*factor
                              )
                            ],
                            // border: new Border.all(color: Colors.orange[50], width: 2.0*factor),
                            borderRadius: new BorderRadius.all(new Radius.circular(6.0*factor))
                          ),
                          child: new Center(
                            child: new Text('我是招聘者', style: new TextStyle(color: Color(0xFF5d5d5d), fontSize: 28.0*factor),),
                          ),
                        ),
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(
                        left: 83.0*factor,
                        right: 83.0*factor,
                      ),
                      child: new InkWell(
                        onTap: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setInt('role', 1);
                          Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(
                            builder: (BuildContext context) => new NewLoginPage()), (
                            Route route) => route == null);
                        },
                        child: new Container(
                          height: 66.0*factor,
                          decoration: new BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: new Color(0xFF593b51),
                                offset: Offset(4.0*factor, 10.0*factor),
                                blurRadius: 10.0*factor
                              )
                            ],
                            // border: new Border.all(color: Colors.orange[50], width: 2.0*factor),
                            borderRadius: new BorderRadius.all(new Radius.circular(6.0*factor))
                          ),
                          child: new Center(
                            child: new Text('我是求职者', style: new TextStyle(color: Color(0xFF5d5d5d), fontSize: 28.0*factor),),
                          ),
                        ),
                      ),
                    )
                  ]
                )
              ],
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            height: 345*factor,
            child: new Image.asset(
              'assets/images/bottom.png',
              width: MediaQuery.of(context).size.width,
              height: 345*factor,
            )
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
          isRequesting ? Positioned(
            left: 0,
            top: 0,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SpinKitHourGlass(
              color: Theme.of(context).primaryColor,
              size: 50*factor,
              duration: Duration(milliseconds: 1800),
            ),
          ) : Container()
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
      Response response = await Api().login(username, null);
      prefs.setInt('userId', response.data['id']);
      if (role == 1) {
        Response resumeResponse = await Api().getUserInfo(response.data['id'], null);
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