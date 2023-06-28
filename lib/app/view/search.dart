import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/app/model/app.dart';
import 'package:flutter_app/app/model/company.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

class Search extends StatefulWidget {
  Search();

  @override
  SearchState createState() => new SearchState();
}

class SearchState extends State<Search> with TickerProviderStateMixin {
  VoidCallback onChanged;
  bool isRequesting = false;
  String userName = '';
  List<Company> list = <Company>[];

  final searchCtrl = new TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width / 750;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return new Scaffold(
              backgroundColor: Colors.white,
              appBar: new AppBar(
                elevation: 0.0,
                leading: IconButton(
                    icon: const BackButtonIcon(),
                    iconSize: 40 * factor,
                    tooltip:
                        MaterialLocalizations.of(context).backButtonTooltip,
                    onPressed: () {
                      Navigator.maybePop(context);
                    }),
                title: new Text('搜索',
                    style: new TextStyle(
                        fontSize: 30.0 * factor, color: Colors.white)),
              ),
              body: new SingleChildScrollView(
                  child: new Container(
                padding: EdgeInsets.all(30.0 * factor),
                child: new prefix0.Row(
                  mainAxisAlignment: prefix0.MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    prefix0.Container(
                      width: 500 * factor,
                      child: TextField(
                        autofocus: true,
                        style: TextStyle(fontSize: 28 * factor),
                        controller: searchCtrl,
                        decoration: new InputDecoration(
                            hintText: "请输入公司名或职位",
                            hintStyle: new TextStyle(
                                color: const Color(0xFF808080),
                                fontSize: 28.0 * factor),
                            border: new UnderlineInputBorder(
                                borderSide: BorderSide(width: 1.0 * factor)),
                            contentPadding: EdgeInsets.all(20.0 * factor)),
                      ),
                    ),
                    prefix0.FlatButton(
                      color: prefix0.Theme.of(context).primaryColor,
                      child: prefix0.Text(
                        '搜索',
                        style: prefix0.TextStyle(
                            fontSize: 28 * factor, color: Colors.white),
                      ),
                      onPressed: () {
                        prefix0.Navigator.pop(context, searchCtrl.text);
                      },
                    )
                  ],
                ),
              )));
        });
  }
}
