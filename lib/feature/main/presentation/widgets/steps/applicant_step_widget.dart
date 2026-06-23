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
          MainTextField(title: 'Ism', hintText: 'Fayozjon'),
          MainTextField(title: 'Familiya', hintText: 'Familiya'),
          MainTextField(
            keyboardType: TextInputType.text,
            title: 'Otasini ismi',
            hintText: 'Otasini ismi',
          ),
          MainTextField(
            title: 'JShShIR',
            hintText: 'JShShIR',
            keyboardType: TextInputType.number,
            inputFormatters: [AppInputMasks.pinfl],
          ),
          MainTextField(
            title: 'Seriya va raqami',
            hintText: 'Seriya va raqami',
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [AppInputMasks.passport],
          ),
          MainTextField(
            title: 'Tug’ilgan sanasi',
            hintText: 'Tug’ilgan sanasi',
            keyboardType: TextInputType.number,
            inputFormatters: [AppInputMasks.birthDate],
          ),
        ],
    );
  }
}
