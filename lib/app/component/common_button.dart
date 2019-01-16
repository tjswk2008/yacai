import 'package:flutter/material.dart';

class CommonButton extends StatefulWidget {
  final String text;
  final Color color;
  final GestureTapCallback onTap;
  
  CommonButton({@required this.text, @required this.onTap, @required this.color});
  
  @override
  State<StatefulWidget> createState() => CommonButtonState();
}

class CommonButtonState extends State<CommonButton> {

  TextStyle textStyle = new TextStyle(color: Colors.white, fontSize: 17);

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: () {
        this.widget.onTap();
      },
      child: new Container(
        height: 45,
        decoration: new BoxDecoration(
          color: this.widget.color,
          border: new Border.all(color: const Color(0xffcccccc)),
          borderRadius: new BorderRadius.all(new Radius.circular(30))
        ),
        child: new Center(
          child: new Text(this.widget.text, style: textStyle,),
        ),
      ),
    );
  }
}