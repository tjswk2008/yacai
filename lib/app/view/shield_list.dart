import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/app/model/app.dart';
import 'package:flutter_app/app/model/company.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_app/app/view/company/company_detail.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

class ShieldList extends StatefulWidget {

  ShieldList();

  @override
  ShieldListState createState() => new ShieldListState();
}

class ShieldListState extends State<ShieldList>
    with TickerProviderStateMixin {

  VoidCallback onChanged;
  bool isRequesting = false;
  String userName = '';
  List<Company> list = <Company>[];

  @override
  void initState() {
    super.initState();
    getBlockedList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return new Scaffold(
          backgroundColor: Colors.white,
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
            title: new Text('屏蔽列表',
                style: new TextStyle(fontSize: 30.0*factor, color: Colors.white)),
          ),
          body: new SingleChildScrollView(
            child: new Container(
              padding: EdgeInsets.symmetric(vertical: 30.0*factor, horizontal: 10*factor),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Padding(
                    padding: EdgeInsets.only(bottom: 16.0*factor),
                    child: Stack(
                      children: <Widget>[
                        TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                            autofocus: true,
                            style: TextStyle(fontSize: 20*factor),
                            decoration: new InputDecoration(
                              hintText: "请输入公司名称",
                              hintStyle: new TextStyle(
                                  color: const Color(0xFF808080),
                                  fontSize: 20.0*factor
                              ),
                              border: new UnderlineInputBorder(
                                borderSide: BorderSide(width: 1.0*factor)
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
                            );
                          },
                          onSuggestionSelected: (suggestion) async {
                            Company newCompany = Company.fromMap(suggestion);
                            bool hasElement = list.any((Company company) => company.name == newCompany.name);
                            if (hasElement) {
                              return;
                            }
                            if (isRequesting) return;
                            setState(() {
                              isRequesting = true;
                            });
                            try {
                              Response response = await Api().addToBlockedList(
                                userName,
                                newCompany.id,
                                1
                              );

                              setState(() {
                                isRequesting = false;
                              });
                              if(response.data['code'] != 1) {
                                Scaffold.of(context).showSnackBar(new SnackBar(
                                  content: new Text("添加失败！"),
                                ));
                                return;
                              }
                              newCompany.blocked = 1;
                              list.add(newCompany);
                              setState(() {
                                list = list;
                              });
                            } catch(e) {
                              setState(() {
                                isRequesting = false;
                              });
                              print(e);
                            }
                          },
                        )
                      ],
                    )
                    
                  ),
                  list.length != 0 ? new ListView.builder(
                    shrinkWrap: true,
                    physics: new NeverScrollableScrollPhysics(),
                    itemCount: list.length, itemBuilder: (BuildContext context, int index) {
                      Company company = list[index];
                      return Card(
                        elevation: 4.0,
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Padding(
                              padding: EdgeInsets.only(
                                top: 10.0*factor,
                                left: 15.0*factor,
                                right: 15.0*factor,
                                bottom: 0.0,
                              ),
                              child: company.logo != null ? new Image.network(
                                company.logo,
                                width: 100.0*factor,
                                height: 100.0*factor,) : Container(
                                  width: 100.0*factor,
                                  height: 100.0*factor,
                                ),
                            ),

                            new Expanded(
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      new Container(
                                        child: new Text(
                                          company.name,
                                          textAlign: TextAlign.left,
                                          style: new TextStyle(fontSize: 24.0*factor),
                                        ),
                                        margin: EdgeInsets.only(top: 10.0*factor, bottom: 10.0*factor),
                                      ),
                                      Switch.adaptive(
                                        value: true,
                                        activeColor: Theme.of(context).primaryColor,     // 激活时原点颜色
                                        onChanged: (bool val) async {
                                            if (isRequesting) return;
                                            setState(() {
                                              isRequesting = true;
                                            });
                                            try {
                                              Response response = await Api().addToBlockedList(
                                                userName,
                                                company.id,
                                                0
                                              );

                                              setState(() {
                                                isRequesting = false;
                                              });
                                              if(response.data['code'] != 1) {
                                                Scaffold.of(context).showSnackBar(new SnackBar(
                                                  content: new Text("添加失败！"),
                                                ));
                                                return;
                                              }
                                              company.blocked = 0;
                                              list.remove(company);
                                              setState(() {
                                                list = list;
                                              });
                                            } catch(e) {
                                              setState(() {
                                                isRequesting = false;
                                              });
                                              print(e);
                                            }
                                        },
                                      )
                                    ],
                                  ),

                                  new Padding(
                                    padding: EdgeInsets.only(
                                      top: 10.0*factor,
                                      left: 0.0,
                                      right: 10.0*factor,
                                      bottom: 10.0*factor,
                                    ),
                                    child: new Text(company.location, style: new TextStyle(
                                        fontSize: 22.0*factor, color: Colors.grey)),
                                  ),

                                  new Padding(
                                    padding: EdgeInsets.only(
                                      top: 10.0*factor,
                                      left: 0.0,
                                      right: 10.0*factor,
                                      bottom: 10.0*factor,
                                    ),
                                    child: new Text(
                                        '${company.type} | ${company.employee}', style: new TextStyle(
                                        fontSize: 22.0*factor, color: Colors.grey)),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }) : Container()
                ],
              ),
            )
          )
        );
      }
    );
  }

  navCompanyDetail(Company company, int index) {
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

  getBlockedList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('userName');
    Response response = await Api().getBlockedList(name);
    setState(() {
      userName = name;
      list = Company.fromJson(response.data['list']);
    });
  }
}