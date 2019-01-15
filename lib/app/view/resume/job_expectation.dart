import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/resume.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

class JobExpectation extends StatefulWidget {

  final JobExpect _jobExpect;

  JobExpectation(this._jobExpect);

  @override
  JobExpectationState createState() => new JobExpectationState();
}

class JobExpectationState extends State<JobExpectation>
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
    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Row(
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: new Text(widget._jobExpect.jobTitle, style: new TextStyle(fontSize: 12.0),),
            ),
            new Text(widget._jobExpect.salary, style: new TextStyle(fontSize: 12.0),)
          ],
        ),
        new Row(
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: new Text(widget._jobExpect.city, style: new TextStyle(fontSize: 10.0, color: Colors.grey),),
            ),
            new Text(widget._jobExpect.industry, style: new TextStyle(fontSize: 10.0, color: Colors.grey),),
          ],
        ),
      ],
    );
  }
}