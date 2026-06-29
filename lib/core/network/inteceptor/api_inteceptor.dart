import 'package:dio/dio.dart';

import '../../notifier/auth_notifier.dart';
import '../../utils/app_preference.dart';

class CommonRequestInterceptor extends Interceptor {
  CommonRequestInterceptor(this._prefs);

  final AppPreference _prefs;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final language = await _prefs.selectedLanguage;
    options.headers['Accept-Language'] = language;
    handler.next(options);
  }
}

class AuthorizedRequestInterceptor extends CommonRequestInterceptor {
  AuthorizedRequestInterceptor(
    super.prefs,
    this._authNotifier,
  );

  final AuthNotifier _authNotifier;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final language = await _prefs.selectedLanguage;
    options.headers['Accept-Language'] = language;

    final token = _authNotifier.token;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}
