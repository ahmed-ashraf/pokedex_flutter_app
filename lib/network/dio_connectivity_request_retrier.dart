import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';

class DioConnectivityRequestRetrier {
  final Dio dio;
  final Connectivity connectivity;

  DioConnectivityRequestRetrier({
    required this.dio,
    required this.connectivity,
  });

  void scheduleRequestRetry(DioError error, ErrorInterceptorHandler handler) {
    late StreamSubscription streamSubscription;

    streamSubscription = connectivity.onConnectivityChanged.listen(
          (connectivityResult) async {
        if (connectivityResult != ConnectivityResult.none) {
          streamSubscription.cancel();
          try {
            var response = await dio.fetch(error.requestOptions);
            handler.resolve(response);
          } on DioError catch (retryError) {
            handler.next(retryError);
          }
        }
      },
    );
  }
}
