import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ButtonWidget extends StatelessWidget {
  final String title;
  final Color? titleColor;
  final Color? color1;
  final Color? color2;
  final Color? backgroundColor;
  final Gradient? gradient;
  final VoidCallback? onPressed;
  final double? height;
  final double? width;
  final bool? isLoading;
  final double? size;
  final VoidCallback? onLongPress;
  final TextStyle? titleStyle;
  final BorderRadiusGeometry? borderRadius;
  final Widget? leadingSvg;
  final Widget? trailingSvg;

  final Color? borderColor;

  const ButtonWidget({
    super.key,
    required this.title,
    this.titleColor,
    this.color1,
    this.color2,
    this.backgroundColor,
    this.gradient,
    required this.onPressed,
    this.height,
    this.width,
    this.size,
    this.isLoading,
    this.onLongPress,
    this.titleStyle,
    this.borderRadius,
    this.leadingSvg,
    this.trailingSvg,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadiusGeometry radius =
        borderRadius ?? BorderRadius.circular(7.r);

    return SizedBox(
      height: height ?? 50.h,
      width: width ?? double.infinity,
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 16.w),
        child: ElevatedButton(
          onPressed: onPressed,
          onLongPress: onLongPress,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor:
            (gradient != null || (color1 != null && color2 != null))
                ? Colors.transparent
                : (backgroundColor ?? Theme.of(context).primaryColor),
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: radius,
              side: BorderSide(
                color: borderColor ?? Colors.transparent,
                width: 1.5,
              ),
            ),
          ),
          child: Ink(
            decoration: (gradient != null || (color1 != null && color2 != null))
                ? BoxDecoration(
              gradient: gradient ??
                  LinearGradient(
                    colors: [color1!, color2!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
              borderRadius: radius,
            )
                : null,
            child: Container(
              alignment: Alignment.center,
              child: (isLoading ?? false)
                  ? const CircularProgressIndicator.adaptive(
                backgroundColor: Colors.white,
              )
                  : Padding(
                padding: (size == null)
                    ? EdgeInsets.symmetric(horizontal: 10.w)
                    : EdgeInsets.symmetric(horizontal: size!),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (leadingSvg != null) ...[
                      leadingSvg!,
                      SizedBox(width: 8.w),
                    ],
                    Flexible(
                      child: Text(
                        title,
                        style: titleStyle ??
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: titleColor ?? Colors.white,
                              fontSize: 17.sp,
                            ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (trailingSvg != null) ...[
                      SizedBox(width: 9.w),
                      trailingSvg!,
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
