import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CompanyHotJob extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    double screenWidthInPt = MediaQuery.of(context).size.width;
    return new Padding(
        padding: EdgeInsets.only(
          top: 20.0*screenWidthInPt/750,
          left: 20.0*screenWidthInPt/750,
          right: 20.0*screenWidthInPt/750,
          bottom: 20.0*screenWidthInPt/750,
        ),
        child: new Row(
          children: <Widget>[
            new RichText(
              text: new TextSpan(
                text: '敬请期待',
                style: new TextStyle(
                    fontSize: 26.0*screenWidthInPt/750,
                    color: Colors.black
                ),
              ),
            )
          ],
        )
    );
  }
}