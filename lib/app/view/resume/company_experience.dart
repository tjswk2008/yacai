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
    return new Scaffold(
        backgroundColor: new Color.fromARGB(255, 242, 242, 245),
        body: new Stack(
          children: <Widget>[
            new SingleChildScrollView(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.only(top: 70.0),
                    ),
                    new Container(
                      color: Colors.white,
                      child: new Column(
                        children: <Widget>[
                          new Text(widget._companyExperience.cname)
                        ],
                      ),
                    )
                  ],
                )
            ),

            new Positioned(
              top: 10.0,
              left: -10.0,
              child: new Container(
                  padding: const EdgeInsets.all(15.0),
                  child: new BackButton(color: Colors.grey)
              ),
            ),
          ],
        )
    );
  }
}