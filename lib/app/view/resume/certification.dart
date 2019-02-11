import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:flutter_app/app/view/resume/certification_edit.dart';
import 'package:date_format/date_format.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

class CertificationView extends StatefulWidget {

  final Certification _certification;

  CertificationView(this._certification);

  @override
  CertificationViewState createState() => new CertificationViewState();
}

class CertificationViewState extends State<CertificationView>
    with TickerProviderStateMixin {

  VoidCallback onChanged;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle detailStyle = new TextStyle(fontSize: 10.0, color: Colors.grey);
    return new InkWell(
      onTap: () {
        Navigator.of(context).push(new PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) {
            return new CertificationEditView(widget._certification);
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
        ));
      },
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new Text(widget._certification.name, style: new TextStyle(fontSize: 12.0) ),
                  new Text("(${widget._certification.code})", style: detailStyle),
                ],
              ),
              new Text(
                formatDate(DateTime.parse(widget._certification.qualifiedTime), [yyyy, '-', mm]),
                style: detailStyle
              ),
            ]
          ),
          new Text(widget._certification.industry, style: detailStyle),
          new Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
          ),
          new Divider()
        ],
      ),
    );
  }
}