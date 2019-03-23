import 'package:flutter/material.dart';
import 'package:flutter_app/app/item/companylist_item.dart';
import 'package:flutter_app/app/model/company.dart';
import 'package:flutter_app/app/view/company/company_detail.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompanyTab extends StatefulWidget {
  @override
  CompanyList createState() => new CompanyList();
}

class CompanyList extends State<CompanyTab> {

  List<Company> _companties = [];

  @override
  void initState() {
    super.initState();
    getCompanyList();
  }

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return new Scaffold(
      backgroundColor: new Color.fromARGB(255, 242, 242, 245),
      appBar: new AppBar(
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: const BackButtonIcon(),
          iconSize: 40*factor,
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () {
            Navigator.maybePop(context);
          }
        ),
        title: new Text(
          '被查阅记录', style: new TextStyle(fontSize: 30.0*factor, color: Colors.white)
        ),
      ),
      body: _companties.length != 0 ? new ListView.builder(
          itemCount: _companties.length, itemBuilder: buildCompanyItem) : Center(
            child: Text('暂无记录', style: TextStyle(fontSize: 28*factor)
            )
          ),
    );
  }

  Widget buildCompanyItem(BuildContext context, int index) {
    Company company = _companties[index];

    var companyItem = new InkWell(
        onTap: () => navCompanyDetail(company, index),
        child: new CompanyListItem(company)
    );

    return companyItem;
  }

  void getCompanyList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Api().getCompanyList(prefs.getString('userName'))
      .then((Response response) {
        if(response.data['code'] != 1) {
          return;
        }
        setState(() {
          _companties = Company.fromJson(response.data['list']);
        });
      })
     .catchError((e) {
       print(e);
     });
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
}
