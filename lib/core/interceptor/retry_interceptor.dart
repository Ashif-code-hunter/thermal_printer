import 'dart:io';

import 'package:dio/dio.dart';


import 'connectivity_retry_interceptor.dart';

class RetryOnConnectionChangeInterceptor extends Interceptor {
  final DioConnectivityRequestRetrier requestRetrier;

  RetryOnConnectionChangeInterceptor({
    required this.requestRetrier,
  });

  @override
  Future onError(DioError err,handler) async {
    if (_shouldRetry(err)) {
      return requestRetrier.scheduleRequestRetry(err,handler);
    }
    return super.onError(err, handler);
  }

  bool _shouldRetry(DioError err) {
    return err.type == DioErrorType.unknown &&
        err.error != null &&
        err.error is SocketException;
  }
}