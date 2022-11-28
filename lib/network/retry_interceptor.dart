import 'dart:io';

import 'package:dio/dio.dart';

import 'app_intercepor.dart';
import 'dio_connectivity_request_retrier.dart';

class RetryOnConnectionChangeInterceptor extends AppInterceptor {
  final DioConnectivityRequestRetrier requestRetrier;


  RetryOnConnectionChangeInterceptor(this.requestRetrier);

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {

    if (_shouldRetry(err)) {
      try {
        requestRetrier.scheduleRequestRetry(err, handler);
      } catch (e) {
        // Let any new error from the retrier pass through
        super.onError(err, handler);
      }
    } else {
      super.onError(err, handler);
    }
  }


  bool _shouldRetry(DioError err) {
    return err.error is SocketException;
  }
}