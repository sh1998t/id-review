import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../constants/app_constants.dart';

@singleton
class AppPreference {
  final FlutterSecureStorage _prefs;

  AppPreference(this._prefs);

  Future<String> get selectedLanguage async =>
      (await _prefs.read(key: AppConstants.languageKey)) ?? 'uz';

  Future<void> setSelectedLanguage(String languageCode) async {
    await _prefs.write(key: AppConstants.languageKey, value: languageCode);
  }

  Future<String?> get accessToken async =>
      _prefs.read(key: AppConstants.tokenKey);

  Future<bool> get hasToken async =>
      _prefs.containsKey(key: AppConstants.tokenKey);

  Future<void> setAccessToken(String? token) async {
    if (token == null) {
      await _prefs.delete(key: AppConstants.tokenKey);
    } else {
      await _prefs.write(key: AppConstants.tokenKey, value: token);
    }
  }

  Future<String?> get refreshToken async =>
      _prefs.read(key: AppConstants.refreshTokenKey);

  Future<void> setRefreshToken(String? token) async {
    if (token == null) {
      await _prefs.delete(key: AppConstants.refreshTokenKey);
    } else {
      await _prefs.write(key: AppConstants.refreshTokenKey, value: token);
    }
  }

  Future<void> deleteToken() async {
    await _prefs.delete(key: AppConstants.tokenKey);
    await _prefs.delete(key: AppConstants.refreshTokenKey);
  }
}
