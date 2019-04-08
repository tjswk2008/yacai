import 'package:dio/dio.dart';
import 'dart:io';
class Api {
  final String serverAddr = Platform.isAndroid ? "http://192.168.140.56:3000/api/" : "http://localhost:3000/api/";

  // user interface
  Future<Response<T>> getResumeList<T>(String userName, int jobId) {
    String url = '${serverAddr}user/getResumeList?userName=$userName';
    if (jobId != null) {
      url += '&jobId=$jobId';
    }
    return Dio().get(url);
  }

  Future<Response<T>> viewResume<T>(String userName, int userId, ) {
    return Dio().post('${serverAddr}user/viewResume', data: {
        'userName': userName,
        'userId': userId,
      }
    );
  }

  Future<Response<T>> savePersonalInfo<T>(
    String name,
    String gender,
    String firstJobTime,
    String wechatId,
    String birthDay,
    String summarize,
    String avatar,
    String userName
  ) {
    return Dio().get('${serverAddr}user/addUser?name=$name&avatar=$avatar&gender=$gender&firstJobTime=$firstJobTime&wechatId=$wechatId&birthDay=$birthDay&summarize=$summarize&userName=$userName');
  }

  Future<Response<T>> saveJobExpectation<T>(
    String jobTitle,
    String industry,
    String city,
    String salary,
    int type,
    String userName
  ) {
    return Dio().get('${serverAddr}user/addUser?jobTitle=$jobTitle&industry=$industry&city=$city&type=$type&salary=$salary&userName=$userName');
  }

  Future<Response<T>> saveCompanyExperience<T>(
    String cname,
    String jobTitle,
    String startTime,
    String endTime,
    String detail,
    String performance,
    String userName,
    int id
  ) {
    String url = '${serverAddr}user/saveCompanyExperience?cname=$cname&jobTitle=$jobTitle&startTime=$startTime&detail=$detail&performance=$performance&userName=$userName';
    if(endTime != null) {
      url += '&endTime=$endTime';
    }
    if(id != null) {
      url += '&id=$id';
    }
    return Dio().get(url);
  }

  Future<Response<T>> saveProject<T>(
    String name,
    String role,
    String startTime,
    String endTime,
    String detail,
    String performance,
    String userName,
    int id
  ) {
    String url = '${serverAddr}user/saveProject?name=$name&role=$role&startTime=$startTime&detail=$detail&performance=$performance&userName=$userName';
    if(endTime != null) {
      url += '&endTime=$endTime';
    }
    if(id != null) {
      url += '&id=$id';
    }
    return Dio().get(url);
  }

  Future<Response<T>> saveEducation<T>(
    String name,
    int academic,
    String major,
    String startTime,
    String endTime,
    String detail,
    String userName,
    int id
  ) {
    String url = '${serverAddr}user/saveEducation?name=$name&academic=$academic&startTime=$startTime&detail=$detail&major=$major&userName=$userName';
    if(endTime != null) {
      url += '&endTime=$endTime';
    }
    if(id != null) {
      url += '&id=$id';
    }
    return Dio().get(url);
  }

  Future<Response<T>> saveCertification<T>(
    String name,
    String industry,
    String code,
    String qualifiedTime,
    String userName,
    int id
  ) {
    String url = '${serverAddr}user/saveCertification?name=$name&industry=$industry&qualifiedTime=$qualifiedTime&code=$code&userName=$userName';
    if(id != null) {
      url += '&id=$id';
    }
    return Dio().get(url);
  }

  Future<Response<T>> getCompanyInfo<T>(int id) {
    return Dio().get(serverAddr + "user/getCompanyInfo?id=" + id.toString());
  }

  Future<Response<T>> login<T>(String account, String pwd) {
    String url = '${serverAddr}user/login?account=$account';
    if(pwd != null) {
      url += '&pwd=$pwd';
    }
    return Dio().get(url);
  }

  Future<Response<T>> register<T>(String account, String pwd, int role) {
    return Dio().get(serverAddr + "user/register?account=$account&pwd=$pwd&role=$role");
  }

  Future<Response<T>> getUserInfo<T>(int id) {
    return Dio().get(serverAddr + "user/query?id=" + id.toString());
  }

  Future<Response<T>> sendSms<T>(String phone) {
    return Dio().post('${serverAddr}user/sendSms', data: {
        'phone': phone
      }
    );
  }

  // mark interface
  Future<Response<T>> mark<T>(String account, int userId, int marker) {
    return Dio().post('${serverAddr}mark/edit', data: {
        'account': account,
        'userId': userId,
        'marker':marker
      }
    );
  }

  // jobs interface
  Future<Response<T>> getJobList<T>(int type, String userName, String timeReq, String academic, String employee, String salary, String area) {
    String url = '${serverAddr}jobs/jobsList?type=$type&userName=$userName';
    if(timeReq != null) {
      url += '&timeReq=$timeReq';
    }
    if(academic != null) {
      url += '&academic=$academic';
    }
    if(employee != null) {
      url += '&employee=$employee';
    }
    if(salary != null) {
      url += '&salary=$salary';
    }
    if(area != null) {
      url += '&area=$area';
    }
    return Dio().get(url);
  }

