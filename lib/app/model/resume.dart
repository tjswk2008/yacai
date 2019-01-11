// import 'package:meta/meta.dart';

class Resume {
  final PersonalInfo personalInfo; // 个人信息
  final String jobStatus; // 求职状态
  final JobExpect jobExpect; // 求职期望
  final List<CompanyExperience> companyExperiences; // 工作经历
  final List<Project> projects; // 项目经历
  final List<Education> educations; // 教育经历
  final List<Certification> certificates; // 证书列表

  Resume({
    this.personalInfo,
    this.jobStatus,
    this.jobExpect,
    this.companyExperiences,
    this.projects,
    this.educations,
    this.certificates
  });
}

class Education{
  String name; // 学校名称
  String academic; // 学历
  String major; // 专业
  String endTime; // 就读该学校的结束时间
  String startTime; // 就读该学校的开始时间
  String detail; // 在校经历

  Education({
    this.name,
    this.academic,
    this.startTime,
    this.endTime,
    this.major,
    this.detail
  });
}

class Certification{
  String name; // 证书名
  String industry; // 颁发单位
  String qualifiedTime; // 取得时间
  String code; // 证书编号

  Certification({
    this.name,
    this.industry,
    this.qualifiedTime,
    this.code
  });
}

class Project{
  String name; // 项目名称
  String role; // 角色
  String startTime; // 该项目的开始时间
  String endTime; // 该项目的结束时间
  String detail; // 项目描述
  String performance; // 业绩

  Project({
    this.name,
    this.role,
    this.startTime,
    this.endTime,
    this.detail,
    this.performance
  });
}

class CompanyExperience{
  String cname; // 公司名称
  String industry; // 行业
  String startTime; // 该单位的工作开始时间
  String endTime; // 该单位的工作结束时间
  String jobTitle; // 职位名称
  String detail; // 工作内容
  String performance; // 业绩

  CompanyExperience({
    this.cname,
    this.industry,
    this.startTime,
    this.endTime,
    this.jobTitle,
    this.detail,
    this.performance
  });
}

class JobExpect{
  String jobTitle; // 职位
  String industry; // 行业
  String city; // 工作城市
  String salary; // 薪资待遇

  JobExpect({
    this.jobTitle,
    this.industry,
    this.city,
    this.salary
  });
}

class PersonalInfo {
  String name; // 姓名
  String gender; // 性别
  String firstJobTime; // 首次参加工作时间
  String avatar; // 头像
  String wechatId; // 微信号
  String birthDay; // 出生年月
  String summarize; // 优势

  PersonalInfo({
    this.name,
    this.gender,
    this.firstJobTime,
    this.avatar,
    this.wechatId,
    this.birthDay,
    this.summarize
  });
}
