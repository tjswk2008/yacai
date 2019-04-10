import 'package:meta/meta.dart';
import './job.dart';

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
  String idBack; // 身份证背面照
  String idFront; // 身份证正面照
  String corporator; // 法人姓名
  String idCard; // 法人身份证号码
  String license; // 营业执照 
  int verified;
  int blocked;
  String reason; // 未通过认证原因
  List<Job> jobs;
  List<String> imgs;

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
    @required this.inc,
    this.jobs,
    this.idBack, // 身份证背面照
    this.idFront, // 身份证正面照
    this.corporator, // 法人姓名
    this.idCard, // 法人身份证号码
    this.license,
    this.verified,
    this.blocked,
    this.reason,
    this.imgs = const <String>[]
  });

  static List<Company> fromJson(List list) {
    List<Company> _companys = [];

    for (var value in list) {
      _companys.add(Company.fromMap(value));
    }
    return _companys;
  }

  static List<String> convertToStringList(List list) {
    List<String> _imgs = [];

    if (list != null) {
      for (var value in list) {
        _imgs.add(value);
      }
      return _imgs;
    }
    return [];
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
        inc: map['inc'],
        jobs: Job.fromJson(map['jobs']),
        idBack: map['idBack'], // 身份证背面照
        idFront: map['idFront'], // 身份证正面照
        corporator: map['corporator'], // 法人姓名
        idCard: map['idCard'], // 法人身份证号码
        license: map['license'],
        verified: map['verified'],
        blocked: map['blocked'],
        reason: map['reason'],
        imgs: convertToStringList(map['imgs'])
    );
  }
}