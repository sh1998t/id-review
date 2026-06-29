import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../utils/app_preference.dart';

@singleton
class AuthNotifier extends ChangeNotifier {
  final AppPreference _prefs;

  String? _token;
  bool _initialized = false;

  String? get token => _token;
  bool get isAuthenticated => _token != null && _token!.isNotEmpty;
  bool get initialized => _initialized;

  AuthNotifier(this._prefs) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    try {
      final saved = await _prefs.accessToken;
      _token = saved;
    } catch (_) {
      _token = null;
    } finally {
      _initialized = true;
      notifyListeners();
    }
  }

  Future<void> setToken({
    required String accessToken,
    required String refreshToken,
  }) async {
    _token = accessToken;
    try {
      await _prefs.setAccessToken(accessToken);
      await _prefs.setRefreshToken(refreshToken);
    } catch (_) {}
    notifyListeners();
  }

  Future<void> clearToken() async {
    _token = null;
    try {
      await _prefs.deleteToken();
    } catch (_) {}
    notifyListeners();
  }
}
