import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../constants/api_const/api_const.dart';
import '../../interceptor/app_dio.dart';

class ExpiryApi {
  Future expiryApi() async {
    const String subUrl = "/Services/Master/Products/IsActive";
    String uri = AppAPI.baseUrl + subUrl;
    final response = await Api().dio.post(
      uri,
    );
    final statusCode = response.statusCode;
    final body = response.data;
    if (statusCode == 201 || statusCode == 200) {
      return body;
    }
  }
}