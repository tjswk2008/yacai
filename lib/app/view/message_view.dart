import 'package:flutter/material.dart';
import 'package:flutter_app/app/item/postlist_item.dart';
import 'package:flutter_app/app/model/post.dart';
import 'package:flutter_app/app/view/post/post_detail.dart';
import 'package:flutter_app/app/view/post/question_view.dart';
import 'package:flutter_app/app/view/login_view.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageTab extends StatefulWidget {
  final String _title;

  MessageTab(this._title);
  @override
  PostList createState() => new PostList();
}

class PostList extends State<MessageTab> {
  List<Post> _posts = [];
  List<Post> _originalPosts = [];
  String userName = '';

  @override
  void initState() {
    super.initState();
    getPostList();
  }

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return new Scaffold(
      backgroundColor: new Color.fromARGB(255, 242, 242, 245),
      appBar: new AppBar(
        elevation: 0.0,
        title: new Text(widget._title,
          style: new TextStyle(fontSize: 30.0*factor, color: Colors.white)
        ),
        actions: <Widget>[
          new PopupMenuButton(
            onSelected: (int value){
               setState(() {
                 if(value == 0) {
                   _posts = _originalPosts;
                 } else {
                   _posts = [];
                  for (var i = 0; i < _originalPosts.length; i++) {
                    Post element = _originalPosts[i];
                    if(element.type == value) {
                      _posts.add(element);
                    }
                  }
                 }
               });
            },
            itemBuilder: (BuildContext context) =><PopupMenuItem<int>>[
              new PopupMenuItem(
                  value: 0,
                  child: new Text("全部", style: TextStyle(fontSize: 22*factor),)
              ),
              new PopupMenuItem(
                value: 1,
                  child: new Text("财务/审计/税务", style: TextStyle(fontSize: 22*factor),)
              ),
              new PopupMenuItem(
                value: 2,
                  child: new Text("求职经", style: TextStyle(fontSize: 22*factor),)
              ),
              new PopupMenuItem(
                value: 3,
                  child: new Text("吐槽", style: TextStyle(fontSize: 22*factor),)
              )
            ]
          )
        ],
      ),
      body: new SingleChildScrollView(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(top: 5.0*factor, right: 15.0*factor),
                  child: new Container(
                    height: 60.0*factor,
                    width: 175.0*factor,
                    child: RaisedButton(
                      color: Colors.orange[400],
                      child: Text("我要提问", style: new TextStyle(fontSize: 26.0*factor, color: Colors.white),),
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
                  ),
                )
              ],
            ),
            new ListView.builder(
              shrinkWrap: true,
              physics: new NeverScrollableScrollPhysics(),
              itemCount: _posts.length,
              itemBuilder: buildJobItem
            ),
          ],
        ),
      ),
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
    setState(() {
      userName = user;
    });
    Api().getPostList(user)
      .then((Response response) {
        setState(() {
          _posts = Post.fromJson(response.data['list']);
          _originalPosts = Post.fromJson(response.data['list']);
        });
      })
     .catchError((e) {
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
