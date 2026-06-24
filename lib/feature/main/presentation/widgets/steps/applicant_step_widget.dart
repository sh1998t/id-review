import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:id_renew/core/services/text_format.dart';
import 'package:id_renew/feature/widgets/main_text_field.dart';

class ApplicantStepWidget extends StatelessWidget {
  const ApplicantStepWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10.h,
      children: [
        MainTextField(
          title: 'main.applicant.first_name'.tr(),
          hintText: 'main.applicant.first_name_hint'.tr(),
        ),
        MainTextField(
          title: 'main.applicant.last_name'.tr(),
          hintText: 'main.applicant.last_name_hint'.tr(),
        ),
        MainTextField(
          keyboardType: TextInputType.text,
          title: 'main.applicant.middle_name'.tr(),
          hintText: 'main.applicant.middle_name_hint'.tr(),
        ),
        MainTextField(
          title: 'main.applicant.pinfl'.tr(),
          hintText: 'main.applicant.pinfl_hint'.tr(),
          keyboardType: TextInputType.number,
          inputFormatters: [AppInputMasks.pinfl],
        ),
        MainTextField(
          title: 'main.applicant.passport'.tr(),
          hintText: 'main.applicant.passport_hint'.tr(),
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [AppInputMasks.passport],
        ),
        MainTextField(
          title: 'main.applicant.birth_date'.tr(),
          hintText: 'main.applicant.birth_date_hint'.tr(),
          keyboardType: TextInputType.number,
          inputFormatters: [AppInputMasks.birthDate],
        ),
      ],
    );
  }
}
