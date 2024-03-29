import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

typedef void ChangeData(Map<String, dynamic> map);
typedef List<Widget> CreateWidgetList();

class CityPicker {
  static void showCityPicker(
    BuildContext context, {
    ChangeData selectProvince,
    ChangeData selectCity,
    ChangeData selectArea,
  }) {
    rootBundle.loadString('data/province.json').then((v) {
      List data = json.decode(v);
      Navigator.push(
        context,
        new _CityPickerRoute(
            data: data,
            selectProvince: selectProvince,
            selectCity: selectCity,
            selectArea: selectArea,
            theme: Theme.of(context),
            barrierLabel:
                MaterialLocalizations.of(context).modalBarrierDismissLabel),
      );
    });
  }
}

class _CityPickerRoute<T> extends PopupRoute<T> {
  final ThemeData theme;
  final String barrierLabel;
  final List data;
  final ChangeData selectProvince;
  final ChangeData selectCity;
  final ChangeData selectArea;

  _CityPickerRoute({
    this.theme,
    this.barrierLabel,
    this.data,
    this.selectProvince,
    this.selectCity,
    this.selectArea,
  });

  @override
  Duration get transitionDuration => Duration(milliseconds: 2000);

  @override
  @override
  Color get barrierColor => Colors.black54;

  @override
  bool get barrierDismissible => true;

  AnimationController _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController =
        BottomSheet.createAnimationController(navigator.overlay);
    return _animationController;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    Widget bottomSheet = new MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: new _CityPickerWidget(
        route: this,
        data: data,
        selectProvince: selectProvince,
        selectCity: selectCity,
        selectArea: selectArea,
      ),
    );
    if (theme != null) {
      bottomSheet = new Theme(data: theme, child: bottomSheet);
    }
    return bottomSheet;
  }
}

class _CityPickerWidget extends StatefulWidget {
  final _CityPickerRoute route;
  final List data;
  final ChangeData selectProvince;
  final ChangeData selectCity;
  final ChangeData selectArea;

  _CityPickerWidget(
      {Key key,
      @required this.route,
      this.data,
      this.selectProvince,
      this.selectCity,
      this.selectArea});

  @override
  State createState() {
    return new _CityPickerState();
  }
}

class _CityPickerState extends State<_CityPickerWidget> {
  FixedExtentScrollController provinceController;
  FixedExtentScrollController cityController;
  FixedExtentScrollController areaController;
  int provinceIndex = 0, cityIndex = 0, areaIndex = 0;
  List province = [];
  List city = [];
  List area = [];

