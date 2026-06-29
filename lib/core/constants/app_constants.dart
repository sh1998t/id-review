class AppConstants {
  AppConstants._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.example.com/',
  );

  static const String auth = 'auth/login';

  static const String idRenewalApplications = 'id-renewal/applications';
  static const String idRenewalApplicant =
      'id-renewal/applications/{id}/applicant';
  static const String idRenewalFace = 'id-renewal/applications/{id}/face';
  static const String idRenewalFingerprints =
      'id-renewal/applications/{id}/fingerprints';
  static const String idRenewalSignature =
      'id-renewal/applications/{id}/signature';
  static const String idRenewalContact =
      'id-renewal/applications/{id}/contact';
  static const String idRenewalSubmit =
      'id-renewal/applications/{id}/submit';

  static const String tokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String languageKey = 'selected_language';
}
