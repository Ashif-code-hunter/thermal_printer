import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:untitled/constants/constants.dart';
import 'package:untitled/constants/style_manager.dart';
import 'package:untitled/core/interceptor/retry_interceptor.dart';
import '../../constants/api_const/api_const.dart';
import '../../main.dart';
import 'auth_interceptor.dart';
import 'connectivity_retry_interceptor.dart';

class Api {
  final dio = createDio();

  // final tokenDio = Dio(BaseOptions(baseUrl: AppAPI.BaseUrl));

  Api._internal();

  static final _singleton = Api._internal();

  factory Api() => _singleton;

  static Dio createDio() {
    var dio = Dio();
    dio.options.baseUrl = AppAPI.baseUrl;
    dio.interceptors
    ..add(LogInterceptor(
        responseBody: true,
        error: true,
        requestHeader: true,
        responseHeader: false,
        request: true,
        requestBody: true))
      ..add(AuthInterceptor(dio))
      // ..add(AppInterceptors(dio))
      ..add(
        RetryOnConnectionChangeInterceptor(
          requestRetrier: DioConnectivityRequestRetrier(
              dio: dio, connectivity: Connectivity()),
        ),
      );
    return dio;
  }
}

// class AppInterceptors extends Interceptor {
//   final Dio dio;
//
//   AppInterceptors(this.dio);
//
//   @override
// }

class BadRequestException extends DioError {
  BadRequestException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Invalid request';
  }
}

class InternalServerErrorException extends DioError {
  InternalServerErrorException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Unknown error occurred, please try again later.';
  }
}

class ConflictException extends DioError {
  ConflictException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Conflict occurred';
  }
}

class UnauthorizedException extends DioError {
  UnauthorizedException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Access denied';
  }
}

class NotFoundException extends DioError {
  NotFoundException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'The requested information could not be found';
  }
}

class NoInternetConnectionException extends DioError {
  NoInternetConnectionException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'No internet connection detected, please try again.';
  }
}

class DeadlineExceededException extends DioError {
  DeadlineExceededException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'The connection has timed out, please try again.';
   }
}