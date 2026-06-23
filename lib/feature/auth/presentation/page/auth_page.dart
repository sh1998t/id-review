import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:id_renew/feature/widgets/bacround_widget.dart';
import 'package:id_renew/feature/widgets/button_widget.dart';
import 'package:id_renew/feature/widgets/main_text_field.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BacroundWidget(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40.h,),
              ClipOval(
                child: Image.asset(
                  'Assets/image/gerb.png',
                  height: 85.r,
                  width: 85.r,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 18.h,),
              Text('Assalomu Aleykum', style: TextStyle(fontSize: 24.sp,fontWeight: FontWeight.bold, color: Colors.black),),
              MainTextField(
                hintText: 'login',
                title: 'Login',
                suffix: IconButton(onPressed: (){}, icon: Icon(Icons.person)),
              ),
              SizedBox(height: 10.w,),
              MainTextField(
                hintText: 'parol',
                title: 'Parol',
                suffix: IconButton(onPressed: (){}, icon: Icon(Icons.person)),
                prefix: IconButton(onPressed: (){}, icon: Icon(Icons.person)),

              ),
              SizedBox(height: 24.h,),
              ButtonWidget(
                  height: 50.h,
                  width: MediaQuery.of(context).size.width*1,
                  backgroundColor: Colors.transparent,
                  borderColor: Colors.white,
                  title: 'Kirish', onPressed: (){})
            ],
          ),
        ),
      ),
    );
  }
}
