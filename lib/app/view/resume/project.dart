import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/resume.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

class ProjectView extends StatefulWidget {

  final Project _project;

  ProjectView(this._project);

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
    TextStyle detailStyle = new TextStyle(fontSize: 10.0, color: Colors.grey);
    return new Container(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(widget._project.name, style: new TextStyle(fontSize: 12.0) ),
              new Text(
                "${widget._project.startTime}-${widget._project.endTime}",
                style: detailStyle
              ),
            ]
          ),
          new Text(widget._project.role, style: detailStyle),
          new Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
          ),
          new Text(widget._project.detail, style: new TextStyle(fontSize: 12.0)),
        ],
      ),
    );
  }
}