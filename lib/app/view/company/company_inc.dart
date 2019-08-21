import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CompanyInc extends StatelessWidget {

  final String _companyInc;

  CompanyInc(this._companyInc);

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return new Padding(
      padding: EdgeInsets.only(
        top: 10.0*factor,
        left: 10.0*factor,
        right: 10.0*factor,
        bottom: 10.0*factor,
      ),
      child: CustomScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          new SliverPadding(
            padding: EdgeInsets.all(20.0 * factor),
            sliver: new SliverList(
              delegate: new SliverChildListDelegate(
                <Widget>[
                  new Container(
                    color: Colors.white,
                    child: new Padding(
                        padding: EdgeInsets.all(15.0*factor),
                        child: new Column(
                          children: <Widget>[
                            new Row(
                              children: <Widget>[
                                new Container(
                                  margin: EdgeInsets.only(bottom: 30.0*factor),
                                  child: new Text(
                                      '公司介绍', style: new TextStyle(fontSize: 30.0*factor)),
                                )
                              ],
                            ),
                            RichText(
                              text: new TextSpan(
                                text: _companyInc,
                                style: new TextStyle(
                                    fontSize: 26.0*factor,
                                    color: Colors.grey[700],
                                    height: 1.6
                                ),
                              ),
                            ),
                          ],
                        )
                    )
                ),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}