import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

import '../config/app_config.dart';
import '../logger/app_logger.dart';
import 'api_interceptor.dart';
import 'api_service.dart';

/// Builds and exposes the Dio instance + Retrofit client.
class ApiClient {
  ApiClient._();

  static Dio prepareDio() {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
      ),
    );

    dio.interceptors.add(ApiInterceptor());

    if (kDebugMode) {
      dio.interceptors.add(
        TalkerDioLogger(
          talker: talker,
          settings: const TalkerDioLoggerSettings(
            printRequestHeaders: true,
            printRequestData: true,
            printResponseData: true,
            printResponseHeaders: false,
          ),
        ),
      );
    }

    return dio;
  }

  static ApiService createRestClient() =>
      ApiService(prepareDio(), baseUrl: AppConfig.baseUrl);
}
