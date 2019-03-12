import 'dart:convert';

import 'package:meta/meta.dart';

class Company {
  int id;
  String logo; // logo
  String name; // 公司名称
  String province; // 公司位置
  String city; // 公司位置
  String area; // 公司位置
  String location; // 公司位置
  String type; // 公司性质
  String size; // 公司规模
  String employee; // 公司人数
  String hot; // 热招职位
  String count; // 职位总数
  String inc;   // 公司详情

  //构造函数
  Company({
    this.id,
    this.province,
    this.city,
    this.area,
    this.logo,
    @required this.name,
    @required this.location,
    @required this.type,
    @required this.size,
    @required this.employee,
    this.hot,
    this.count,
    @required this.inc
  });

  static List<Company> fromJson(String json) {
    List<Company> _companys = [];

    for (var value in new JsonDecoder().convert(json)['list']) {
      _companys.add(Company.fromMap(value));
    }
      return _companys;
  }

  static Company fromMap(Map map) {
    return new Company(
        id: map['id'],
        logo: map['logo'],
        name: map['name'],
        location: map['location'],
        type: map['type'],
        size: map['size'],
        employee: map['employee'],
        province: map['province'],
        city: map['city'],
        area: map['area'],
        hot: map['hot'],
        count: map['count'],
        inc: map['inc']
    );
  }
}