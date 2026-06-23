import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/locale/app_language.dart';
import 'core/locale/locale_provider.dart';
import 'feature/auth/presentation/page/auth_page.dart';
import 'feature/services/presentation/page/services_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppLanguage _language = AppLanguage.uz;

  void _setLanguage(AppLanguage language) {
    setState(() => _language = language);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(471, 753),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return LocaleProvider(
          language: _language,
          onLanguageChanged: _setLanguage,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'ID Renew',
            locale: _language.frameworkLocale,
            supportedLocales: const [
              Locale('en'),
              Locale('ru'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
              ),
            ),
            home: child,
          ),
        );
      },
      child: const AuthPage(),
    );
  }
}
