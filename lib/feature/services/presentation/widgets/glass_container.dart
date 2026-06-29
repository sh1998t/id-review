import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glassmorphism/glassmorphism.dart';

import '../../../main/presentation/page/main_page.dart';

class GlassContainer extends StatelessWidget {
  final double width;
  final double height;
  final String title;
  final String icon;
  final String icon2;
  final String serviceType;
  final double? widthIIcon;
  final double? heightIcon;
  const GlassContainer({
    super.key,
    required this.width,
    required this.height,
    this.widthIIcon,
    this.heightIcon,
    required this.title,
    required this.icon,
    required this.icon2,
    this.serviceType = 'id_renewal',
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(serviceType: serviceType),
          ),
        );
      },
      child: GlassmorphicContainer(
        width: width,
        height: height,
        borderRadius: 12,
        blur: 1,
        border: 0,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.25),
            Colors.white.withValues(alpha: 0.20),
          ],
        ),
        borderGradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.transparent,
          ],
        ),
        child: Column(
          children: [
            SizedBox(height: 10.h,),
            Text(title,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: SvgPicture.asset(
                    'assets/svg/$icon',
                    height: heightIcon ?? 45.h,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: 5.w),
                Flexible(
                  child: SvgPicture.asset(
                    'assets/svg/$icon2',
                    height: 45.h,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h,)
          ],
        ),
      ),
    );
  }
}