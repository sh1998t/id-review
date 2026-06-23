import 'package:flutter/material.dart';

enum AppLanguage {
  uz(code: 'uz', label: "O'z", flagAsset: 'uz_flag'),
  ru(code: 'ru', label: 'Ru'),
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

  /// Flutter Material widgets do not ship `uz` localizations yet.
  Locale get frameworkLocale {
    switch (this) {
      case AppLanguage.uz:
        return const Locale('en');
      case AppLanguage.ru:
        return const Locale('ru');
      case AppLanguage.en:
        return const Locale('en');
    }
  }
}
