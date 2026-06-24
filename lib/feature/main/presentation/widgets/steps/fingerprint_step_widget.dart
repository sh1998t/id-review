import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/fap60/fap60_client.dart';
import '../../../../../core/fap60/fap60_finger_mapping.dart';
import '../disabled_fingers_modal.dart';

class FingerprintStepWidget extends StatefulWidget {
  const FingerprintStepWidget({super.key});

  @override
  State<FingerprintStepWidget> createState() => _FingerprintStepWidgetState();
}

class _FingerprintStepWidgetState extends State<FingerprintStepWidget> {
  final _client = Fap60Client();
  Set<int> _disabledFingers = {};
  final Map<int, _CapturedFinger> _captured = {};
  bool _deviceReady = false;
  bool _checkingDevice = true;
  String? _statusMessage;
  int? _capturingGroup;

  static const _leftGroup = Fap60FingerMapping.leftFour;
  static const _rightGroup = Fap60FingerMapping.rightFour;
  static const _thumbGroup = Fap60FingerMapping.twoThumbs;

  @override
  void initState() {
    super.initState();
    _checkDevice();
  }

  Future<void> _checkDevice() async {
    setState(() {
      _checkingDevice = true;
      _statusMessage = null;
    });
    try {
      final open = await _client.isDeviceOpen();
      if (!mounted) return;
      setState(() {
        _deviceReady = open;
        _checkingDevice = false;
        if (!open) {
          _statusMessage = 'main.fingerprint.scanner_not_connected'.tr();
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _deviceReady = false;
        _checkingDevice = false;
        _statusMessage = 'main.fingerprint.scanner_error'.tr();
      });
    }
  }

  Future<void> _openDisabledFingersModal() async {
    final result = await DisabledFingersModal.show(
      context,
      initialSelected: _disabledFingers,
    );

    if (!mounted || result == null) return;
    setState(() => _disabledFingers = result);
  }

  Future<void> _captureGroup(int imageType, List<int> fingerNumbers) async {
    if (_capturingGroup != null) return;
    if (Fap60FingerMapping.isGroupFullyDisabled(_disabledFingers, fingerNumbers)) {
      return;
    }

    setState(() {
      _capturingGroup = imageType;
      _statusMessage = 'main.fingerprint.waiting'.tr();
    });

    try {
      final result = await _client.capture(imageType: imageType);
      if (!mounted) return;

      if (!result.success) {
        setState(() {
          _capturingGroup = null;
          _statusMessage = result.error;
        });
        return;
      }

      final mapped = Fap60FingerMapping.fingersForImageType(
        imageType,
        isLeftHand: result.isLeftHand,
      );

      setState(() {
        for (var i = 0; i < mapped.length; i++) {
          final finger = mapped[i];
          if (_disabledFingers.contains(finger)) continue;
          if (i >= result.fingerImages.length) continue;
          final bytes = result.fingerImages[i];
          if (bytes == null) continue;
          final quality = i < result.quality.length ? result.quality[i] : 0;
          _captured[finger] = _CapturedFinger(bytes: bytes, quality: quality);
        }
        _capturingGroup = null;
        _statusMessage = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _capturingGroup = null;
        _statusMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_checkingDevice)
          Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: const Center(child: CircularProgressIndicator()),
          )
        else if (_statusMessage != null)
          Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Text(
              _statusMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 12.sp),
            ),
          ),
        _FingerGroup(
          title: 'main.fingerprint.left_hand'.tr(),
          fingerNumbers: _leftGroup,
          disabledFingers: _disabledFingers,
          captured: _captured,
          isCapturing: _capturingGroup == 0,
          onCapture: _deviceReady && _capturingGroup == null
              ? () => _captureGroup(0, _leftGroup)
              : null,
        ),
        SizedBox(height: 16.h),
        _FingerGroup(
          title: 'main.fingerprint.right_hand'.tr(),
          fingerNumbers: _rightGroup,
          disabledFingers: _disabledFingers,
          captured: _captured,
          isCapturing: _capturingGroup == 1,
          onCapture: _deviceReady && _capturingGroup == null
              ? () => _captureGroup(1, _rightGroup)
              : null,
        ),
        SizedBox(height: 16.h),
        _FingerGroup(
          title: 'main.fingerprint.thumbs'.tr(),
          fingerNumbers: _thumbGroup,
          disabledFingers: _disabledFingers,
          captured: _captured,
          isCapturing: _capturingGroup == 3,
          onCapture: _deviceReady && _capturingGroup == null
              ? () => _captureGroup(3, _thumbGroup)
              : null,
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

class _CapturedFinger {
  final Uint8List bytes;
  final int quality;

  const _CapturedFinger({required this.bytes, required this.quality});
}

class _FingerGroup extends StatelessWidget {
  final String title;
  final List<int> fingerNumbers;
  final Set<int> disabledFingers;
  final Map<int, _CapturedFinger> captured;
  final bool isCapturing;
  final VoidCallback? onCapture;

  const _FingerGroup({
    required this.title,
    required this.fingerNumbers,
    required this.disabledFingers,
    required this.captured,
    required this.isCapturing,
    this.onCapture,
  });

  bool get _allDisabled =>
      Fap60FingerMapping.isGroupFullyDisabled(disabledFingers, fingerNumbers);

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
          children: [
            for (final finger in fingerNumbers)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: _FingerSlot(
                  fingerNumber: finger,
                  isDisabled: disabledFingers.contains(finger),
                  captured: captured[finger],
                ),
              ),
          ],
        ),
        if (!_allDisabled && onCapture != null) ...[
          SizedBox(height: 10.h),
          SizedBox(
            width: 220.w,
            child: ElevatedButton(
              onPressed: isCapturing ? null : onCapture,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF28C711),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 10.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: isCapturing
                  ? SizedBox(
                      width: 18.w,
                      height: 18.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'main.fingerprint.capture'.tr(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ],
    );
  }
}

class _FingerSlot extends StatelessWidget {
  final int fingerNumber;
  final bool isDisabled;
  final _CapturedFinger? captured;

  const _FingerSlot({
    required this.fingerNumber,
    required this.isDisabled,
    this.captured,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = captured != null;

    return Container(
      width: 56.w,
      height: 80.h,
      decoration: BoxDecoration(
        color: isDisabled ? const Color(0xFFBDBDBD) : Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: hasImage
            ? Border.all(color: const Color(0xFF28C711), width: 2)
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (hasImage)
            Image.memory(
              captured!.bytes,
              fit: BoxFit.cover,
            ),
          if (isDisabled)
            Center(
              child: Icon(
                Icons.block,
                color: Colors.white.withValues(alpha: 0.9),
                size: 24.sp,
              ),
            )
          else if (!hasImage)
            Center(
              child: Text(
                '$fingerNumber',
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          if (hasImage && captured!.quality > 0)
            Positioned(
              right: 2,
              bottom: 2,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  '${captured!.quality}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
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