  Future<Response<T>> getRecruitJobList<T>(String userName) {
    return Dio().get(serverAddr + "jobs/getRecruitJobList?userName=$userName");
  }

  Future<Response<T>> favorite<T>(String userName, int jobId, bool favorite) {
    return Dio().post('${serverAddr}jobs/favorite', data: {
        'userName': userName,
        'jobId': jobId,
        'favorite':favorite
      }
    );
  }

  Future<Response<T>> saveJobs<T>(
    String name,
    String cname,
    int salaryLow,
    int salaryHigh,
    String province,
    String city,
    String area,
    String addrDetail,
    String timereq,
    String academic,
    String detail,
    int type,
    int companyId,
    String userName,
  ) {
    return Dio().post('${serverAddr}jobs/saveJobs', data: {
        'name': name,
        'cname': cname,
        'salaryLow': salaryLow,
        'salaryHigh': salaryHigh,
        'province': province,
        'city': city,
        'area': area,
        'addrDetail': addrDetail,
        'timereq': timereq,
        'academic': academic,
        'detail': detail,
        'type': type,
        'companyId': companyId,
        'userName': userName,
      }
    );
  }

  Future<Response<T>> deliver<T>(String userName, int jobId, ) {
    return Dio().post('${serverAddr}jobs/deliver', data: {
        'userName': userName,
        'jobId': jobId,
      }
    );
  }

  // post interface
  Future<Response<T>> getPostList<T>(String userName) {
    return Dio().get(serverAddr + "post/query?userName=" + userName);
  }

  Future<Response<T>> like<T>(String userName, int like, int postId, int answerId) {
    return Dio().post(serverAddr + "post/like", data: postId != null ? {
      'userName': userName,
      'postId': postId,
      'like': like
    } : {
      'userName': userName,
      'answerId': answerId,
      'like': like
    });
  }

  Future<Response<T>> addPost<T>(String askedBy, String title, String detail, int type) {
    return Dio().get('${serverAddr}post/addPost?askedBy=$askedBy&title=$title&detail=$detail&type=$type');
  }

  Future<Response<T>> addAnswer<T>(String detail, String answerBy, int postId, ) {
    return Dio().get(serverAddr + "post/addAnswer?answerBy=" + answerBy + "&postId=" + postId.toString() + "&answer=" + detail);
  }

  // company interface
  Future<Response<T>> getCompanyDetail<T>(int companyId, String userName) {
    return Dio().get('${serverAddr}company/query?id=$companyId&userName=$userName');
  }

  Future<Response<T>> getCompanyList<T>(String userName) {
    return Dio().post(serverAddr + "company/getCompanyList", data: {
      'userName': userName
    });
  }

  Future<Response<T>> saveCompanyInfo<T>(
    String name,
    String province,
    String city,
    String area,
    String location,
    String type,
    String employee,
    String inc,
    String logo,
    String userName,
    int id
  ) {
    String url = '${serverAddr}company/saveCompanyInfo?name=$name&logo=$logo&province=$province&city=$city&area=$area&location=$location&type=$type&employee=$employee&inc=$inc&userName=$userName';
    if(id != null) {
      url += '&id=${id.toString()}';
    }
    return Dio().get(url);
  }

  Future<Response<T>> verification<T>(
    String corporator,
    String idCard,
    String idFront,
    String idBack,
    String license,
    int id
  ) {
    return Dio().post('${serverAddr}company/verification', data: {
      'corporator': corporator,
      'idCard': idCard,
      'idFront': idFront,
      'idBack': idBack,
      'license': license,
      'id': id
    });
  }

  Future getCompanySuggestions<T>(
    String pattern
  ) {
    return Dio().post('${serverAddr}company/getCompanySuggestions', data: {
      'pattern': pattern
    });
  }

  // education interface
  Future getSchoolSuggestions<T>(
    String pattern
  ) {
    return Dio().post('${serverAddr}education/getSchoolSuggestions', data: {
      'pattern': pattern
    });
  }

  // block interface
  Future addToBlockedList<T>(
    String userName,
    int companyId,
    int blocked
  ) {
    return Dio().post('${serverAddr}block/addToBlockedList', data: {
      'account': userName,
      'companyId': companyId,
      'blocked':blocked
    });
  }

  // block interface
  Future getBlockedList<T>(
    String userName,
  ) {
    return Dio().post('${serverAddr}block/getBlockedList', data: {
      'account': userName,
    });
  }

  // upload interface
  Future<Response<T>> upload<T>(File file, String fileName) {
    FormData formData = new FormData.from({
      "file": new UploadFileInfo(file, fileName)
    });
    return Dio().post(serverAddr + "upload/uploadFile", data: formData);
  }
  
}