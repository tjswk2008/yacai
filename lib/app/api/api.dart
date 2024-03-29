import 'package:dio/dio.dart';
import 'dart:io';
import 'package:flutter_app/util/dio.dart';
import 'package:flutter_app/util/app_config.dart';
class Api {
  // final String serverAddr = "http://192.168.140.56:3000/api/";
  // final String serverAddr = "http://192.168.43.204:3000/api/"; // 4G
  final String serverAddr = '${AppConfig.getInstance().apiBaseUrl}/api/'; //cloud
  // final String serverAddr = Platform.isAndroid ? "http://192.168.140.56:3000/api/" : "http://192.168.2.101:3000/api/";
  Dio dio = DioUtil.getInstance();

  Future<Response<T>> saveMsg<T>(Map map) {
    return dio.post('${serverAddr}conversation/saveMsg', data: map);
  }

  Future<Response<T>> getConversationBySeekerId<T>(int jobId, int jobSeekerId) {
    return dio.post('${serverAddr}conversation/getConversation', data: {
      'jobId': jobId, 'jobSeekerId': jobSeekerId
    });
  }

  Future<Response<T>> getConversationList<T>(int hunterId) {
    return dio.post('${serverAddr}conversation/getConversationListByhunterId', data: {
      'hunterId': hunterId
    });
  }

  // user interface
  Future<Response<T>> getResumeList<T>(String userName, int jobId, String timeReq, String academic, String salary, int mark, int accepted, int page, int type) {
    // type: 2 查看记录
    String url = '${serverAddr}user/getResumeList?userName=$userName';
    if (jobId != null) {
      url += '&jobId=$jobId';
    }
    if(timeReq != null) {
      url += '&timeReq=$timeReq';
    }
    if(academic != null) {
      url += '&academic=$academic';
    }
    if(salary != null) {
      url += '&salary=$salary';
    }
    if(mark != null) {
      url += '&mark=$mark';
    }
    if(page != null) {
      url += '&page=$page';
    }
    if(type != null) {
      url += '&type=$type';
    }
    if(accepted != null) {
      url += '&accepted=$accepted';
    }
    return dio.get(url);
  }

  Future<Response<T>> viewResume<T>(String userName, int userId, ) {
    return dio.post('${serverAddr}user/viewResume', data: {
        'userName': userName,
        'userId': userId,
      }
    );
  }

  Future<Response<T>> savePersonalBaseInfo<T>(String name, String nickname, String avatar, String userName) {
    String url = '${serverAddr}user/addUserBase?userName=$userName';
    if (name != null) {
      url += '&name=$name';
    }
    if (avatar != null) {
      url += '&avatar=$avatar';
    }
    if (nickname != null) {
      url += '&nickname=$nickname';
    }
    return dio.get(url);
  }

  Future<Response<T>> savePersonalInfo<T>(
    String name,
    String gender,
    String firstJobTime,
    String wechatId,
    String birthDay,
    String summarize,
    String avatar,
    String residenceArea, // 区县
    String email, // 邮箱
    String nativeProvince, // 籍贯-省
    String nativeCity, // 籍贯-市
    int marriage,
    String userName
  ) {
    String url = '${serverAddr}user/addUser?userName=$userName';
    if (residenceArea != null) {
      url += '&residenceArea=$residenceArea';
    }
    if (email != null) {
      url += '&email=$email';
    }
    if (nativeProvince != null) {
      url += '&nativeProvince=$nativeProvince';
    }
    if (nativeCity != null) {
      url += '&nativeCity=$nativeCity';
    }
    if (marriage != null) {
      url += '&marriage=$marriage';
    }
    if (name != null) {
      url += '&name=$name';
    }
    if (firstJobTime != null) {
      url += '&firstJobTime=$firstJobTime';
    }
    if (birthDay != null) {
      url += '&birthDay=$birthDay';
    }
    if (avatar != null) {
      url += '&avatar=$avatar';
    }
    if (gender != null) {
      url += '&gender=$gender';
    }
    if(wechatId != null) {
      url += '&wechatId=$wechatId';
    }
    if(summarize != null) {
      url += '&summarize=$summarize';
    }
    return dio.get(url);
  }

  Future<Response<T>> saveJobStatus<T>(String jobStatus, String userName) {
    return dio.post('${serverAddr}user/saveJobStatus', data: {
        'jobStatus': jobStatus,
        'userName':userName
      });
  }

