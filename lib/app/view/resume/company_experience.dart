import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/resume.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

class CompanyExperienceView extends StatefulWidget {

  final CompanyExperience _companyExperience;

  CompanyExperienceView(this._companyExperience);

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
    return new Container(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(widget._companyExperience.cname, style: new TextStyle(fontSize: 12.0) ),
              new Text(
                "${widget._companyExperience.startTime}-${widget._companyExperience.endTime}",
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