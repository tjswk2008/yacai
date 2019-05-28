import 'package:flutter/material.dart';
import 'package:flutter_app/app/item/postlist_item.dart';
import 'package:flutter_app/app/model/post.dart';
import 'package:flutter_app/app/view/post/post_detail.dart';
import 'package:flutter_app/app/view/post/question_view.dart';
import 'package:flutter_app/app/view/login_view.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MessageTab extends StatefulWidget {
  final String _title;

  MessageTab(this._title);
  @override
  PostList createState() => new PostList();
}

class PostList extends State<MessageTab> with SingleTickerProviderStateMixin {
  List<Post> _posts = [];
  List<Post> _originalPosts = [];
  String userName = '';
  bool isRequesting = false;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);
    getPostList();
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
          posts(),
          posts(),
          posts(),
        ],
      ),
    );
  }

  Widget posts() {
    double factor = MediaQuery.of(context).size.width/750;
    return isRequesting ? new Stack(
      children: <Widget>[
        Positioned.fill(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Color.fromARGB(190, 0, 0, 0)
            ),
          ),
        ),
        Positioned.fill(
          child: SpinKitHourGlass(
            color: Theme.of(context).primaryColor,
            size: 50*factor,
            duration: Duration(milliseconds: 1800),
          ),
        )
      ]
    ) : new Stack(
      children: <Widget>[
        new ListView.builder(
          itemCount: _posts.length,
          itemBuilder: buildJobItem
        ),
        Positioned(
          bottom: 20*factor,
          right: 20*factor,
          child: FloatingActionButton(
            backgroundColor: Colors.orange[400],
            child: Icon(
              Icons.add,
              size: 40.0*factor,
              color: Colors.white,
            ),
            onPressed: () {
              if(userName == '') {
                _login();
                return;
              }
              Navigator.of(context).push(new PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return new AskQuestion();
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
              )).then((result) {
                if(result == null) return;
                getPostList();
              });
            },
          ),
        )
      ]
    );
  }

  Widget buildJobItem(BuildContext context, int index) {
    Post post = _posts[index];

    return new InkWell(
        onTap: () => navPostDetail(post),
        child: new PostListItem(post));
  }

  void getPostList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('userName');
    Api().getPostList(user)
      .then((Response response) {
        if (!mounted) {
          return;
        }
        setState(() {
          isRequesting = false;
          userName = user;
          _posts = Post.fromJson(response.data['list']);
          _originalPosts = Post.fromJson(response.data['list']);
        });
      })
     .catchError((e) {
       setState(() {
          isRequesting = false;
        });
       print(e);
     });
  }

  _login() {
    Navigator
      .of(context)
      .push(new MaterialPageRoute(builder: (context) {
        return new NewLoginPage();
      }));
  }

  navPostDetail(Post post) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new PostDetail(post);
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
