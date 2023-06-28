import 'package:flutter/material.dart';
import 'package:flutter_app/app/component/icon_tab.dart';
import 'package:flutter_app/app/view/jobs_view.dart';
import 'package:flutter_app/app/view/message_view.dart';
import 'package:flutter_app/app/view/mine_view.dart';
import 'dart:io';
import 'dart:ui';
import 'dart:isolate';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter_app/util/util.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/util/app_config.dart';
// import 'package:flutter_2d_amap/flutter_2d_amap.dart';
// import 'package:amap_base/amap_base.dart';

const int INDEX_JOB = 0;
const int INDEX_COMPANY = 1;
const int INDEX_STUDY = 2;
const int INDEX_MESSAGE = 3;
const int INDEX_MINE = 4;

class BossApp extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<BossApp> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  TabController _controller;
  VoidCallback onChanged;
  Widget mine = new MineTab();
  String version;
  String newestVersion;
  ReceivePort _port = ReceivePort();
  int progress = 0;
  String taskId;

  @override
  void initState() {
    super.initState();
    _controller =
        new TabController(initialIndex: _currentIndex, length: 5, vsync: this);
    onChanged = () {
      setState(() {
        _currentIndex = this._controller.index;
      });
    };

    _controller.addListener(onChanged);

    if (Platform.isIOS) {
      // AMap.init('c55ccc3e7e0e767fb718b90f592a75f2');
    }
    if (Platform.isAndroid) {
      _bindBackgroundIsolate();
      _prepare();
    }

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      version = packageInfo.version;
      return Api().checkAppVersion();
    }).then((Response response) {
      if (response.data['code'] == 1) {
        if (Platform.isAndroid) {
          newestVersion = response.data['android'];
          if (newestVersion.compareTo(version) == 1) {
            showDialog<Null>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return new AlertDialog(
                  title: new Text('提示'),
                  content: new SingleChildScrollView(
                    child: new ListBody(
                      children: <Widget>[new Text("新版本发布了，请下载更新哦~")],
                    ),
                  ),
                  actions: <Widget>[
                    new TextButton(
                      child: new Text('确定'),
                      onPressed: () {
                        executeDownload();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            );
          }
        } else {
          newestVersion = response.data['version'];
          if (newestVersion.compareTo(version) == 1) {
            showDialog<Null>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return new AlertDialog(
                  title: new Text('提示'),
                  content: new SingleChildScrollView(
                    child: new ListBody(
                      children: <Widget>[
                        new Text("新版本发布了，请前往app store更新哦~"),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    new TextButton(
                      child: new Text('确定'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        String url =
                            'itms-apps://apps.apple.com/cn/app/%E6%9C%8D%E9%92%B0%E4%BC%97%E5%8C%85/id1512532612'; // 这是微信的地址，到时候换成自己的应用的地址
                        launch(url);
                      },
                    ),
                  ],
                );
              },
            );
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.removeListener(onChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    YaCaiUtil.getInstance().init(context);
    double factor = MediaQuery.of(context).size.width / 750;
    double _kTabTextSize = 20.0 * factor;
    Color _kPrimaryColor = Theme.of(context).primaryColor;
    return new Scaffold(
      body: progress > 0
          ? new Material(
              color: Color.fromARGB(190, 0, 0, 0),
              child: new Center(
                child: new SizedBox(
                  width: 120.0,
                  height: 120.0,
                  child: new Container(
                    decoration: ShapeDecoration(
                      color: Color(0xffffffff),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                    ),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new CircularProgressIndicator(),
                        new Padding(
                          padding: const EdgeInsets.only(
                            top: 20.0,
                          ),
                          child: new Text("下载中$progress%"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : new TabBarView(
              children: <Widget>[
                new JobsTab(1, '全职'),
                new JobsTab(2, '兼职'),
                new JobsTab(3, '实习'),
                new MessageTab(),
                mine
              ],
              controller: _controller,
            ),
      bottomNavigationBar: new Material(
          color: Colors.white,
          elevation: 4.0,
          shadowColor: Color(0xFF788db4),
          child: SafeArea(
            child: new TabBar(
              controller: _controller,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: new TextStyle(fontSize: _kTabTextSize),
              tabs: <IconTab>[
                new IconTab(
                    color: _currentIndex == INDEX_JOB
                        ? _kPrimaryColor
                        : Colors.black,
                    text: "全职",
                    iconData: _currentIndex == INDEX_JOB
                        ? Image.asset('assets/images/full_active.png',
                            width: 50.0 * factor)
                        : Image.asset('assets/images/full.png',
                            width: 50.0 * factor)),
                new IconTab(
                    color: _currentIndex == INDEX_COMPANY
                        ? _kPrimaryColor
                        : Colors.black,
                    text: "兼职",
                    iconData: _currentIndex == INDEX_COMPANY
                        ? Image.asset('assets/images/parttime_active.png',
                            width: 50.0 * factor)
                        : Image.asset('assets/images/parttime.png',
                            width: 50.0 * factor)),
                new IconTab(
                    color: _currentIndex == INDEX_STUDY
                        ? _kPrimaryColor
                        : Colors.black,
                    text: "实习",
                    iconData: _currentIndex == INDEX_STUDY
                        ? Image.asset('assets/images/practice_active.png',
                            width: 50.0 * factor)
                        : Image.asset('assets/images/practice.png',
                            width: 50.0 * factor)),
                new IconTab(
                    color: _currentIndex == INDEX_MESSAGE
                        ? _kPrimaryColor
                        : Colors.black,
                    text: "交流",
                    iconData: _currentIndex == INDEX_MESSAGE
                        ? Image.asset('assets/images/msg_active.png',
                            width: 50.0 * factor)
                        : Image.asset('assets/images/msg.png',
                            width: 50.0 * factor)),
                new IconTab(
                    color: _currentIndex == INDEX_MINE
                        ? _kPrimaryColor
                        : Colors.black,
                    text: "我的",
                    iconData: (_currentIndex == INDEX_MINE)
                        ? Image.asset('assets/images/mine_active.png',
                            width: 50.0 * factor)
                        : Image.asset('assets/images/mine.png',
                            width: 50.0 * factor))
              ],
            ),
          )),
    );
  }

  static Future<String> get _apkLocalPath async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

  Future<Null> _prepare() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterDownloader.initialize();
    FlutterDownloader.registerCallback(downloadCallback);
  }

  // 下载
  Future<void> executeDownload() async {
    final path = await _apkLocalPath;
    // String downLoadUrl = Platform.isAndroid ? 'http://192.168.140.56:3000' : 'http://192.168.2.101:3000';
    // String downLoadUrl = 'http://192.168.43.204:3000';
    String downLoadUrl = AppConfig.getInstance().apiBaseUrl;
    //下载
    taskId = await FlutterDownloader.enqueue(
        url: downLoadUrl + '/app-release.apk',
        savedDir: path,
        showNotification: true,
        openFileFromNotification: true);
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) async {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
    // if (status == DownloadTaskStatus.complete) {
    //   OpenFile.open(path + '/app-release.apk');
    // } else if (status == DownloadTaskStatus.failed) {
    //   FuYuUtil.getInstance().showMsg('下载失败');
    // }
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      print('UI Isolate Callback: ${data[2]} ${data[1]}');
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int currentProgress = data[2];

      if (taskId == id) {
        setState(() {
          progress = currentProgress;
        });
      }
      if (status == DownloadTaskStatus.complete) {
        FlutterDownloader.open(taskId: taskId);
      } else if (status == DownloadTaskStatus.failed) {
        YaCaiUtil.getInstance().showMsg('下载失败');
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }
}
