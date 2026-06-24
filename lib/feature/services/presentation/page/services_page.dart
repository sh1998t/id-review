import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:id_renew/feature/main/presentation/widgets/language_dropdown.dart';
import 'package:id_renew/feature/services/presentation/widgets/glass_container.dart';
import 'package:id_renew/feature/widgets/bacround_widget.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BacroundWidget(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/flag/gerb.png',
                      height: 60,
                      width: 60,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      'main.org_title'.tr(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const LanguageDropdown(),
                ],
              ),
              SizedBox(height: 30.h),
              Text(
                'services.title'.tr(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const Divider(
                height: 1,
                color: Colors.white,
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GlassContainer(
                    heightIcon: 60.h,
                    widthIIcon: 70.w,
                    height: 130.h,
                    width: 200.w,
                    title: 'services.biometric_passport'.tr(),
                    icon: 'gerb_icon.svg',
                    icon2: 'icon_person.svg',
                  ),
                  GlassContainer(
                    height: 130.h,
                    width: 200.w,
                    title: 'services.id_renewal'.tr(),
                    icon: 'watch.svg',
                    icon2: 'icon_person.svg',
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GlassContainer(
                    heightIcon: 60.h,
                    widthIIcon: 70.w,
                    height: 130.h,
                    width: 200.w,
                    title: 'services.non_citizen_replacement'.tr(),
                    icon: 'document.svg',
                    icon2: 'icon_person.svg',
                  ),
                  GlassContainer(
                    height: 130.h,
                    width: 200.w,
                    title: 'services.non_citizen_replacement'.tr(),
                    icon: 'watch.svg',
                    icon2: 'watch.svg',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
