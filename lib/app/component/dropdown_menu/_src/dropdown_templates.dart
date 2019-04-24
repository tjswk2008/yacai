import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';

import './dropdown_header.dart';

Widget buildCheckItem(BuildContext context, dynamic data, bool selected, List<int> subIndexs) {
  double factor = MediaQuery.of(context).size.width/750;
  return new Padding(
      padding: new EdgeInsets.all(10.0*factor),
      child: new Row(
        children: <Widget>[
          new Text(
            defaultGetItemLabel(data),
            style: selected
                ? new TextStyle(
                    fontSize: 24.0*factor,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w400)
                : new TextStyle(fontSize: 24.0*factor),
          ),
          new Expanded(
              child: new Align(
            alignment: Alignment.centerRight,
            child: selected
                ? new Icon(
                    Icons.check,
                    color: Theme.of(context).primaryColor,
                    size: 30*factor
                  )
                : null,
          )),
        ],
      ));
}
