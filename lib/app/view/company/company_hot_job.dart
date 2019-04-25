import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/job.dart';
import 'package:flutter_app/app/item/joblist_item.dart';
import 'package:flutter_app/app/view/job/job_detail.dart';

class CompanyHotJob extends StatelessWidget {

  final List<Job> _jobs;

  CompanyHotJob(this._jobs);

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return new Padding(
        padding: EdgeInsets.only(
          top: 20.0*factor,
          left: 10.0*factor,
          right: 10.0*factor,
        ),
        child: new ListView.builder(
          itemCount: _jobs.length, itemBuilder: buildJobItem)
    );
  }

  Widget buildJobItem(BuildContext context, int index) {
    Job job = _jobs[index];

    var jobItem = new InkWell(
        onTap: () {
          Navigator.of(context).push(new PageRouteBuilder(
              opaque: false,
              pageBuilder: (BuildContext context, _, __) {
                return new JobDetail(job);
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
        child: new JobListItem(job, false));

    return jobItem;
  }
}