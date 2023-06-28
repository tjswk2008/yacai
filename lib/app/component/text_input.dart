import 'package:flutter/material.dart';

class TextInputCP extends StatefulWidget {
  /// List of Widgets you'll display after you tap the child
  String text;

  TextInputCP({
    @required this.text,
  });

  @override
  State<StatefulWidget> createState() => TextInputCPState();
}

class TextInputCPState extends State<TextInputCP> {
  bool isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width / 750;
    return new Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        leading: IconButton(
            icon: const BackButtonIcon(),
            iconSize: 40 * factor,
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: () {
              Navigator.maybePop(context);
            }),
        title: new Text('编辑内容',
            style: new TextStyle(fontSize: 30.0 * factor, color: Colors.white)),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(50 * factor),
            child: TextField(
              maxLines: 20,
              keyboardType: TextInputType.multiline,
              controller: TextEditingController.fromValue(TextEditingValue(
                  text: widget.text,
                  selection: TextSelection.fromPosition(TextPosition(
                      affinity: TextAffinity.downstream,
                      offset: widget.text.length)))),
              onChanged: (val) {
                setState(() {
                  widget.text = val;
                });
              },
              style: TextStyle(fontSize: 26.0 * factor, height: 1.6),
              decoration: new InputDecoration(
                  hintText: "请输入",
                  hintStyle: new TextStyle(
                      color: const Color(0xFF808080), fontSize: 26.0 * factor),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(20.0 * factor)),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          mini: true,
          child: Icon(
            Icons.check,
            color: Colors.white,
            size: 50 * factor,
          ),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () async {
            Navigator.pop(context, widget.text);
          }),
    );
  }
}
