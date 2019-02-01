import 'package:dio/dio.dart';

class Api {
  final String serverAddr = "http://192.168.140.56:3000/api/";

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
    return Dio().post(serverAddr + "user/login", data: {account: account, pwd: pwd});
  }

  Future<Response<T>> getUserInfo<T>(int id) {
    return Dio().get(serverAddr + "user/query?id=" + id.toString());
  }
}