import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:flutter_app/app/view/resume/company_experience_edit.dart';
import 'package:date_format/date_format.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

class CompanyExperienceView extends StatefulWidget {

  final CompanyExperience _companyExperience;
  final bool _editable;

  CompanyExperienceView(this._companyExperience, this._editable);

  @override
  CompanyExperienceViewState createState() => new CompanyExperienceViewState();
}

class CompanyExperienceViewState extends State<CompanyExperienceView>
    with TickerProviderStateMixin {

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
        if(!widget._editable) return;
        Navigator.of(context).push(new PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) {
            return new CompanyExperienceEditView(widget._companyExperience);
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
              new Text(widget._companyExperience.cname, style: new TextStyle(fontSize: 12.0) ),
              new Text(
                "${formatDate(DateTime.parse(widget._companyExperience.startTime), [yyyy, '-', mm, '-', dd])}-${widget._companyExperience.endTime == null ? '至今' : formatDate(DateTime.parse(widget._companyExperience.endTime), [yyyy, '-', mm, '-', dd])}",
                style: detailStyle
              ),
            ]
          ),
          new Text(widget._companyExperience.jobTitle, style: detailStyle),
          new Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
          ),
          new Text(widget._companyExperience.detail, style: new TextStyle(fontSize: 12.0)),
        ],
      ),
    );
  }
}