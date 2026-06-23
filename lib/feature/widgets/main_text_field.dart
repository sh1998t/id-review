import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class MainTextField extends StatelessWidget {
  const MainTextField({
    super.key,
    this.prefix,
    this.inputFormatters,
    this.hintText,
    this.labelText,
    this.style,
    this.width,
    this.height,
    this.keyboardType,
    this.textAlign,
    this.maxLength,
    this.controller,
    this.onchange,
    this.contentPadding,
    this.validator,
    this.title,
    this.textCapitalization,
    this.obscureText = false,
    this.suffix,
    this.borderRadius,
  });

  final Widget? prefix;
  final List<TextInputFormatter>? inputFormatters;
  final String? hintText;
  final String? labelText;
  final TextStyle? style;
  final double? width;
  final double? height;
  final TextInputType? keyboardType;
  final TextAlign? textAlign;
  final int? maxLength;
  final TextEditingController? controller;
  final ValueChanged? onchange;
  final EdgeInsetsGeometry? contentPadding;
  final String? Function(String?)? validator;
  final String? title;
  final TextCapitalization? textCapitalization;
  final bool obscureText;
  final Widget? suffix;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min ,
      children: [
        Visibility(
          visible: title?.isNotEmpty ?? false,
          child: Text(
            "$title",
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: width,
          height: height,
          child: TextFormField(

            textCapitalization: textCapitalization ?? TextCapitalization.none,
            controller: controller,
            textAlign: textAlign ?? TextAlign.start,
            inputFormatters: inputFormatters,
            maxLength: maxLength,
            onChanged: onchange,
            validator: validator,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Colors.black,
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
            ),
            keyboardType: keyboardType,
            obscureText: obscureText,
            cursorColor: Colors.black,
            decoration: InputDecoration(
                errorMaxLines: 2,
                contentPadding: contentPadding,
                prefix: const SizedBox(),
                prefixIcon: prefix,
                suffixIcon: suffix,
                // fillColor: AppColors.inputColors,
                hintText: hintText,
                labelText: labelText,
                labelStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: 15.sp,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                ),
                hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: 15.sp,
                  color: Color(0xFFA1AAAF),
                  fontWeight: FontWeight.w400,
                ),

                filled: true,
                border: OutlineInputBorder(
                  borderRadius:(borderRadius==null)
                      ? BorderRadius.circular(15.r)
                      :BorderRadius.circular(borderRadius!),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius:(borderRadius==null)
                      ? BorderRadius.circular(15.r)
                      :BorderRadius.circular(borderRadius!),
                  borderSide: const BorderSide(color: Colors.red),
                ),

                // enabledBorder: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(15),
                //   borderSide: BorderSide(
                //     color: dynamicTheme.borderColor,
                //     width: 1.5,
                //   ),
                // ),
                focusedErrorBorder:OutlineInputBorder(
                  borderRadius:(borderRadius==null)
                      ? BorderRadius.circular(15.r)
                      :BorderRadius.circular(borderRadius!),
                  borderSide: const BorderSide(color: Colors.red),
                ) ,
                focusedBorder: OutlineInputBorder(
                  borderRadius:(borderRadius==null)
                      ? BorderRadius.circular(15.r)
                      :BorderRadius.circular(borderRadius!),
                  borderSide: const BorderSide(
                    color: Color(0xFF0D6EFD), // kerakli ko‘k rang
                    width: 1.5,
                  ),
                ),
                errorStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red)
            ),
          ),
        ),
      ],
    );
  }
}
