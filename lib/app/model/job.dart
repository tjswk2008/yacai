import 'dart:convert';

import 'package:meta/meta.dart';

class Job {
  final String name;
  final String cname;
  final String salary;
  final String username;
  final String title;
  final String pub_time;

  Job(
      {@required this.name,
      @required this.cname,
      @required this.salary,
      @required this.username,
      @required this.title,
      @required this.pub_time});

  static List<Job> fromJson(String json) {
    List<Job> _jobs = [];
    for (var value in new JsonDecoder().convert(json)['list']) {
      _jobs.add(Job.fromMap(value));
    }
    return _jobs;
  }




  static Job fromMap(Map map) {
    return new Job(
        name: map['name'],
        cname: map['cname'],
        salary: map['salary'],
        username: map['username'],
        title: map['title'],
        pub_time: map['pub_time']);
  }
}
