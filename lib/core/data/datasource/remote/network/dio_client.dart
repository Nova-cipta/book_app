import 'package:book_app/core/data/datasource/remote/network/app_interceptor.dart';
import 'package:book_app/core/util/static.dart';
import 'package:dio/dio.dart';

/// set up [Dio] configuration used in this project
class DioClient {
  static late Dio _dio;
  final AppInterceptor appInterceptor = AppInterceptor();
  addInterception() {
    _dio.interceptors.addAll([
      appInterceptor,
    ]);
  }

  DioClient() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      validateStatus: (status) => (status! >= 200) && (status < 400),
    ));
    addInterception();
  }

  Dio get dio => _dio;
}
