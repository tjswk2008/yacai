import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:flutter_app/app/view/resume/education_edit.dart';
import 'package:date_format/date_format.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

class EducationView extends StatefulWidget {

  final Education _education;
  final bool _editable;

  EducationView(this._education, this._editable);

  @override
  EducationViewState createState() => new EducationViewState();
}

class EducationViewState extends State<EducationView>
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
    double factor = MediaQuery.of(context).size.width/750;
    TextStyle detailStyle = new TextStyle(fontSize: 22.0*factor, color: Colors.grey);
    return new InkWell(
      onTap: () {
        if(!widget._editable) return;
        Navigator.of(context).push(new PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) {
            return new EducationEditView(widget._education);
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
              new Text(widget._education.name, style: new TextStyle(fontSize: 24.0*factor) ),
              new Text(
                "${formatDate(DateTime.parse(widget._education.startTime), [yyyy, '-', mm])}-${widget._education.endTime == null ? '至今' : formatDate(DateTime.parse(widget._education.endTime), [yyyy, '-', mm])}",
                style: detailStyle
              ),
            ]
          ),
          new Text(widget._education.major, style: detailStyle),
          new Padding(
            padding: EdgeInsets.only(bottom: 5.0*factor),
          ),
          new Text(widget._education.detail, style: new TextStyle(fontSize: 22.0*factor)),
        ],
      ),
    );
  }
}