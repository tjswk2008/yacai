import 'package:flutter/material.dart';

class CommonButton extends StatefulWidget {
  final String text;
  final GestureTapCallback onTap;
  
  CommonButton({@required this.text, @required this.onTap});
  
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
          color: new Color.fromARGB(255, 242, 242, 245),
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