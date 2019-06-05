import 'package:flutter/material.dart';
import 'package:flutter_app/app/item/postlist_item.dart';
import 'package:flutter_app/app/model/post.dart';
import 'package:flutter_app/app/view/post/post_detail.dart';
import 'package:flutter_app/app/view/post/question_view.dart';
import 'package:flutter_app/app/view/login_view.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' as Spinkit;
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/bezier_hour_glass_header.dart';
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';

class PostList extends StatefulWidget {
  final int _type;

  PostList(this._type);
  @override
  PostListState createState() => new PostListState();
}

class PostListState extends State<PostList> with SingleTickerProviderStateMixin {
  List<Post> _posts = [];
  String userName = '';
  bool isRequesting = false;
  int currentPage = 1,
      totalPage = 1;
  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();

  @override
  void initState() {
    super.initState();
    getPostList(widget._type, 1);
  }

  @override
  void dispose() {
    currentPage = 1;
    totalPage = 1;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          child: Spinkit.SpinKitHourGlass(
            color: Theme.of(context).primaryColor,
            size: 50*factor,
            duration: Duration(milliseconds: 1800),
          ),
        )
      ]
    ) : new Stack(
      children: <Widget>[
        EasyRefresh(
          refreshHeader:BezierHourGlassHeader(
            key: _headerKey,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          refreshFooter: BezierBounceFooter(
            key: _footerKey,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          onRefresh: () {
            getPostList(widget._type, 1);
          },
          loadMore: () async {
            getPostList(widget._type, currentPage);
          },
          child: new ListView.builder(
            itemCount: _posts.length,
            itemBuilder: buildJobItem
          )
        ),
        Positioned(
          bottom: 20*factor,
          right: 20*factor,
          child: FloatingActionButton(
            mini: true,
            backgroundColor: Colors.orange[400],
            child: Icon(
              Icons.add,
              size: 50.0*factor,
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
                getPostList(widget._type, 1);
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

  void getPostList(int type, page) async {
    if(page > totalPage) {
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('userName');
    Api().getPostList(user, type, page)
      .then((Response response) {
        if (!mounted) {
          return;
        }
        if (response.data['code'] == 1) {
          totalPage = response.data['total'] == 0 ? 1 : response.data['total'];
          if(totalPage != 1 && currentPage <= totalPage) {
            currentPage++;
          }
          setState(() {
            userName = user;
            if (page == 1) {
              _posts = [];
              _posts = Post.fromJson(response.data['list']);
            } else {
              Post.fromJson(response.data['list']).forEach((item) {
                _posts.add(item);
              });
            }
          });
        }
        setState(() {
          isRequesting = false;
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
