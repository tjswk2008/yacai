import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:flutter_app/app/model/constants.dart';
import 'package:flutter_app/app/view/resume/job_expectation_edit.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

class JobExpectation extends StatefulWidget {

  final JobExpect _jobExpect;
  final bool _editable;

  JobExpectation(this._jobExpect, this._editable);

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
    double factor = MediaQuery.of(context).size.width/750;
    return new InkWell(
      onTap: () {
        if(!widget._editable) return;
        Navigator.of(context).push(new PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) {
            return new JobExpectationEdit(widget._jobExpect);
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(right: 10.0*factor),
                child: new Text(widget._jobExpect.jobTitle == null ? '期望职位' : widget._jobExpect.jobTitle, style: new TextStyle(fontSize: 22.0*factor),),
              ),
              new Text(widget._jobExpect.salary == null ? '期望薪资' : widget._jobExpect.salary, style: new TextStyle(fontSize: 22.0*factor),),
              new Padding(
                padding: EdgeInsets.only(left: 20.0*factor),
                child: new Text(widget._jobExpect.type == null ? '期望工作类型' : jobTypeArr[widget._jobExpect.type - 1], style: new TextStyle(fontSize: 22.0*factor),),
              )
            ],
          ),
          new Row(
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(right: 10.0*factor),
                child: new Text(widget._jobExpect.city == null ? '期望城市' : widget._jobExpect.city, style: new TextStyle(fontSize: 22.0*factor, color: Colors.grey),),
              ),
              new Text(widget._jobExpect.industry == null ? '期望行业' : widget._jobExpect.industry, style: new TextStyle(fontSize: 22.0*factor, color: Colors.grey),),
            ],
          ),
        ],
      )
    );
  }
}