import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlagWidget extends StatelessWidget {
  final double height;
  final double width;
  final String url;
  final GestureTapCallback? onTap;
  final String lang;
  const FlagWidget({super.key, required this.height, required this.width, required this.url, required this.lang,  this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/flag/$url.png',
              height: height,
              width: width,
              fit: BoxFit.fitHeight,
            ),
          ),
          SizedBox(height: 6.h,),
          Text(lang, style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),)
        ],
      ),
    );
  }
}
