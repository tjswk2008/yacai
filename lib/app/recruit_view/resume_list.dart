import 'package:flutter/material.dart';
import 'package:flutter_app/app/item/userlist_item.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dropdown_menu/dropdown_menu.dart';
import 'package:flutter_app/app/model/constants.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/bezier_hour_glass_header.dart';
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
// import 'dart:developer';

class ResumeTab extends StatefulWidget {
  final String _title;
  final int jobId;

  ResumeTab(this._title, this.jobId);
  @override
  ResumeTabState createState() => new ResumeTabState();
}

class ResumeTabState extends State<ResumeTab> {
  List<PersonalInfo> _personalInfos = [];

  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();

  int index1 = 0,
      index2 = 0,
      index3 = 0,
      index4 = 0,
      index5 = 0;

  int currentPage = 1,
      totalPage = 1;
  
  static List<String> markers = [
    "全部",
    "有意向",
    "已电联",
  ];

  String timeReq = timeReqArr[0];
  String academic = academicArr[0];
  String salary = salaryArr[0];
  int mark = 0;

  @override
  void initState() {
    super.initState();
    getResumeList(1);
  }

  DropdownMenu buildDropdownMenu() {
    double factor = MediaQuery.of(context).size.width/750;

    return new DropdownMenu(
        maxMenuHeight: 80 * factor * 10,
        menus: [
          // new DropdownMenuBuilder(
          //     builder: (BuildContext context) {
          //       return new DropdownListMenu(
          //         selectedIndex: index1,
          //         data: salaryArr,
          //         itemBuilder: buildCheckItem,
          //       );
          //     },
          //     height: 80 * factor * salaryArr.length),
          new DropdownMenuBuilder(
              builder: (BuildContext context) {
                return new DropdownListMenu(
                  selectedIndex: index2,
                  data: academicArr,
                  itemBuilder: buildCheckItem,
                );
              },
              height: 80 * factor * academicArr.length),
          new DropdownMenuBuilder(
              builder: (BuildContext context) {
                return new DropdownListMenu(
                  itemExtent: 80 * factor,
                  selectedIndex: index3,
                  data: timeReqArr,
                  itemBuilder: buildCheckItem,
                );
              },
              height: 80 * factor * timeReqArr.length),
          new DropdownMenuBuilder(
              builder: (BuildContext context) {
                return new DropdownListMenu(
                  itemExtent: 80 * factor,
                  selectedIndex: index4,
                  data: markers,
                  itemBuilder: buildCheckItem,
                );
              },
              height: 80 * factor * markers.length),
        ]);
  }

  DropdownHeader buildDropdownHeader({DropdownMenuHeadTapCallback onTap}) {
    double factor = MediaQuery.of(context).size.width/750;
    return new DropdownHeader(
      onTap: onTap,
      height: 80*factor,
      titles: [academicArr[index2], timeReqArr[index3], markers[index4]],
    );
  }

  Widget buildFixHeaderDropdownMenu() {
    double factor = MediaQuery.of(context).size.width/750;
    return new DefaultDropdownMenuController(
      onSelected: ({int menuIndex, int index, int subIndex, dynamic data}) {
        switch (menuIndex) {
          case 0:
            academic = data;
            break;
          case 1:
            timeReq = data;
            break;
          case 2:
            mark = index;
            break;
          default:
            break;
        }
        getResumeList(1);
      },
      child: new Column(
        children: <Widget>[
          buildDropdownHeader(),
          new Expanded(
            child: new Stack(
              children: <Widget>[
                (_personalInfos.length != 0) ? new Padding(
                  padding: EdgeInsets.only(
                    top: 15.0*factor
                  ),
                  child: EasyRefresh(
                    refreshHeader:BezierHourGlassHeader(
                      key: _headerKey,
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    refreshFooter: BezierBounceFooter(
                      key: _footerKey,
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    onRefresh: () {
                      getResumeList(1);
                    },
                    loadMore: () async {
                      getResumeList(currentPage);
                    },
                    child: new ListView.builder(
                      itemCount: _personalInfos.length,
                      itemBuilder: buildResumeItem
                    )
                  )
                ) : Center(
                  child: Text('暂无记录', style: TextStyle(fontSize: 28*factor))
                ),
                buildDropdownMenu()
            ],
          ))
        ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.jobId != null ? new AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: const BackButtonIcon(),
          iconSize: 40*factor,
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () {
            Navigator.maybePop(context);
          }
        ),
        title: new Text(widget._title,
          style: new TextStyle(fontSize: 30.0*factor, color: Colors.white)
        ),
      ) : AppBar(
        elevation: 0.0,
        title: new Text(widget._title,
          style: new TextStyle(fontSize: 30.0*factor, color: Colors.white)
        ),
      ),
      body: buildFixHeaderDropdownMenu()
    );
  }

  Widget buildResumeItem(BuildContext context, int index) {
    PersonalInfo personalInfo = _personalInfos[index];

    return UserListItem(personalInfo, widget.jobId);
  }

  void getResumeList(page) async {
    if(page > totalPage) {
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Api().getResumeList(prefs.getString('userName'), widget.jobId, timeReq, academic, salary, mark, page)
      .then((Response response) {
        if (response.data['code'] == 1) {
          totalPage = response.data['total'] == 0 ? 1 : response.data['total'];
          if(totalPage != 1 && currentPage <= totalPage) {
            currentPage++;
          }
          setState(() {
            if (page == 1) {
              _personalInfos = [];
              _personalInfos = PersonalInfo.fromList(response.data['list']);
            } else {
              PersonalInfo.fromList(response.data['list']).forEach((item) {
                _personalInfos.add(item);
              });
            }
          });
        }
      })
     .catchError((e) {
       print(e);
     });
  }
}
