import 'package:flutter/material.dart';
import './text_input.dart';

class TextArea extends StatefulWidget {
  /// List of Widgets you'll display after you tap the child
  final String text;

  final Function callback;
  
  TextArea({
    @required this.text,
    @required this.callback
  });
  
  @override
  State<StatefulWidget> createState() => TextAreaState();
}

class TextAreaState extends State<TextArea> {
  bool isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 600*factor,
            margin: EdgeInsets.symmetric(vertical: 20*factor),
            child: Text(
              widget.text == '' ? '请输入内容' : widget.text,
              style: TextStyle(fontSize: 26.0*factor, color: widget.text == '' ? Colors.grey[400] : Colors.grey[800]),
              overflow: TextOverflow.ellipsis
            ),
          ),
          Icon(Icons.chevron_right, size: 32*factor)
        ],
      ),
      onTap: () {
        Navigator.of(context).push(new PageRouteBuilder(
            opaque: false,
            pageBuilder: (BuildContext context, _, __) {
              return new TextInputCP(text: widget.text);
            },
            transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
              return new FadeTransition(
                opacity: animation,
                child: new SlideTransition(position: new Tween<Offset>(
                  begin: const Offset(0.0, 1.0),
                  end: Offset.zero,
                ).animate(animation), child: child),
              );
            }
        )).then((onValue) => {
          if(onValue != null) {
            widget.callback(onValue)
          }
        });
      },
    );
  }
}