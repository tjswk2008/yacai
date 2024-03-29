import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

import './drapdown_common.dart';

typedef void DropdownMenuHeadTapCallback(int index);

typedef String GetItemLabel(dynamic data);

String defaultGetItemLabel(dynamic data) {
  if (data is String) return data;
  return data["title"];
}

class DropdownHeader extends DropdownWidget {
  final List<dynamic> titles;
  final int activeIndex;
  final DropdownMenuHeadTapCallback onTap;

  /// height of menu
  final double height;

  /// get label callback
  final GetItemLabel getItemLabel;

  DropdownHeader(
      {@required this.titles,
      this.activeIndex,
      DropdownMenuController controller,
      this.onTap,
      Key key,
      this.height: 46.0,
      GetItemLabel getItemLabel})
      : getItemLabel = getItemLabel ?? defaultGetItemLabel,
        assert(titles != null && titles.length > 0),
        super(key: key, controller: controller);

  @override
  DropdownState<DropdownWidget> createState() {
    return new _DropdownHeaderState();
  }
}

class _DropdownHeaderState extends DropdownState<DropdownHeader> {
  Widget buildItem(
      BuildContext context, dynamic title, bool selected, int index) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color unselectedColor = Theme.of(context).unselectedWidgetColor;
    final GetItemLabel getItemLabel = widget.getItemLabel;

    double factor = MediaQuery.of(context).size.width/750;

    return new GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: new Padding(
          padding: new EdgeInsets.fromLTRB(10.0*factor, 10.0*factor, 0.0*factor, 10.0*factor),
          child: new DecoratedBox(
              decoration: new BoxDecoration(
                border: new Border(right: Divider.createBorderSide(context, color: index == _titles.length - 1 ? Colors.transparent : Theme.of(context).dividerColor))
              ),
              child: new Center(
                  child: new Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                    new Text(
                      getItemLabel(title),
                      style: new TextStyle(
                        color: selected ? primaryColor : unselectedColor,
                        fontSize: 28*factor
                      ),
                    ),
                    new Icon(
                      selected ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: selected ? primaryColor : unselectedColor,
                      size: 34*factor,
                    )
                  ])))),
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap(index);

          return;
        }
        if (controller != null) {
          if (_activeIndex == index) {
            controller.hide();
            setState(() {
              _activeIndex = null;
            });
          } else {
            controller.show(index);
          }
        }
        //widget.onTap(index);
      },
    );
  }

  int _activeIndex;
  List<dynamic> _titles;

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    List<Widget> list = [];

    final int activeIndex = _activeIndex;
    final List<dynamic> titles = _titles;
    final double height = widget.height;

    for (int i = 0, c = widget.titles.length; i < c; ++i) {
      list.add(buildItem(context, titles[i], i == activeIndex, i));
    }

    list = list.map((Widget widget) {
      return new Expanded(
        child: widget,
      );
    }).toList();

    final Decoration decoration = new BoxDecoration(
      color: Colors.white,
      border: new Border(
        bottom: Divider.createBorderSide(context, color: Colors.grey[200]),
      ),
    );

    return Container(
      margin: EdgeInsets.only(bottom: 2.0*factor),
      padding: EdgeInsets.only(left: 20*factor, right: 20*factor),
      color: Colors.white,
      child: new DecoratedBox(
        decoration: decoration,
        child: new Container(
            child: new Row(
              children: list,
            ),
            height: height),
      )
    );
  }

  @override
  void initState() {
    _titles = widget.titles;
    super.initState();
  }

  @override
  void onEvent(DropdownEvent event) {
    switch (event) {
      case DropdownEvent.SELECT:
        {
          if (_activeIndex == null) return;

          setState(() {
            _activeIndex = null;
            String label = widget.getItemLabel(controller.data);
            if (_titles[controller.menuIndex] != '更多选项') {
              _titles[controller.menuIndex] = label;
            }
          });
        }
        break;
      case DropdownEvent.HIDE:
        {
          if (_activeIndex == null) return;
          setState(() {
            _activeIndex = null;
          });
        }
        break;
      case DropdownEvent.ACTIVE:
        {
          if (_activeIndex == controller.menuIndex) return;
          setState(() {
            _activeIndex = controller.menuIndex;
          });
        }
        break;
    }
  }
}
