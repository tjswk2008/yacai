import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef void ChangeData(int);
typedef List<Widget> CreateWidgetList();

class YCPicker {
  static void showYCPicker(
    BuildContext context, {
    List<String> data,
    ChangeData selectItem,
  }) {
    Navigator.push(
        context,
        new _YCPickerRoute(
            selectItem: selectItem,
            data: data,
            theme: Theme.of(context, shadowThemeOnly: true),
            barrierLabel:
                MaterialLocalizations.of(context).modalBarrierDismissLabel),
      );
  }
}

class _YCPickerRoute<T> extends PopupRoute<T> {
  final ThemeData theme;
  final String barrierLabel;
  final ChangeData selectItem;
  final List<String> data;

  _YCPickerRoute({
    this.theme,
    this.barrierLabel,
    this.selectItem,
    this.data
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
      child: new _YCPickerWidget(
        route: this,
        data: data,
        selectItem: selectItem,
      ),
    );
    if (theme != null) {
      bottomSheet = new Theme(data: theme, child: bottomSheet);
    }
    return bottomSheet;
  }
}

class _YCPickerWidget extends StatefulWidget {
  final _YCPickerRoute route;
  final List data;
  final ChangeData selectItem;
  final ChangeData selectEnd;

  _YCPickerWidget(
    {
      Key key,
      @required this.route,
      this.data,
      this.selectItem,
      this.selectEnd
    }
  );

  @override
  State createState() {
    return new _YCPickerState();
  }
}

class _YCPickerState extends State<_YCPickerWidget> {
  FixedExtentScrollController startController;
  FixedExtentScrollController endController;
  int startIndex = 0;
  List start = new List();
  

  @override
  void initState() {
    super.initState();
    startController = new FixedExtentScrollController();
    setState(() {
      start = widget.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
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
                    height: 520.0*factor,
                    child: new Container(
                      width: double.infinity,
                      color: Colors.white,
                      child: new Column(
                        children: <Widget>[
                          new Expanded(
                            child: new Row(
                              children: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: new Text(
                                    '取消',
                                    style: new TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 24*factor
                                    ),
                                  ),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    if (widget.selectItem != null) {
                                      widget.selectItem(start[startIndex]);
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: new Text(
                                    '确定',
                                    style: new TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 24*factor
                                    ),
                                  ),
                                ),
                              ],
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            flex: 1,
                          ),
                          new Row(
                            children: <Widget>[
                              new _MyYCPicker(
                                key: Key('start'),
                                controller: startController,
                                createWidgetList: () {
                                  return start.map((v) {
                                    return new Align(
                                      child: new Text(
                                        v,
                                        style:TextStyle(fontSize: 24*factor)
                                      ),
                                      alignment: Alignment.center,
                                    );
                                  }).toList();
                                },
                                changed: (index) {
                                  setState(() {
                                    startIndex = index;
                                    endController.jumpToItem(0);
                                  });
                                },
                              )
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

class _MyYCPicker extends StatefulWidget {
  final CreateWidgetList createWidgetList;
  final Key key;
  final FixedExtentScrollController controller;
  final ValueChanged<int> changed;

  _MyYCPicker(
      {this.createWidgetList, this.key, this.controller, this.changed});

  @override
  State createState() {
    return new _MyYCPickerState();
  }
}

class _MyYCPickerState extends State<_MyYCPicker> {
  List<Widget> children;

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return new Expanded(
      child: new Container(
        padding: EdgeInsets.only(
          left: 20.0*factor,
          right: 20.0*factor,
          top: 10.0*factor,
          bottom: 10.0*factor,
        ),
        alignment: Alignment.center,
        height: 430.0*factor,
        child: CupertinoPicker(
          backgroundColor: Colors.white,
          scrollController: widget.controller,
          key: widget.key,
          itemExtent: 50.0*factor,
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