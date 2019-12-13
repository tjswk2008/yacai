import 'package:flutter/material.dart';
import 'package:flutter_app/app/view/post_list.dart';

class CommunicateView extends StatefulWidget {
  CommunicateView();
  @override
  CommunicateViewState createState() => new CommunicateViewState();
}

class CommunicateViewState extends State<CommunicateView> with SingleTickerProviderStateMixin {
  String userName = '';
  bool isRequesting = false;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return new Scaffold(
      backgroundColor: new Color.fromARGB(255, 242, 242, 245),
      appBar: PreferredSize(
        child: AppBar(
          elevation: 0.0,
          bottom: new TabBar(
            indicatorColor: Colors.orange[400],
            indicatorWeight: 3*factor,
            tabs: <Widget>[
              new Tab(
                child: new Text('专业问答',
                  style: new TextStyle(fontSize: 30.0*factor, color: Colors.white)
                ),
              ),
              new Tab(
                child: new Text('求职经',
                  style: new TextStyle(fontSize: 30.0*factor, color: Colors.white)
                ),
              ),
              new Tab(
                child: new Text('吐槽',
                  style: new TextStyle(fontSize: 30.0*factor, color: Colors.white)
                ),
              ),
            ],
            controller: _tabController,
          ),
        ),
        preferredSize: Size.fromHeight(48.0)
      ),
      body: new TabBarView(
        controller: _tabController,
        children: <Widget>[
          new PostList(1),
          new PostList(2),
          new PostList(3),
        ],
      ),
    );
  }
}
