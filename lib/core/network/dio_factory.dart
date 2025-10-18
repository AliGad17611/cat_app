import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:cat_app/core/constants/app_constants.dart';

class DioFactory {
  final Dio _dio;
  Dio get dio => _dio;
  DioFactory() : _dio = Dio() {
    _dio.options
      ..baseUrl = AppConstants.baseUrl
      ..connectTimeout = Duration(milliseconds: AppConstants.connectionTimeout)
      ..receiveTimeout = Duration(milliseconds: AppConstants.receiveTimeout)
      ..sendTimeout = Duration(milliseconds: AppConstants.sendTimeout)
      ..headers = {
        'x-api-key': AppConstants.apiKey,
        'Content-Type': 'application/json',
      };
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
        enabled: kDebugMode,
      ),
    );
  }
}
