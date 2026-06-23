import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:id_renew/feature/services/presentation/widgets/glass_container.dart';
import 'package:id_renew/feature/widgets/bacround_widget.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BacroundWidget(child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40,),
            Row(
              children: [
                ClipOval(child: Image.asset('assets/flag/gerb.png', height: 60, width: 60,fit: BoxFit.fill,)),
                SizedBox(width: 10.w,),
                SizedBox(
                  width: 300.w,
                  child: Text('Migratsiya va fuqarolikni rasmiylashtirish boshqarmasi', style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white
                  ),),
                ),
              ],
            ),
            SizedBox(height: 30.h,),
            Text('Xizmatlar', style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),),
            Divider(
               height: 1,
              color: Colors.white,

            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GlassContainer(
                  heightIcon: 60.h,
                  widthIIcon: 70.w,
                  height: 130.h, width: 200.w, title: 'Biometrik passportni ID kartaga almashtirish',
                  icon: 'gerb_icon.svg',
                  icon2: 'icon_person.svg',),
                GlassContainer(
                  height: 130.h, width: 200.w, title: 'ID kartani almashtirish(Muddatini yangilash)',
                  icon: 'watch.svg',
                  icon2: 'icon_person.svg',),

              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GlassContainer(
                  heightIcon: 60.h,
                  widthIIcon: 70.w,
                  height: 130.h, width: 200.w, title: 'Fuqaroligi bo’lmagan shaxslar uchun ID karta almashtirish',
                  icon: 'document.svg',
                  icon2: 'icon_person.svg',),
                GlassContainer(
                  height: 130.h, width: 200.w, title: 'Fuqaroligi bo’lmagan shaxslar uchun ID karta almashtirish',
                  icon: 'watch.svg',
                  icon2: 'watch.svg',),

              ],
            ),
          ],
        ),
      )),
    );
  }
}
