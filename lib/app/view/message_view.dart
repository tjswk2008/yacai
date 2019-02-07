import 'package:flutter/material.dart';
import 'package:flutter_app/app/item/postlist_item.dart';
import 'package:flutter_app/app/model/post.dart';
import 'package:flutter_app/app/view/post/post_detail.dart';
import 'package:flutter_app/app/view/post/question_view.dart';
import 'package:flutter_app/app/view/login_view.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/app/model/app.dart';
import 'package:flutter_app/actions/actions.dart';

class MessageTab extends StatefulWidget {
  final String _title;

  MessageTab(this._title);
  @override
  PostList createState() => new PostList();
}

class PostList extends State<MessageTab> {
  List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    getPostList();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, String>(
      converter: (store) => store.state.userName,
      builder: (context, userName) {
        return new Scaffold(
          backgroundColor: new Color.fromARGB(255, 242, 242, 245),
          appBar: new AppBar(
            elevation: 0.0,
            title: new Text(widget._title,
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
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
                      padding: const EdgeInsets.only(top: 5.0, right: 5.0),
                      child: new InkWell(
                        onTap: () {
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
                        child: new Container(
                          height: 30,
                          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                          decoration: new BoxDecoration(
                            color: Colors.cyan[300],
                            border: new Border.all(color: const Color(0xffcccccc)),
                            borderRadius: new BorderRadius.all(new Radius.circular(5.0))
                          ),
                          child: new Center(
                            child: new Text("我要提问", style: new TextStyle(fontSize: 16.0, color: Colors.white),),
                          ),
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
      }))
      .then((result) {
        if(result == null) return;
        Api().getUserInfo(result)
          .then((Response response) {
            Resume resume = Resume.fromMap(response.data['info']);
            StoreProvider.of<AppState>(context).dispatch(SetResumeAction(resume));
          })
          .catchError((e) {
            print(e);
          });
      });
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
