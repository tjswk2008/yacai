import 'package:dio/dio.dart';
import 'dart:io';
class Api {
  final String serverAddr = "http://192.168.140.56:3000/api/";

  Future<Response<T>> getResumeList<T>() {
    return Dio().get(serverAddr + "user/getResumeList");
  }

  Future<Response<T>> getJobList<T>(int type) {
    return Dio().get(serverAddr + "jobs/jobsList?type=" + type.toString());
  }

  Future<Response<T>> getRecruitJobList<T>(String userName) {
    return Dio().get(serverAddr + "jobs/getRecruitJobList?userName=${userName}");
  }

  Future<Response<T>> getPostList<T>() {
    return Dio().get(serverAddr + "post/query");
  }

  Future<Response<T>> getCompanyDetail<T>(int companyId) {
    return Dio().get(serverAddr + "company/query?id=" + companyId.toString());
  }

  Future<Response<T>> login<T>(String account, String pwd) {
    return Dio().get(serverAddr + "user/login?account=" + account + "&pwd=" + pwd);
  }

  Future<Response<T>> getUserInfo<T>(int id) {
    return Dio().get(serverAddr + "user/query?id=" + id.toString());
  }

  Future<Response<T>> addPost<T>(String askedBy, String title, String detail) {
    return Dio().get(serverAddr + "post/addPost?askedBy=" + askedBy + "&title=" + title + "&detail=" + detail);
  }

  Future<Response<T>> addAnswer<T>(String detail, String answerBy, int postId, ) {
    return Dio().get(serverAddr + "post/addAnswer?answerBy=" + answerBy + "&postId=" + postId.toString() + "&answer=" + detail);
  }

  Future<Response<T>> savePersonalInfo<T>(
    String name,
    String gender,
    String firstJobTime,
    String wechatId,
    String birthDay,
    String summarize,
    String userName
  ) {
    return Dio().get('${serverAddr}user/addUser?name=${name}&gender=${gender}&firstJobTime=${firstJobTime}&wechatId=${wechatId}&birthDay=${birthDay}&summarize=${summarize}&userName=${userName}');
  }

  Future<Response<T>> saveJobExpectation<T>(
    String jobTitle,
    String industry,
    String city,
    String salary,
    String userName
  ) {
    return Dio().get('${serverAddr}user/addUser?jobTitle=${jobTitle}&industry=${industry}&city=${city}&salary=${salary}&userName=${userName}');
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
    String url = '${serverAddr}user/saveCompanyExperience?cname=${cname}&jobTitle=${jobTitle}&startTime=${startTime}&detail=${detail}&performance=${performance}&userName=${userName}';
    if(endTime != null) {
      url += '&endTime=${endTime}';
    }
    if(id != null) {
      url += '&id=${id}';
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
    String url = '${serverAddr}user/saveProject?name=${name}&role=${role}&startTime=${startTime}&detail=${detail}&performance=${performance}&userName=${userName}';
    if(endTime != null) {
      url += '&endTime=${endTime}';
    }
    if(id != null) {
      url += '&id=${id}';
    }
    return Dio().get(url);
  }

  Future<Response<T>> saveEducation<T>(
    String name,
    String academic,
    String major,
    String startTime,
    String endTime,
    String detail,
    String userName,
    int id
  ) {
    String url = '${serverAddr}user/saveEducation?name=${name}&academic=${academic}&startTime=${startTime}&detail=${detail}&major=${major}&userName=${userName}';
    if(endTime != null) {
      url += '&endTime=${endTime}';
    }
    if(id != null) {
      url += '&id=${id}';
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
    String url = '${serverAddr}user/saveCertification?name=${name}&industry=${industry}&qualifiedTime=${qualifiedTime}&code=${code}&userName=${userName}';
    if(id != null) {
      url += '&id=${id}';
    }
    return Dio().get(url);
  }

  Future<Response<T>> upload<T>(File file, String fileName) {
    FormData formData = new FormData.from({
      "file": new UploadFileInfo(file, fileName)
    });
    return Dio().post(serverAddr + "upload/uploadFile", data: formData);
  }
  
}