  Future<Response<T>> getUserAvatar<T>(int id) {
    return dio.post('${serverAddr}user/getUserAvatar', data: {
        'id': id
      });
  }

  Future<Response<T>> saveJobExpectation<T>(
    String jobTitle,
    String industry,
    String city,
    String salary,
    int type,
    String userName
  ) {
    return dio.get('${serverAddr}user/addUser?jobTitle=$jobTitle&industry=$industry&city=$city&type=$type&salary=$salary&userName=$userName');
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
    return dio.get(url);
  }

  Future<Response<T>> deleteCompanyExperience<T>(int id) {
    String url = '${serverAddr}user/deleteCompanyExperience';
    return dio.post(url, data: {'id': id});
  }

  Future<Response<T>> deleteProject<T>(int id) {
    String url = '${serverAddr}user/deleteProject';
    return dio.post(url, data: {'id': id});
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
    return dio.get(url);
  }

  Future<Response<T>> deleteEducation<T>(int academic, int id, String userName) {
    String url = '${serverAddr}user/deleteEducation';
    return dio.post(url, data: {'id': id, 'userName': userName, 'academic': academic});
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
    return dio.get(url);
  }

  Future<Response<T>> deleteCertification<T>(int id) {
    String url = '${serverAddr}user/deleteCertification';
    return dio.post(url, data: {'id': id});
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
    return dio.get(url);
  }

  Future<Response<T>> getCompanyInfo<T>(int id) {
    return dio.get(serverAddr + "user/getCompanyInfo?id=" + id.toString());
  }

  Future<Response<T>> login<T>(String account, String pwd) {
    Map data = {'account': account};
    if(pwd != null) {
      data['pwd'] = pwd;
    }
    return dio.post('${serverAddr}user/login', data: data);
  }

  Future<Response<T>> register<T>(String account, String pwd, int role) {
    return dio.get(serverAddr + "user/register?account=$account&pwd=$pwd&role=$role");
  }

  Future<Response<T>> refreshResume<T>(String account) {
    return dio.post(serverAddr + "user/refreshResume", data: {'account': account});
  }

  Future<Response<T>> deleteUser<T>(String account) {
    String url = '${serverAddr}user/deleteUser';
    return dio.post(url, data: {'account': account});
  }

  Future<Response<T>> switchOpenStatus<T>(String account, int open) {
    String url = '${serverAddr}user/switchOpenStatus';
    return dio.post(url, data: {'account': account, 'isOpen': open});
  }

  Future<Response<T>> getUserInfo<T>(int id, String userName) {
    Map data = {'id': id};
    if(userName != null) {
      data['userName'] = userName;
    }
    return dio.post('${serverAddr}user/query', data: data);
  }

  Future<Response<T>> getUserBaseInfo<T>(String userName) {
    String url = "${serverAddr}user/queryBase?userName=$userName";
    return dio.get(url);
  }

  Future<Response<T>> sendSms<T>(String phone) {
    return dio.post('${serverAddr}user/sendSms', data: {
        'phone': phone
      }
    );
  }

  // mark interface
  Future<Response<T>> mark<T>(String account, int userId, int marker) {
    return dio.post('${serverAddr}mark/edit', data: {
        'account': account,
        'userId': userId,
        'marker':marker
      }
    );
  }

  // jobs interface
  Future<Response<T>> refreshJob<T>(int id) {
    return dio.post(serverAddr + "jobs/refreshJob", data: {'id': id});
  }

  Future<Response<T>> getjob<T>(int id) {
    return dio.post('${serverAddr}jobs/getjob', data: {
        'id': id
      });
  }

  Future<Response<T>> getJobList<T>(
    int type,
    String userName,
    String timeReq,
    String academic,
    String employee,
    String salary,
    String area,
    String companyType,
    int currentPage,
    String keywords
  ) {
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
    if(companyType != null) {
      url += '&companyType=$companyType';
    }
    if(currentPage != null) {
      url += '&currentPage=$currentPage';
    }
    if(keywords != null) {
      url += '&keywords=$keywords';
    }
    
    return dio.get(url);
  }

  Future<Response<T>> getRecruitJobList<T>(String userName) {
    return dio.get(serverAddr + "jobs/getRecruitJobList?userName=$userName");
  }

