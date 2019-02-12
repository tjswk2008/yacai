// import 'package:meta/meta.dart';

class Resume {
  PersonalInfo personalInfo; // 个人信息
  String jobStatus; // 求职状态
  JobExpect jobExpect; // 求职期望
  List<CompanyExperience> companyExperiences; // 工作经历
  List<Project> projects; // 项目经历
  List<Education> educations; // 教育经历
  List<Certification> certificates; // 证书列表

  Resume({
    this.personalInfo,
    this.jobStatus,
    this.jobExpect,
    this.companyExperiences,
    this.projects,
    this.educations,
    this.certificates
  });

  static Resume fromMap(Map map) {
    return new Resume(
        personalInfo: PersonalInfo.fromMap(map),
        jobStatus: map['jobStatus'],
        jobExpect: JobExpect.fromMap(map),
        companyExperiences: CompanyExperience.fromList(map['companyExperience']),
        projects: Project.fromList(map['project']),
        educations: Education.fromList(map['education']),
        certificates: Certification.fromList(map['certification']),
    );
  }
}

class Education{
  int id;
  String name; // 学校名称
  String academic; // 学历
  String major; // 专业
  String endTime; // 就读该学校的结束时间
  String startTime; // 就读该学校的开始时间
  String detail; // 在校经历

  Education({
    this.id,
    this.name,
    this.academic,
    this.startTime,
    this.endTime,
    this.major,
    this.detail
  });

  static List<Education> fromList(List list) {
    List<Education> _educations = [];
    for (var value in list) {
      _educations.add(Education.fromMap(value));
    }
    return _educations;
  }

  static Education fromMap(Map map) {
    return new Education(
        id: map['id'],
        name: map['name'],
        academic: map['academic'],
        startTime: map['startTime'],
        endTime: map['endTime'],
        major: map['major'],
        detail: map['detail']
    );
  }
}

class Certification{
  int id;
  String name; // 证书名
  String industry; // 颁发单位
  String qualifiedTime; // 取得时间
  String code; // 证书编号

  Certification({
    this.id,
    this.name,
    this.industry,
    this.qualifiedTime,
    this.code
  });

  static List<Certification> fromList(List list) {
    List<Certification> _certifications = [];
    for (var value in list) {
      _certifications.add(Certification.fromMap(value));
    }
    return _certifications;
  }

  static Certification fromMap(Map map) {
    return new Certification(
        id: map['id'],
        name: map['name'],
        industry: map['industry'],
        qualifiedTime: map['qualifiedTime'],
        code: map['code']
    );
  }
}

class Project{
  int id;
  String name; // 项目名称
  String role; // 角色
  String startTime; // 该项目的开始时间
  String endTime; // 该项目的结束时间
  String detail; // 项目描述
  String performance; // 业绩

  Project({
    this.id,
    this.name,
    this.role,
    this.startTime,
    this.endTime,
    this.detail,
    this.performance
  });

  static List<Project> fromList(List list) {
    List<Project> _projects = [];
    for (var value in list) {
      _projects.add(Project.fromMap(value));
    }
    return _projects;
  }

  static Project fromMap(Map map) {
    return new Project(
        id: map['id'],
        name: map['name'],
        role: map['role'],
        startTime: map['startTime'],
        endTime: map['endTime'],
        detail: map['detail'],
        performance: map['performance']
    );
  }
}

class CompanyExperience{
  int id;
  String cname; // 公司名称
  String industry; // 行业
  String startTime; // 该单位的工作开始时间
  String endTime; // 该单位的工作结束时间
  String jobTitle; // 职位名称
  String detail; // 工作内容
  String performance; // 业绩

  CompanyExperience({
    this.id,
    this.cname,
    this.industry,
    this.startTime,
    this.endTime,
    this.jobTitle,
    this.detail,
    this.performance
  });

  static List<CompanyExperience> fromList(List list) {
    List<CompanyExperience> _companyExperiences = [];
    for (var value in list) {
      _companyExperiences.add(CompanyExperience.fromMap(value));
    }
    return _companyExperiences;
  }

  static CompanyExperience fromMap(Map map) {
    return new CompanyExperience(
        id: map['id'],
        cname: map['cname'],
        industry: map['industry'],
        startTime: map['startTime'],
        endTime: map['endTime'],
        jobTitle: map['jobTitle'],
        detail: map['detail'],
        performance: map['performance']
    );
  }
}

class JobExpect{
  int id;
  String jobTitle; // 职位
  String industry; // 行业
  String city; // 工作城市
  String salary; // 薪资待遇

  JobExpect({
    this.id,
    this.jobTitle,
    this.industry,
    this.city,
    this.salary
  });

  static JobExpect fromMap(Map map) {
    return new JobExpect(
        id: map['id'],
        jobTitle: map['expectJobTitle'],
        industry: map['expectIndustry'],
        city: map['expectCity'],
        salary: map['expectSalary']
    );
  }
}

class PersonalInfo {
  int id;
  String name; // 姓名
  String gender; // 性别
  String firstJobTime; // 首次参加工作时间
  String avatar; // 头像
  String wechatId; // 微信号
  String birthDay; // 出生年月
  String summarize; // 优势
  String academic; // 学历

  PersonalInfo({
    this.id,
    this.name,
    this.gender,
    this.firstJobTime,
    this.avatar,
    this.wechatId,
    this.birthDay,
    this.summarize,
    this.academic,
  });

  static List<PersonalInfo> fromList(List list) {
    List<PersonalInfo> _personalInfos = [];
    for (var value in list) {
      _personalInfos.add(PersonalInfo.fromMap(value));
    }
    return _personalInfos;
  }

  static PersonalInfo fromMap(Map map) {
    return new PersonalInfo(
        id: map['id'],
        name: map['name'],
        gender: map['gender'],
        firstJobTime: map['firstJobTime'],
        avatar: map['avatar'],
        wechatId: map['wechatId'],
        birthDay: map['birthDay'],
        summarize: map['summarize'],
        academic: map['academic']
    );
  }
}
