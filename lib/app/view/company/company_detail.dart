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
          _companyTabContent = new CompanyHotJob(widget._company.jobs);
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
    double factor = MediaQuery.of(context).size.width/750;
    double _kAppBarHeight = 375.0*factor;
    if (widget._company.imgs.isNotEmpty) {
      _imagePages = <Widget>[];
      widget._company.imgs.forEach((Map map) {
        _imagePages.add(
            new Container(
                color: Colors.black.withAlpha(900),
                child: new ConstrainedBox(
                  constraints: const BoxConstraints.expand(),
                  child: new Image.network(
                    map['url'],
                    fit: BoxFit.cover,
                    height: _kAppBarHeight,
                  ),
                ))
        );
      });
    }
    return new Scaffold(
        backgroundColor: new Color.fromARGB(255, 242, 242, 245),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: SafeArea(
            child: new Stack(
              children: <Widget>[
                SingleChildScrollView(
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
                              indicatorWeight: 3.0*factor,
                              indicatorSize: TabBarIndicatorSize.tab,
                              labelStyle: new TextStyle(fontSize: 26.0*factor),
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

                      Container(
                        height: MediaQuery.of(context).size.height - 535*factor - 77.0,
                        child: _companyTabContent,
                      ),
                    ],
                  ),
                ),

                new Positioned(
                  top: 20.0*factor,
                  left: 20.0*factor,
                  child: Container(
                    width: 50.0*factor,
                    height: 50.0*factor,
                    decoration: BoxDecoration(
                      border: Border.all(width: factor, color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(25*factor))
                    ),
                    child: FloatingActionButton(
                      backgroundColor: Colors.transparent,
                      child: Icon(
                        Theme.of(context).platform == TargetPlatform.android ? Icons.arrow_back : Icons.arrow_back_ios,
                        size: 40.0*factor,
                        color: Colors.white,
                      ),
                      
                      onPressed: () {
                        Navigator.maybePop(context);
                      }
                    ),
                  )
                ),
              ],
            ),
          )
          
        )
    );
  }
}