  @override
  void initState() {
    super.initState();
    provinceController = new FixedExtentScrollController();
    cityController = new FixedExtentScrollController();
    areaController = new FixedExtentScrollController();
    setState(() {
      province = widget.data;
      city = widget.data[provinceIndex]['sub'];
      area = widget.data[provinceIndex]['sub'][cityIndex]['sub'];
    });
  }

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width / 750;
    return new GestureDetector(
      child: new AnimatedBuilder(
        animation: widget.route.animation,
        builder: (BuildContext context, Widget child) {
          return new ClipRect(
            child: new CustomSingleChildLayout(
              delegate:
                  new _BottomPickerLayout(widget.route.animation.value, factor),
              child: new GestureDetector(
                child: new Material(
                  color: Colors.transparent,
                  child: new Container(
                    width: MediaQuery.of(context).size.width,
                    height: 520.0 * factor,
                    child: new Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: new Column(
                          children: <Widget>[
                            new Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: new Text(
                                    '取消',
                                    style: new TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 24 * factor),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Map<String, dynamic> provinceMap = {
                                      "code": province[provinceIndex]['code'],
                                      "name": province[provinceIndex]['name']
                                    };
                                    Map<String, dynamic> cityMap = {
                                      "code": province[provinceIndex]['sub']
                                          [cityIndex]['code'],
                                      "name": province[provinceIndex]['sub']
                                          [cityIndex]['name']
                                    };
                                    Map<String, dynamic> areaMap = {
                                      "code": province[provinceIndex]['sub']
                                          [cityIndex]['sub'][areaIndex]['code'],
                                      "name": province[provinceIndex]['sub']
                                          [cityIndex]['sub'][areaIndex]['name']
                                    };
                                    if (widget.selectProvince != null) {
                                      widget.selectProvince(provinceMap);
                                    }
                                    if (widget.selectCity != null) {
                                      widget.selectCity(cityMap);
                                    }
                                    if (widget.selectArea != null) {
                                      widget.selectArea(areaMap);
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: new Text(
                                    '确定',
                                    style: new TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 24 * factor),
                                  ),
                                ),
                              ],
                            ),
                            new Row(
                              children: <Widget>[
                                new _MyCityPicker(
                                  key: Key('province'),
                                  controller: provinceController,
                                  createWidgetList: () {
                                    return province.map((v) {
                                      return new Align(
                                        child: new Text(v['name'],
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 22 * factor)),
                                        alignment: Alignment.centerLeft,
                                      );
                                    }).toList();
                                  },
                                  changed: (index) {
                                    setState(() {
                                      provinceIndex = index;
                                      cityIndex = 0;
                                      areaIndex = 0;
                                      cityController.jumpToItem(0);
                                      areaController.jumpToItem(0);
                                      city = widget.data[provinceIndex]['sub'];
                                      area = widget.data[provinceIndex]['sub']
                                          [cityIndex]['sub'];
                                    });
                                  },
                                ),
                                new _MyCityPicker(
                                  key: Key('city'),
                                  controller: cityController,
                                  createWidgetList: () {
                                    return city.map((v) {
                                      return new Align(
                                        child: new Text(v['name'],
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 22 * factor)),
                                        alignment: Alignment.centerLeft,
                                      );
                                    }).toList();
                                  },
                                  changed: (index) {
                                    setState(() {
                                      cityIndex = index;
                                      areaIndex = 0;
                                      areaController.jumpToItem(0);
                                      area = widget.data[provinceIndex]['sub']
                                          [cityIndex]['sub'];
                                    });
                                  },
                                ),
                                new _MyCityPicker(
                                  key: Key('area'),
                                  controller: areaController,
                                  createWidgetList: () {
                                    return area.map((v) {
                                      return new Align(
                                        child: new Text(v['name'],
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 22 * factor)),
                                        alignment: Alignment.centerLeft,
                                      );
                                    }).toList();
                                  },
                                  changed: (index) {
                                    setState(() {
                                      areaIndex = index;
                                    });
                                  },
                                ),
                              ],
                            )
                          ],
                        )),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MyCityPicker extends StatefulWidget {
  final CreateWidgetList createWidgetList;
  final Key key;
  final FixedExtentScrollController controller;
  final ValueChanged<int> changed;

  _MyCityPicker(
      {this.createWidgetList, this.key, this.controller, this.changed});

  @override
  State createState() {
    return new _MyCityPickerState();
  }
}

class _MyCityPickerState extends State<_MyCityPicker> {
  List<Widget> children;

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width / 750;
    return new Expanded(
      child: new Container(
        padding: EdgeInsets.only(
          left: 20.0 * factor,
          right: 20.0 * factor,
          top: 10.0 * factor,
          bottom: 10.0 * factor,
        ),
        alignment: Alignment.center,
        height: 430.0 * factor,
        child: CupertinoPicker(
          backgroundColor: Colors.white,
          scrollController: widget.controller,
          key: widget.key,
          itemExtent: 50.0 * factor,
          onSelectedItemChanged: (index) {
            if (widget.changed != null) {
              widget.changed(index);
            }
          },
          children: widget.createWidgetList().length > 0
              ? widget.createWidgetList()
              : [new Text('')],
        ),
      ),
    );
  }
}

class _BottomPickerLayout extends SingleChildLayoutDelegate {
  _BottomPickerLayout(this.progress, this.factor,
      {this.itemCount, this.showTitleActions});

  final double progress;
  final double factor;
  final int itemCount;
  final bool showTitleActions;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    double maxHeight = 600.0;

    return new BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: 0.0,
      maxHeight: maxHeight * factor,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double height = size.height - childSize.height * progress;
    return new Offset(0.0, height);
  }

  @override
  bool shouldRelayout(_BottomPickerLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
