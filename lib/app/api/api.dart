import 'package:dio/dio.dart';

class Api {
  final String serverAddr = "http://localhost:3000/api/";

  Future<Response<T>> getJobList<T>(int type) {
    return Dio().get(serverAddr + "jobs/jobsList?type=" + type.toString());
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
}