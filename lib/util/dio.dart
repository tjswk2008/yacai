import 'package:dio/dio.dart';

class DioUtil {
  static Dio instance = new Dio();

  DioUtil();

  static Dio getInstance() {
    return instance;
  }
}