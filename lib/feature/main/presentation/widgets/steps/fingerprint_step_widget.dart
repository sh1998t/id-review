import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../disabled_fingers_modal.dart';

class FingerprintStepWidget extends StatefulWidget {
  const FingerprintStepWidget({super.key});

  @override
  State<FingerprintStepWidget> createState() => _FingerprintStepWidgetState();
}

class _FingerprintStepWidgetState extends State<FingerprintStepWidget> {
  Set<int> _disabledFingers = {};

  Future<void> _openDisabledFingersModal() async {
    final result = await DisabledFingersModal.show(
      context,
      initialSelected: _disabledFingers,
    );

    if (!mounted || result == null) return;
    setState(() => _disabledFingers = result);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FingerGroup(
          title: 'main.fingerprint.left_hand'.tr(),
          fingerCount: 4,
        ),
        SizedBox(height: 16.h),
        _FingerGroup(
          title: 'main.fingerprint.right_hand'.tr(),
          fingerCount: 4,
        ),
        SizedBox(height: 16.h),
        _FingerGroup(
          title: 'main.fingerprint.thumbs'.tr(),
          fingerCount: 2,
        ),
        SizedBox(height: 16.h),
        _SpecialCaseGroup(
          selectedCount: _disabledFingers.length,
          onTap: _openDisabledFingersModal,
        ),
        SizedBox(height: 12.h),
      ],
    );
  }
}

class _FingerGroup extends StatelessWidget {
  final String title;
  final int fingerCount;

  const _FingerGroup({
    required this.title,
    required this.fingerCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            fingerCount,
            (index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: const _FingerSlot(),
            ),
          ),
        ),
      ],
    );
  }
}

class _FingerSlot extends StatelessWidget {
  const _FingerSlot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56.w,
      height: 80.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
    );
  }
}

class _SpecialCaseGroup extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onTap;

  const _SpecialCaseGroup({
    required this.selectedCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final label = selectedCount > 0
        ? 'main.fingerprint.special_case_count'
            .tr(args: ['$selectedCount'])
        : 'main.fingerprint.special_case'.tr();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'main.fingerprint.special_cases'.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: const Color(0xFFE85D4C),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '?',
                        style: TextStyle(
                          color: const Color(0xFFE85D4C),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
