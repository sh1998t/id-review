import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constants/app_constants.dart';
import '../network/inteceptor/api_inteceptor.dart';
import '../notifier/auth_notifier.dart';
import '../utils/app_preference.dart';

const _requestTimeoutInMilliseconds = 60000;

@module
abstract class DioModule {
  @singleton
  Dio getAuthorizedDioClient(
    AppPreference prefs,
    AuthNotifier authNotifier,
  ) {
    final dio = _createDioClient(AppConstants.baseUrl);
    dio.interceptors.addAll([
      AuthorizedRequestInterceptor(prefs, authNotifier),
      if (kDebugMode)
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: false,
        ),
    ]);
    return dio;
  }

  @Named('UnauthorizedClient')
  @singleton
  Dio getUnauthorizedDioClient(AppPreference prefs) {
    final dio = _createDioClient(AppConstants.baseUrl);
    dio.interceptors.addAll([
      CommonRequestInterceptor(prefs),
      if (kDebugMode)
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: false,
        ),
    ]);
    return dio;
  }

  Dio _createDioClient(String baseUrl) {
    return Dio(
      BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout:
            const Duration(milliseconds: _requestTimeoutInMilliseconds),
        receiveTimeout:
            const Duration(milliseconds: _requestTimeoutInMilliseconds),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
  }
}
