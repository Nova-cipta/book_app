import 'dart:developer';

import 'package:dio/dio.dart';

/// set up [Interceptor] for [Dio]
class AppInterceptor extends Interceptor {
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // set default headers
    options.headers.addAll({"content-type": "application/json; charset=utf-8"});
    options.headers.addAll({"Accept": "application/json"});
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    log("type: ${err.type}", name: "AppInterceptor");
    log("message: ${err.message}", name: "AppInterceptor");
    return super.onError(err, handler);
  }
}
