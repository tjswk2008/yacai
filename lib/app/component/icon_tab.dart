import 'package:flutter/material.dart';

class IconTab extends StatefulWidget {

  const IconTab({
    Key key,
    this.text,
    this.icon,
    this.color,
    this.iconData,
  })
    : assert(text != null || !(icon == null && iconData == null) || color != null),
      super(key: key);

  final String text;
  final String icon;
  final Widget iconData;
  final Color color;

  @override
  State<StatefulWidget> createState() {
    return new IconTabState();
  }
}

class IconTabState extends State<IconTab> {

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    double factor = MediaQuery.of(context).size.width/750;
    Widget label = new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Container(
          child: widget.icon != null ? new Image(
            image: new AssetImage(widget.icon),
            height: 50.0*factor,
            width: 50.0*factor,
          ) : new Container(
            height: 50.0*factor,
            child: widget.iconData,
          ),
          margin: EdgeInsets.only(bottom: 10.0*factor),
        ),
        Text(widget.text,
          softWrap: false,
          overflow: TextOverflow.fade,
          style: new TextStyle(color: widget.color, fontSize: 28.0*factor),
        )
      ]
    );

    return new SizedBox(
      height: 110*factor,
      child: new Center(
        child: label,
        widthFactor: 1.0,
      ),
    );
  }

}