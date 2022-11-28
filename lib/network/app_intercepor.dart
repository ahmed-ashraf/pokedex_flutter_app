import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api.dart';
import 'logger/logger.dart';

class AppInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      logPrint('statusCode: ${response.statusCode.toString()}');
      logPrint(response.toString());
    }
    super.onResponse(response, handler);
  }
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers = headers;
    options.followRedirects = false;
    options.validateStatus = (status) => status! < 500;

    if (kDebugMode) {
      logPrint('url: ${options.path}');
      logPrint('headers: ${options.headers}');
      logPrint('request: ${options.data}');
      logPrint('queryParameters: ${options.queryParameters}');
    }
    super.onRequest(options, handler);
  }
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      logPrint(err.message);
    }
    super.onError(err, handler);
  }
}
