import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'hand_finger_specs.dart';

class DisabledFingersModal extends StatefulWidget {
  final Set<int> initialSelected;

  const DisabledFingersModal({
    super.key,
    this.initialSelected = const {},
  });

  static Future<Set<int>?> show(
    BuildContext context, {
    Set<int> initialSelected = const {},
  }) {
    return showDialog<Set<int>>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (_) => DisabledFingersModal(
        initialSelected: initialSelected,
      ),
    );
  }

  @override
  State<DisabledFingersModal> createState() => _DisabledFingersModalState();
}

class _DisabledFingersModalState extends State<DisabledFingersModal> {
  late Set<int> _selectedFingers;

  @override
  void initState() {
    super.initState();
    _selectedFingers = Set<int>.from(widget.initialSelected);
  }

  void _toggleFinger(int fingerNumber) {
    setState(() {
      if (_selectedFingers.contains(fingerNumber)) {
        _selectedFingers.remove(fingerNumber);
      } else {
        _selectedFingers.add(fingerNumber);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxWidth: 520.w),
        padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'main.disabled_fingers.title'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
            SizedBox(height: 28.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HandFingerSelector(
                  isLeftHand: true,
                  selectedFingers: _selectedFingers,
                  onFingerTap: _toggleFinger,
                ),
                SizedBox(width: 32.w),
                HandFingerSelector(
                  isLeftHand: false,
                  selectedFingers: _selectedFingers,
                  onFingerTap: _toggleFinger,
                ),
              ],
            ),
            SizedBox(height: 28.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      side: const BorderSide(color: Colors.black54),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'main.disabled_fingers.back'.tr(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.pop(context, _selectedFingers),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF28C711),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'main.disabled_fingers.save'.tr(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HandFingerSelector extends StatelessWidget {
  final bool isLeftHand;
  final Set<int> selectedFingers;
  final ValueChanged<int> onFingerTap;

  static const _handAsset = 'assets/image/fingr.png';
  static const _invertMatrix = ColorFilter.matrix([
    -1, 0, 0, 0, 255,
    0, -1, 0, 0, 255,
    0, 0, -1, 0, 255,
    0, 0, 0, 1, 0,
  ]);

  const HandFingerSelector({
    super.key,
    required this.isLeftHand,
    required this.selectedFingers,
    required this.onFingerTap,
  });

  @override
  Widget build(BuildContext context) {
    final tips =
        isLeftHand ? HandFingerSpecs.leftTips : HandFingerSpecs.rightTips;
    final displayWidth = 170.w;
    final displayHeight = displayWidth * (HandViewBox.height / HandViewBox.width);
    final scaleX = displayWidth / HandViewBox.width;
    final scaleY = displayHeight / HandViewBox.height;

    final handImage = Opacity(
      opacity: 0.9,
      child: ColorFiltered(
        colorFilter: _invertMatrix,
        child: Image.asset(
          _handAsset,
          width: displayWidth,
          height: displayHeight,
          fit: BoxFit.contain,
        ),
      ),
    );

    return SizedBox(
      width: displayWidth,
      height: displayHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (isLeftHand)
            Transform.flip(flipX: true, child: handImage)
          else
            handImage,
          for (final tip in tips)
            _FingerTipOverlay(
              tip: tip,
              scaleX: scaleX,
              scaleY: scaleY,
              isSelected: selectedFingers.contains(tip.finger),
              onTap: () => onFingerTap(tip.finger),
            ),
        ],
      ),
    );
  }
}

class _FingerTipOverlay extends StatelessWidget {
  final FingerTipSpec tip;
  final double scaleX;
  final double scaleY;
  final bool isSelected;
  final VoidCallback onTap;

  static const _green = Color(0xFF28C711);
  static const _selected = Color(0xFFE85D4C);
  static const _fingerSizeScale = 1.4;

  const _FingerTipOverlay({
    required this.tip,
    required this.scaleX,
    required this.scaleY,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tipColor = isSelected ? _selected : _green;
    final height = tip.ry * 2 * scaleY * _fingerSizeScale * tip.scale;
    final width = height * tip.asset.aspectRatio;
    final anchorX = (tip.cx + tip.offsetX) * scaleX;
    final anchorY = (tip.cy + tip.ry + tip.offsetY) * scaleY;
    final badgeSize = math.min(width, height) * 0.34;

    return Positioned(
      left: anchorX - width / 2,
      top: anchorY - height,
      width: width,
      height: height,
      child: GestureDetector(
        onTap: onTap,
        child: Transform.rotate(
          angle: tip.rotate * math.pi / 180,
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: width,
            height: height,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(tipColor, BlendMode.srcIn),
                    child: Image.asset(
                      tip.asset.path,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: height * 0.14,
                  child: Center(
                    child: Container(
                      width: badgeSize,
                      height: badgeSize,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: tipColor, width: 1.2),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${tip.finger}',
                        style: TextStyle(
                          color: tipColor,
                          fontSize: badgeSize * 0.5,
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