  Future<Response<T>> favorite<T>(String userName, int jobId, bool favorite) {
    return dio.post('${serverAddr}jobs/favorite', data: {
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
    return dio.post('${serverAddr}jobs/saveJobs', data: {
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
    return dio.post('${serverAddr}jobs/deliver', data: {
        'userName': userName,
        'jobId': jobId,
      }
    );
  }

  // post interface
  Future<Response<T>> getPostList<T>(String userName, int type, int currentPage) {
    return dio.get('${serverAddr}post/query?userName=$userName&type=$type&currentPage=$currentPage');
  }

  Future<Response<T>> like<T>(String userName, int like, int postId, int answerId) {
    return dio.post(serverAddr + "post/like", data: postId != null ? {
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
    return dio.get('${serverAddr}post/addPost?askedBy=$askedBy&title=$title&detail=$detail&type=$type');
  }

  Future<Response<T>> addAnswer<T>(String detail, String answerBy, int postId, ) {
    return dio.get(serverAddr + "post/addAnswer?answerBy=" + answerBy + "&postId=" + postId.toString() + "&answer=" + detail);
  }

  // company interface
  Future<Response<T>> getCompanyDetail<T>(int companyId, String userName) {
    return dio.get('${serverAddr}company/query?id=$companyId&userName=$userName');
  }

  Future<Response<T>> getCompanyList<T>(String userName) {
    return dio.post(serverAddr + "company/getCompanyList", data: {
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
    List<Map> imgs,
    String userName,
    int id
  ) {
    String url = '${serverAddr}company/saveCompanyInfo';
    Map data = {
      'name': name,
      'province': province,
      'city': city,
      'area': area,
      'location': location,
      'type': type,
      'employee': employee,
      'inc': inc,
      'userName': userName,
      'imgs': imgs
    };
    if(logo != null) {
      data['logo'] = logo;
    }
    if(id != null) {
      data['id']=id;
    }
    return dio.post(url, data: data);
  }

  Future<Response<T>> verification<T>(
    String corporator,
    String idCard,
    String idFront,
    String idBack,
    String license,
    String willing,
    int id
  ) {
    return dio.post('${serverAddr}company/verification', data: {
      'corporator': corporator,
      'idCard': idCard,
      'idFront': idFront,
      'idBack': idBack,
      'license': license,
      'willing': willing,
      'id': id
    });
  }

  Future getCompanySuggestions<List>(
    String pattern
  ) {
    return dio.post('${serverAddr}company/getCompanySuggestions', data: {
      'pattern': pattern
    });
  }

  // education interface
  Future getSchoolSuggestions<T>(
    String pattern
  ) {
    return dio.post('${serverAddr}education/getSchoolSuggestions', data: {
      'pattern': pattern
    });
  }

  // block interface
  Future addToBlockedList<T>(
    String userName,
    int companyId,
    int blocked
  ) {
    return dio.post('${serverAddr}block/addToBlockedList', data: {
      'account': userName,
      'companyId': companyId,
      'blocked':blocked
    });
  }

  Future getBlockedList<T>(
    String userName,
  ) {
    return dio.post('${serverAddr}block/getBlockedList', data: {
      'account': userName,
    });
  }

  // invite interface
  Future<Response<T>> invite<T>(
    String userName,
    String detail,
    int jobId,
    int userId
  ) {
    return dio.post('${serverAddr}invite/invite', data: {
      'userName': userName,
      'detail': detail,
      'jobId': jobId,
      'userId': userId
    });
  }

  Future<Response<T>> getInvitation<T>(
    int jobId,
    int userId
  ) {
    return dio.post('${serverAddr}invite/getInvitation', data: {
      'jobId': jobId,
      'userId': userId
    });
  }

  Future<Response<T>> updateInvitation<T>(
    int jobId,
    int userId,
    int accepted
  ) {
    return dio.post('${serverAddr}invite/updateInvitation', data: {
      'jobId': jobId,
      'userId': userId,
      'accepted': accepted
    });
  }

  // upload interface
  Future<Response<T>> upload<T>(File file, String fileName) async {
    FormData formData = new FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path,filename: fileName)
    });
    return dio.post(serverAddr + "upload/uploadFile", data: formData);
  }

  Future<Response<T>> checkAppVersion<T>() {
    return dio.post(serverAddr + "upload/checkAppVersion");
  }

  Future<Response<T>> deleteImage<T>(int id, String name) {
    Map data = {
      'id': id,
    };
    if (name != null) {
      data['name'] = name;
    }
    return dio.post(serverAddr + "upload/deleteImage", data: data);
  }
  
}