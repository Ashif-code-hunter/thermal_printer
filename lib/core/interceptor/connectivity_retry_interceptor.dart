import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
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

  // Future<Response> scheduleRequestRetry(RequestOptions requestOptions) async {
  //   StreamSubscription streamSubscription;
  //   final responseCompleter = Completer<Response>();
  //
  //   streamSubscription = connectivity.onConnectivityChanged.listen(
  //         (connectivityResult) {
  //       if (connectivityResult != ConnectivityResult.none) {
  //         streamSubscription.cancel();
  //         responseCompleter.complete(
  //           dio.request(
  //             requestOptions.path,
  //             cancelToken: requestOptions.cancelToken,
  //             data: requestOptions.data,
  //             onReceiveProgress: requestOptions.onReceiveProgress,
  //             onSendProgress: requestOptions.onSendProgress,
  //             queryParameters: requestOptions.queryParameters,
  //             options: requestOptions,
  //           ),
  //         );
  //       }
  //     },
  //   );
  //
  //   return responseCompleter.future;
 // }
}