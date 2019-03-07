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

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return new InkWell(
      onTap: () {
        this.widget.onTap();
      },
      child: new Container(
        height: 70*factor,
        decoration: new BoxDecoration(
          color: this.widget.color,
          // borderRadius: new BorderRadius.all(new Radius.circular(30))
        ),
        child: new Center(
          child: new Text(this.widget.text, style: TextStyle(
              color: Colors.white,
              fontSize: 28*factor,
              letterSpacing: 40*factor
            )
          ),
        ),
      ),
    );
  }
}