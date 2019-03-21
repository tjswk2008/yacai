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
  String userName = '';

  @override
  void initState() {
    super.initState();
    getPostList();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidthInPt = MediaQuery.of(context).size.width;
    return new Scaffold(
      backgroundColor: new Color.fromARGB(255, 242, 242, 245),
      appBar: new AppBar(
        elevation: 0.0,
        title: new Text(widget._title,
            style: new TextStyle(fontSize: 30.0*screenWidthInPt/750, color: Colors.white)),
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
                  padding: EdgeInsets.only(top: 5.0*screenWidthInPt/750, right: 15.0*screenWidthInPt/750),
                  child: new Container(
                    height: 60.0*screenWidthInPt/750,
                    width: 175.0*screenWidthInPt/750,
                    child: RaisedButton(
                      color: Colors.orange[400],
                      child: Text("我要提问", style: new TextStyle(fontSize: 26.0*screenWidthInPt/750, color: Colors.white),),
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

  void getPostList() {
    Api().getPostList()
      .then((Response response) {
        setState(() {
          _posts = Post.fromJson(response.data['list']);
        });
        return SharedPreferences.getInstance();
      })
      .then((SharedPreferences prefs) {
        setState(() {
          userName = prefs.getString('userName');
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
