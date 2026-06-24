import 'package:easy_localization/easy_localization.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:id_renew/core/services/text_format.dart';
import 'package:id_renew/feature/widgets/main_text_field.dart';

class ReviewStepWidget extends StatelessWidget {
  const ReviewStepWidget({super.key});

  static const _idCardFront = 'assets/image/passport.png';
  static const _idCardBack = 'assets/image/passport2.png';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MainTextField(
          title: 'main.review.phone_title'.tr(),
          hintText: 'main.review.phone_hint'.tr(),
          keyboardType: TextInputType.phone,
          inputFormatters: [AppInputMasks.phone],
        ),
        SizedBox(height: 20.h),
        Text(
          'main.review.id_card_copy'.tr(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 12.h),
        FlipCard(
          direction: FlipDirection.HORIZONTAL,
          front: const _IdCardImage(assetPath: _idCardFront),
          back: const _IdCardImage(assetPath: _idCardBack),
        ),
      ],
    );
  }
}

class _IdCardImage extends StatelessWidget {
  final String assetPath;

  const _IdCardImage({required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: Image.asset(
        assetPath,
        width: double.infinity,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: 200.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              'main.review.id_card_image'.tr(),
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14.sp,
              ),
            ),
          );
        },
      ),
    );
  }
}
