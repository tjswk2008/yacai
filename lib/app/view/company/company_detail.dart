import 'package:flutter/material.dart';
import 'package:flutter_app/app/component/indicator_viewpager.dart';
import 'package:flutter_app/app/model/company.dart';
import 'package:flutter_app/app/view/company/company_hot_job.dart';
import 'package:flutter_app/app/view/company/company_inc.dart';
import 'package:flutter_app/app/view/company/company_info.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

class CompanyDetail extends StatefulWidget {

  final Company _company;

  CompanyDetail(this._company);

  @override
  CompanyDetailState createState() => new CompanyDetailState();
}

class CompanyDetailState extends State<CompanyDetail>
    with TickerProviderStateMixin {

  List<Tab> _tabs;
  List<Widget> _imagePages;
  TabController _controller;
  List<String> _urls = [
    'https://img.bosszhipin.com/beijin/mcs/chatphoto/20170725/861159df793857d6cb984b52db4d4c9c.jpg',
    'https://img2.bosszhipin.com/mcs/chatphoto/20151215/a79ac724c2da2a66575dab35384d2d75532b24d64bc38c29402b4a6629fcefd6_s.jpg',
    'https://img.bosszhipin.com/beijin/mcs/chatphoto/20180207/c15c2fc01c7407b98faf4002e682676b.jpg'
  ];
  Widget _companyTabContent;
  VoidCallback onChanged;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    
    _tabs = [
      new Tab(text: '公司概况'),
      new Tab(text: '热招职位'),
    ];
    _companyTabContent = new CompanyInc(widget._company.inc);
    _controller = new TabController(length: _tabs.length, vsync: this);
    onChanged = () {
      setState(() {
        if (_currentIndex == 0) {
          _companyTabContent = new CompanyInc(widget._company.inc);
        } else {
          _companyTabContent = new CompanyHotJob();
        }
        _currentIndex = this._controller.index;
      });
    };

    _controller.addListener(onChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(onChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidthInPt = MediaQuery.of(context).size.width;
    double _kAppBarHeight = 375.0*screenWidthInPt/750;
    if (_urls.isNotEmpty) {
      _imagePages = <Widget>[];
      _urls.forEach((String url) {
        _imagePages.add(
            new Container(
                color: Colors.black.withAlpha(900),
                child: new ConstrainedBox(
                  constraints: const BoxConstraints.expand(),
                  child: new Image.network(
                    url,
                    fit: BoxFit.cover,
                    height: _kAppBarHeight,
                  ),
                ))
        );
      });
    }
    return new Scaffold(
        backgroundColor: new Color.fromARGB(255, 242, 242, 245),
        body: new Stack(
          children: <Widget>[
            new SingleChildScrollView(
                child: new Column(
                  children: <Widget>[
                    new SizedBox.fromSize(
                      size: Size.fromHeight(_kAppBarHeight),
                      child: new IndicatorViewPager(_imagePages),
                    ),

                    new Container(
                      color: Colors.white,
                      child: new Column(
                        children: <Widget>[
                          new CompanyInfo(widget._company),
                          new Divider(),
                          new TabBar(
                            indicatorWeight: 3.0*screenWidthInPt/750,
                            indicatorSize: TabBarIndicatorSize.tab,
                            labelStyle: new TextStyle(fontSize: 22.0*screenWidthInPt/750),
                            labelColor: Colors.black,
                            controller: _controller,
                            tabs: _tabs,
                            indicatorColor: Theme
                                .of(context)
                                .primaryColor,
                          ),
                        ],
                      ),
                    ),
                    _companyTabContent
                  ],
                )
            ),

            new Positioned(
              top: 10.0*screenWidthInPt/750,
              left: -10.0*screenWidthInPt/750,
              child: IconButton(
                icon: const BackButtonIcon(),
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                iconSize: 40.0*screenWidthInPt/750,
                color: Colors.white,
                onPressed: () {
                  Navigator.maybePop(context);
                }
              ),
            ),
          ],
        )
    );
  }
}