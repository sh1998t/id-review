import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:id_renew/core/errors/failures.dart';
import 'package:id_renew/feature/main/presentation/widgets/language_dropdown.dart';
import 'package:id_renew/feature/services/presentation/page/services_page.dart';
import 'package:id_renew/feature/widgets/bacround_widget.dart';
import 'package:id_renew/feature/widgets/main_text_field.dart';

import '../../data/models/login_request.dart';
import '../bloc/auth/auth_bloc.dart';

const _greenButton = Color(0xFF28C711);

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

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

    context.read<AuthBloc>().add(
          LoginEvent(
            request: LoginRequest(
              login: _loginController.text.trim(),
              password: _passwordController.text,
            ),
          ),
        );
  }

  String _failureMessage(Failure? failure) {
    if (failure == null) return '';
    return failure.error?.message ??
        failure.error?.error ??
        failure.message ??
        'auth.login_failed'.tr();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous.isLoggedIn != current.isLoggedIn,
      listener: (context, state) {
        if (state.isLoggedIn) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ServicesPage()),
          );
        }
      },
      child: Scaffold(
        body: BacroundWidget(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 16.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: Image.asset(
                          'assets/flag/gerb.png',
                          height: 60.r,
                          width: 60.r,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          'main.org_title'.tr(),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.25,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      const LanguageDropdown(),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'auth.notice'.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      height: 1.35,
                    ),
                  ),
                  BlocBuilder<AuthBloc, AuthState>(
                    buildWhen: (previous, current) =>
                        previous.error != current.error,
                    builder: (context, state) {
                      final message = _failureMessage(state.error);
                      if (message.isEmpty) {
                        return SizedBox(height: 12.h);
                      }

                      return Padding(
                        padding: EdgeInsets.only(top: 12.h),
                        child: Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFFFFB74D),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                  const Spacer(),
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 420.w),
                      child: BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return _LoginCard(
                            formKey: _formKey,
                            loginController: _loginController,
                            passwordController: _passwordController,
                            validateLogin: _validateLogin,
                            validatePassword: _validatePassword,
                            isLoading: state.isLoading,
                            onSubmit: _onSubmit,
                          );
                        },
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController loginController;
  final TextEditingController passwordController;
  final String? Function(String?) validateLogin;
  final String? Function(String?) validatePassword;
  final bool isLoading;
  final VoidCallback onSubmit;

  const _LoginCard({
    required this.formKey,
    required this.loginController,
    required this.passwordController,
    required this.validateLogin,
    required this.validatePassword,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          height: 340.h,
          padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 24.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.18),
                Colors.white.withValues(alpha: 0.08),
              ],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.22),
            ),
          ),
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'auth.title'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 24.h),
                MainTextField(
                  controller: loginController,
                  hintText: 'auth.login_hint'.tr(),
                  title: 'auth.login'.tr(),
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  validator: validateLogin,
                  borderRadius: 10.r,
                ),
                SizedBox(height: 16.h),
                MainTextField(
                  controller: passwordController,
                  hintText: 'auth.password_hint'.tr(),
                  title: 'auth.password'.tr(),
                  obscureText: true,
                  validator: validatePassword,
                  borderRadius: 10.r,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : onSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _greenButton,
                      disabledBackgroundColor:
                          _greenButton.withValues(alpha: 0.6),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 22.w,
                            height: 22.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'auth.sign_in'.tr(),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
