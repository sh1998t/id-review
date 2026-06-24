import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:id_renew/feature/main/presentation/widgets/language_dropdown.dart';
import 'package:id_renew/feature/services/presentation/page/services_page.dart';
import 'package:id_renew/feature/widgets/bacround_widget.dart';
import 'package:id_renew/feature/widgets/button_widget.dart';
import 'package:id_renew/feature/widgets/main_text_field.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  static const _iconColor = Colors.black;

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateLogin(String? value) {
    final login = value?.trim() ?? '';
    if (login.isEmpty) {
      return 'auth.login_required'.tr();
    }
    if (login.length < 3) {
      return 'auth.login_min_length'.tr();
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) {
      return 'auth.password_required'.tr();
    }
    if (password.length < 6) {
      return 'auth.password_min_length'.tr();
    }
    return null;
  }

  void _onSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ServicesPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BacroundWidget(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                ClipOval(
                  child: Image.asset(
                    'assets/flag/gerb.png',
                    height: 85.r,
                    width: 85.r,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 18.h),
                Text(
                  'auth.greeting'.tr(),
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 24.h),
                MainTextField(
                  controller: _loginController,
                  hintText: 'auth.login_hint'.tr(),
                  title: 'auth.login'.tr(),
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  validator: _validateLogin,
                  prefix: Icon(
                    Icons.person_outline,
                    color: _iconColor,
                    size: 22.sp,
                  ),
                ),
                SizedBox(height: 12.h),
                MainTextField(
                  controller: _passwordController,
                  hintText: 'auth.password_hint'.tr(),
                  title: 'auth.password'.tr(),
                  obscureText: _obscurePassword,
                  validator: _validatePassword,
                  prefix: Icon(
                    Icons.lock_outline,
                    color: _iconColor,
                    size: 22.sp,
                  ),
                  suffix: IconButton(
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: _iconColor,
                      size: 22.sp,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                ButtonWidget(
                  height: 50.h,
                  width: MediaQuery.of(context).size.width,
                  backgroundColor: Colors.transparent,
                  borderColor: Colors.white,
                  title: 'auth.sign_in'.tr(),
                  onPressed: _onSubmit,
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
