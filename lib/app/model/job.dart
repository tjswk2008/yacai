import 'dart:convert';

import 'package:meta/meta.dart';

class Job {
  final String name; // 职位名称
  final String cname; // 公司名字
  final String salary; // 工资
  final String username; // 发布人
  final String title; // 发布人职位描述
  final String pubTime; // 发布时间
  final String addrSummarize; // 工作地点概述，用于职位详情页最上方显示出地标信息
  final String addrDetail; // 工作地点详情
  final String timereq; // 需要的工作年限
  final String academic; // 需要的学历
  final String detail; // 职位详情

  Job({
    @required this.name,
    @required this.cname,
    @required this.salary,
    @required this.username,
    @required this.title,
    @required this.pubTime,
    @required this.addrSummarize,
    @required this.addrDetail,
    @required this.timereq,
    @required this.academic,
    @required this.detail
  });

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
        pubTime: map['pubTime'],
        addrSummarize: map['addrSummarize'],
        addrDetail: map['addrDetail'],
        timereq: map['timereq'],
        academic: map['academic'],
        detail: map['detail'],
    );
  }
}
