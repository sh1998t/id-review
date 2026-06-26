import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/fap60/fap60_client.dart';
import '../../../../../core/fap60/fap60_finger_mapping.dart';
import '../../../../../core/fap60/fap60_platform.dart';
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
  bool _scannerError = false;
  String? _captureMessage;
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
      _scannerError = false;
    });
    try {
      final status = await Fap60Platform.connectScanner();
      if (!mounted) return;
      setState(() {
        _deviceReady = status.isReady;
        _checkingDevice = false;
        _scannerError = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _deviceReady = false;
        _checkingDevice = false;
        _scannerError = true;
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

  List<int> _activeFingers(List<int> fingerNumbers) {
    return fingerNumbers
        .where((finger) => !_disabledFingers.contains(finger))
        .toList();
  }

  bool _isGroupComplete(List<int> fingerNumbers) {
    final active = _activeFingers(fingerNumbers);
    return active.isNotEmpty &&
        active.every((finger) => _captured.containsKey(finger));
  }

  void _clearGroupCaptures(List<int> fingerNumbers) {
    for (final finger in _activeFingers(fingerNumbers)) {
      _captured.remove(finger);
    }
  }

  Future<void> _captureGroup(int imageType, List<int> fingerNumbers) async {
    if (_capturingGroup != null) return;
    if (Fap60FingerMapping.isGroupFullyDisabled(_disabledFingers, fingerNumbers)) {
      return;
    }

    if (imageType == 3) {
      await _captureThumbGroup(fingerNumbers);
      return;
    }

    final active = _activeFingers(fingerNumbers);
    if (active.isEmpty) return;

    setState(() {
      _clearGroupCaptures(fingerNumbers);
      _capturingGroup = imageType;
      _captureMessage = 'main.fingerprint.waiting'.tr();
    });

    try {
      final result = await _client.capture(imageType: imageType);
      if (!mounted) return;

      if (!result.success) {
        setState(() {
          _capturingGroup = null;
          _captureMessage = result.error;
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
        _captureMessage = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _capturingGroup = null;
        _captureMessage = e.toString();
      });
    }
  }

  Future<void> _captureThumbGroup(List<int> fingerNumbers) async {
    final active = _activeFingers(fingerNumbers);
    if (active.isEmpty) return;

    var toCapture =
        active.where((finger) => !_captured.containsKey(finger)).toList();
    if (toCapture.isEmpty) {
      _clearGroupCaptures(fingerNumbers);
      toCapture = active;
    }

    setState(() => _capturingGroup = 3);

    try {
      for (final finger in toCapture) {
        final waitingKey = finger == 6
            ? 'main.fingerprint.thumb_right_waiting'
            : 'main.fingerprint.thumb_left_waiting';
        setState(() => _captureMessage = waitingKey.tr());

        final result = await _client.capture(imageType: 2);
        if (!mounted) return;

        if (!result.success) {
          setState(() {
            _capturingGroup = null;
            _captureMessage = result.error;
          });
          return;
        }

        Uint8List? bytes;
        if (result.fingerImages.isNotEmpty) {
          bytes = result.fingerImages.first;
        }

        if (bytes == null) {
          setState(() {
            _capturingGroup = null;
            _captureMessage = 'main.fingerprint.thumb_no_data'.tr();
          });
          return;
        }

        final quality =
            result.quality.isNotEmpty ? result.quality.first : 0;

        setState(() {
          _captured[finger] = _CapturedFinger(bytes: bytes!, quality: quality);
        });
      }

      if (!mounted) return;
      setState(() {
        _capturingGroup = null;
        _captureMessage = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _capturingGroup = null;
        _captureMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_captureMessage != null)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Text(
              _captureMessage!,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white70, fontSize: 11.sp),
            ),
          ),
        _FingerGroup(
          title: 'main.fingerprint.left_hand'.tr(),
          fingerNumbers: _leftGroup,
          disabledFingers: _disabledFingers,
          captured: _captured,
          isCapturing: _capturingGroup == 0,
          isComplete: _isGroupComplete(_leftGroup),
          onCapture: _deviceReady && _capturingGroup == null
              ? () => _captureGroup(0, _leftGroup)
              : null,
        ),
        SizedBox(height: 10.h),
        _FingerGroup(
          title: 'main.fingerprint.right_hand'.tr(),
          fingerNumbers: _rightGroup,
          disabledFingers: _disabledFingers,
          captured: _captured,
          isCapturing: _capturingGroup == 1,
          isComplete: _isGroupComplete(_rightGroup),
          onCapture: _deviceReady && _capturingGroup == null
              ? () => _captureGroup(1, _rightGroup)
              : null,
        ),
        SizedBox(height: 10.h),
        _FingerGroup(
          title: 'main.fingerprint.thumbs'.tr(),
          fingerNumbers: _thumbGroup,
          disabledFingers: _disabledFingers,
          captured: _captured,
          isCapturing: _capturingGroup == 3,
          isComplete: _isGroupComplete(_thumbGroup),
          onCapture: _deviceReady && _capturingGroup == null
              ? () => _captureGroup(3, _thumbGroup)
              : null,
        ),
        SizedBox(height: 20.h),
        _SpecialCaseGroup(
          selectedCount: _disabledFingers.length,
          onTap: _openDisabledFingersModal,
        ),
        SizedBox(height: 10.h),
        _ScannerStatusIndicator(
          isChecking: _checkingDevice,
          isConnected: _deviceReady,
          hasError: _scannerError,
          onRefresh: _checkDevice,
        ),
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
  final bool isComplete;
  final VoidCallback? onCapture;

  const _FingerGroup({
    required this.title,
    required this.fingerNumbers,
    required this.disabledFingers,
    required this.captured,
    required this.isCapturing,
    required this.isComplete,
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
        SizedBox(height: 10.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final finger in fingerNumbers)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: _FingerSlot(
                        fingerNumber: finger,
                        isDisabled: disabledFingers.contains(finger),
                        captured: captured[finger],
                      ),
                    ),
                ],
              ),
            ),
            if (!_allDisabled && onCapture != null)
              Padding(
                padding: EdgeInsets.only(left: 6.w, top: 4.h),
                child: SizedBox(
                  width: 96.w,
                  child: ElevatedButton(
                    onPressed: isCapturing ? null : onCapture,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF28C711),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      minimumSize: Size(96.w, 36.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: isCapturing
                        ? SizedBox(
                            width: 16.w,
                            height: 16.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            isComplete
                                ? 'main.fingerprint.recapture'.tr()
                                : 'main.fingerprint.capture'.tr(),
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
          ],
        ),
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
      mainAxisSize: MainAxisSize.min,
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
        SizedBox(height: 10.h),
        SizedBox(
          height: 56.h,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(10.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ScannerStatusIndicator extends StatelessWidget {
  final bool isChecking;
  final bool isConnected;
  final bool hasError;
  final VoidCallback onRefresh;

  const _ScannerStatusIndicator({
    required this.isChecking,
    required this.isConnected,
    required this.hasError,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    late final Color dotColor;
    late final String label;

    if (isChecking) {
      dotColor = Colors.white70;
      label = 'main.fingerprint.scanner_checking'.tr();
    } else if (hasError) {
      dotColor = const Color(0xFFFFB74D);
      label = 'main.fingerprint.scanner_error'.tr();
    } else if (isConnected) {
      dotColor = const Color(0xFF28C711);
      label = 'main.fingerprint.scanner_connected'.tr();
    } else {
      dotColor = const Color(0xFFE85D4C);
      label = 'main.fingerprint.scanner_not_connected'.tr();
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isChecking ? null : onRefresh,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.white24),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isChecking)
                SizedBox(
                  width: 14.w,
                  height: 14.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white70,
                  ),
                )
              else
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (!isChecking) ...[
                SizedBox(width: 6.w),
                Icon(Icons.refresh, color: Colors.white54, size: 16.sp),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
