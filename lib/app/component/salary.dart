import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef void ChangeData(int);
typedef List<Widget> CreateWidgetList();

List<int> data = [
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  11,
  12,
  13,
  14,
  15,
  16,
  17,
  18,
  19,
  20,
  25,
  30,
  35,
  40,
  45,
  50,
  55,
  60,
  65,
  70,
  75,
  80,
  90,
  100,
  150,
  200,
  250,
  300,
  400,
  500,
  600,
  700,
  800
];

class SalaryPicker {
  static void showSalaryPicker(
    BuildContext context, {
    ChangeData selectStart,
    ChangeData selectEnd,
  }) {
    Navigator.push(
      context,
      new _SalaryPickerRoute(
          selectStart: selectStart,
          selectEnd: selectEnd,
          theme: Theme.of(context),
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel),
    );
  }
}

class _SalaryPickerRoute<T> extends PopupRoute<T> {
  final ThemeData theme;
  final String barrierLabel;
  final ChangeData selectStart;
  final ChangeData selectEnd;

  _SalaryPickerRoute({
    this.theme,
    this.barrierLabel,
    this.selectStart,
    this.selectEnd,
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
      child: new _SalaryPickerWidget(
        route: this,
        data: data,
        selectStart: selectStart,
        selectEnd: selectEnd,
      ),
    );
    if (theme != null) {
      bottomSheet = new Theme(data: theme, child: bottomSheet);
    }
    return bottomSheet;
  }
}

class _SalaryPickerWidget extends StatefulWidget {
  final _SalaryPickerRoute route;
  final List data;
  final ChangeData selectStart;
  final ChangeData selectEnd;

  _SalaryPickerWidget(
      {Key key,
      @required this.route,
      this.data,
      this.selectStart,
      this.selectEnd});

  @override
  State createState() {
    return new _SalaryPickerState();
  }
}

class _SalaryPickerState extends State<_SalaryPickerWidget> {
  FixedExtentScrollController startController;
  FixedExtentScrollController endController;
  int startIndex = 0, endIndex = 0;
  List start = [];
  List end = [];
  List endSource;

  @override
  void initState() {
    super.initState();
    startController = new FixedExtentScrollController();
    endController = new FixedExtentScrollController();
    setState(() {
      endSource = widget.data.sublist(0);
      endSource.add(999);
      start = widget.data;
      end = endSource.sublist(1);
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
              delegate: new _BottomPickerLayout(widget.route.animation.value),
              child: new GestureDetector(
                child: new Material(
                  color: Colors.transparent,
                  child: new Container(
                    width: double.infinity,
                    height: 520.0 * factor,
                    child: new Container(
                        width: double.infinity,
                        color: Colors.white,
                        child: new Column(
                          children: <Widget>[
                            new Expanded(
                              child: new Row(
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
                                      if (widget.selectStart != null) {
                                        widget.selectStart(start[startIndex]);
                                      }
                                      if (widget.selectEnd != null) {
                                        widget.selectEnd(end[endIndex]);
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
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                              ),
                              flex: 1,
                            ),
                            new Row(
                              children: <Widget>[
                                new _MySalaryPicker(
                                  key: Key('start'),
                                  controller: startController,
                                  createWidgetList: () {
                                    return start.map((v) {
                                      return new Align(
                                        child: new Text(v.toString() + 'K',
                                            style: TextStyle(
                                                fontSize: 24 * factor)),
                                        alignment: Alignment.centerLeft,
                                      );
                                    }).toList();
                                  },
                                  changed: (index) {
                                    setState(() {
                                      startIndex = index;
                                      endIndex = 0;
                                      endController.jumpToItem(0);
                                      end = endSource.sublist(index + 1);
                                    });
                                  },
                                ),
                                new _MySalaryPicker(
                                  key: Key('end'),
                                  controller: endController,
                                  createWidgetList: () {
                                    return end.map((v) {
                                      return new Align(
                                        child: new Text(v.toString() + 'K',
                                            style: TextStyle(
                                                fontSize: 24 * factor)),
                                        alignment: Alignment.centerLeft,
                                      );
                                    }).toList();
                                  },
                                  changed: (index) {
                                    setState(() {
                                      endIndex = index;
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

class _MySalaryPicker extends StatefulWidget {
  final CreateWidgetList createWidgetList;
  final Key key;
  final FixedExtentScrollController controller;
  final ValueChanged<int> changed;

  _MySalaryPicker(
      {this.createWidgetList, this.key, this.controller, this.changed});

  @override
  State createState() {
    return new _MySalaryPickerState();
  }
}

class _MySalaryPickerState extends State<_MySalaryPicker> {
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
      flex: 1,
    );
  }
}

class _BottomPickerLayout extends SingleChildLayoutDelegate {
  _BottomPickerLayout(this.progress, {this.itemCount, this.showTitleActions});

  final double progress;
  final int itemCount;
  final bool showTitleActions;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    double maxHeight = 600.0;

    return new BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: 0.0,
      maxHeight: maxHeight,
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
