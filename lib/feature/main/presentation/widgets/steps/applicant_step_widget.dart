import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:id_renew/core/services/text_format.dart';
import 'package:id_renew/feature/widgets/main_text_field.dart';

class ApplicantStepWidget extends StatelessWidget {
  final TextEditingController pinflController;
  final TextEditingController passportController;
  final void Function(String pinfl, String passport)? onChanged;

  const ApplicantStepWidget({
    super.key,
    required this.pinflController,
    required this.passportController,
    this.onChanged,
  });

  void _notifyChange() {
    onChanged?.call(
      pinflController.text,
      passportController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10.h,
      children: [
        MainTextField(
          controller: pinflController,
          title: 'main.applicant.pinfl'.tr(),
          hintText: 'main.applicant.pinfl_hint'.tr(),
          keyboardType: TextInputType.number,
          inputFormatters: [AppInputMasks.pinfl],
          onchange: (_) => _notifyChange(),
        ),
        MainTextField(
          controller: passportController,
          title: 'main.applicant.passport'.tr(),
          hintText: 'main.applicant.passport_hint'.tr(),
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [AppInputMasks.passport],
          onchange: (_) => _notifyChange(),
        ),
      ],
    );
  }
}
