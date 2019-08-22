import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:flutter_app/app/view/resume/project_edit.dart';
import 'package:date_format/date_format.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

class ProjectView extends StatefulWidget {

  final Project _project;
  final bool _editable;

  ProjectView(this._project, this._editable);

  @override
  ProjectViewState createState() => new ProjectViewState();
}

class ProjectViewState extends State<ProjectView>
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
    TextStyle detailStyle = new TextStyle(fontSize: 26.0*factor, color: Colors.grey);
    return new InkWell(
      onTap: () {
        if(!widget._editable) return;
        Navigator.of(context).push(new PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) {
            return new ProjectEditView(widget._project);
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
          Container(height: 20*factor,),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(widget._project.name, style: new TextStyle(fontSize: 28.0*factor) ),
              new Text(
                "${formatDate(DateTime.parse(widget._project.startTime), [yyyy, '-', mm, '-', dd])}-${widget._project.endTime == null ? '至今' : formatDate(DateTime.parse(widget._project.endTime), [yyyy, '-', mm, '-', dd])}",
                style: detailStyle
              ),
            ]
          ),
          Container(height: 20*factor,),
          new Text(widget._project.role, style: detailStyle),
          new Padding(
            padding: EdgeInsets.only(bottom: 20.0*factor),
          ),
          new Text(widget._project.detail, style: new TextStyle(fontSize: 26.0*factor)),
          Container(height: 20*factor,),
        ],
      ),
    );
  }
}