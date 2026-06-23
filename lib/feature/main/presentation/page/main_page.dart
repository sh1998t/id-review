import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../widgets/bacround_widget.dart';
import '../widgets/custom_stepper.dart';
import '../widgets/language_dropdown.dart';
import '../widgets/steps/applicant_step_widget.dart';
import '../widgets/steps/face_id_step_widget.dart';
import '../widgets/steps/fingerprint_step_widget.dart';
import '../widgets/steps/review_step_widget.dart';
import '../widgets/steps/signature_step_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentStep = 0;

  static const _steps = [
    StepItem(
      number: '01',
      title: 'Arizachi',
      subtitle: "Ma'lumot kiritish",
    ),
    StepItem(
      number: '02',
      title: 'Face ID',
      subtitle: 'Rasmga tushish',
    ),
    StepItem(
      number: '03',
      title: 'Barmoq izi',
      subtitle: "Ma'lumot kiritish",
    ),
    StepItem(
      number: '04',
      title: "Imzoni qo'yish",
      subtitle: "Ma'lumot kiritish",
    ),
    StepItem(
      number: '05',
      title: 'Nazorat tekshiruvi',
      subtitle: 'Tekshirish',
    ),
  ];

  void _goNext() {
    if (_currentStep >= _steps.length - 1) return;
    setState(() => _currentStep++);
  }

  void _goBack() {
    if (_currentStep <= 0) return;
    setState(() => _currentStep--);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: BacroundWidget(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                      'Migratsiya va fuqarolikni rasmiylashtirish boshqarmasi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  const LanguageDropdown(),
                ],
              ),
              SizedBox(height: 20.h),
              IndexedStack(
                index: _currentStep,
                children: const [
                  ApplicantStepWidget(),
                  FaceIdStepWidget(),
                  FingerprintStepWidget(),
                  SignatureStepWidget(),
                  ReviewStepWidget(),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomStepper(
        currentStep: _currentStep,
        onBack: _goBack,
        onNext: _goNext,
        steps: _steps,
      ),
    );
  }
}
