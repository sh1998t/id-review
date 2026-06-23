import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/locale/app_language.dart';
import '../../../../core/locale/locale_provider.dart';

class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = LocaleProvider.of(context);
    final selected = localeProvider.language;

    return PopupMenuButton<AppLanguage>(
      onSelected: localeProvider.onLanguageChanged,
      offset: Offset(0, 42.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      color: const Color(0xFF2F6FB8),
      elevation: 8,
      itemBuilder: (context) {
        return AppLanguage.values
            .map(
              (language) => PopupMenuItem<AppLanguage>(
                value: language,
                child: _LanguageMenuItem(
                  language: language,
                  isSelected: language == selected,
                ),
              ),
            )
            .toList();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Colors.white.withValues(alpha: 0.25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LanguageFlag(language: selected, width: 28.w, height: 18.h),
            SizedBox(width: 8.w),
            Text(
              selected.label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 4.w),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.white,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageMenuItem extends StatelessWidget {
  final AppLanguage language;
  final bool isSelected;

  const _LanguageMenuItem({
    required this.language,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _LanguageFlag(language: language, width: 28.w, height: 18.h),
        SizedBox(width: 10.w),
        Text(
          language.label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        if (isSelected) ...[
          const Spacer(),
          Icon(
            Icons.check_rounded,
            color: Colors.white,
            size: 18.sp,
          ),
        ],
      ],
    );
  }
}

class _LanguageFlag extends StatelessWidget {
  final AppLanguage language;
  final double width;
  final double height;

  const _LanguageFlag({
    required this.language,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (language == AppLanguage.ru) {
      return _RussianFlag(width: width, height: height);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(4.r),
      child: Image.asset(
        'assets/flag/${language.flagAsset}.png',
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _RussianFlag extends StatelessWidget {
  final double width;
  final double height;

  const _RussianFlag({
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.r),
      child: SizedBox(
        width: width,
        height: height,
        child: const Column(
          children: [
            Expanded(child: ColoredBox(color: Colors.white)),
            Expanded(child: ColoredBox(color: Color(0xFF0039A6))),
            Expanded(child: ColoredBox(color: Color(0xFFD52B1E))),
          ],
        ),
      ),
    );
  }
}
