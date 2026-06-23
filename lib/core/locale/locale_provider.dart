import 'package:flutter/material.dart';

import 'app_language.dart';

class LocaleProvider extends InheritedWidget {
  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  const LocaleProvider({
    super.key,
    required this.language,
    required this.onLanguageChanged,
    required super.child,
  });

  static LocaleProvider of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<LocaleProvider>();
    assert(provider != null, 'LocaleProvider not found in context');
    return provider!;
  }

  @override
  bool updateShouldNotify(LocaleProvider oldWidget) {
    return language != oldWidget.language;
  }
}
