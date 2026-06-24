import 'package:flutter/material.dart';

enum AppLanguage {
  uz(code: 'uz', label: "O'z", flagAsset: 'uz_flag'),
  ru(code: 'ru', label: 'Ru', flagAsset: 'ru_flag'),
  en(code: 'en', label: 'Eng', flagAsset: 'eng_flag');

  const AppLanguage({
    required this.code,
    required this.label,
    this.flagAsset,
  });

  final String code;
  final String label;
  final String? flagAsset;

  Locale get locale => Locale(code);

  static AppLanguage fromLocale(Locale locale) {
    return AppLanguage.values.firstWhere(
      (language) => language.code == locale.languageCode,
      orElse: () => AppLanguage.uz,
    );
  }
}
