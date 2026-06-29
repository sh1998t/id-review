import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:id_renew/core/di/injection.dart';
import 'package:id_renew/core/errors/failures.dart';
import 'package:id_renew/feature/main/presentation/bloc/id_renewal/id_renewal_bloc.dart';
import 'package:id_renew/feature/widgets/bacround_widget.dart';

import '../widgets/custom_stepper.dart';
import '../widgets/language_dropdown.dart';
import '../widgets/steps/applicant_step_widget.dart';
import '../widgets/steps/face_id_step_widget.dart';
import '../widgets/steps/fingerprint_step_widget.dart';
import '../widgets/steps/review_step_widget.dart';
import '../widgets/steps/signature_step_widget.dart';

class MainPage extends StatefulWidget {
  final String serviceType;

  const MainPage({
    super.key,
    this.serviceType = 'id_renewal',
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _pinflController = TextEditingController();
  final _passportController = TextEditingController();
  final _phoneController = TextEditingController();
  final _signatureKey = GlobalKey<SignatureStepWidgetState>();

  List<StepItem> get _steps => [
        StepItem(
          number: '01',
          title: 'main.steps.applicant_title'.tr(),
          subtitle: 'main.steps.applicant_subtitle'.tr(),
        ),
        StepItem(
          number: '02',
          title: 'main.steps.face_id_title'.tr(),
          subtitle: 'main.steps.face_id_subtitle'.tr(),
        ),
        StepItem(
          number: '03',
          title: 'main.steps.fingerprint_title'.tr(),
          subtitle: 'main.steps.fingerprint_subtitle'.tr(),
        ),
        StepItem(
          number: '04',
          title: 'main.steps.signature_title'.tr(),
          subtitle: 'main.steps.signature_subtitle'.tr(),
        ),
        StepItem(
          number: '05',
          title: 'main.steps.review_title'.tr(),
          subtitle: 'main.steps.review_subtitle'.tr(),
        ),
      ];

  @override
  void dispose() {
    _pinflController.dispose();
    _passportController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  IdRenewalBloc get _bloc => context.read<IdRenewalBloc>();

  void _syncApplicant() {
    _bloc.add(
      ApplicantUpdated(
        pinfl: _pinflController.text,
        passport: _passportController.text,
      ),
    );
  }

  void _syncContact() {
    _bloc.add(ContactUpdated(_phoneController.text));
  }

  Future<void> _syncSignature() async {
    final bytes = await _signatureKey.currentState?.exportSignatureBytes();
    if (bytes != null) {
      _bloc.add(SignatureUpdated(bytes));
    }
  }

  Future<void> _onNext(int currentStep) async {
    _bloc.add(IdRenewalErrorCleared());

    switch (currentStep) {
      case 0:
        _syncApplicant();
      case 1:
        break;
      case 2:
        break;
      case 3:
        await _syncSignature();
      case 4:
        _syncContact();
        _bloc.add(IdRenewalSubmitted());
        return;
    }

    _bloc.add(IdRenewalNextStepRequested());
  }

  void _onBack() {
    _bloc.add(IdRenewalPreviousStepRequested());
  }

  String _failureMessage(Failure? failure) {
    if (failure == null) return '';
    return failure.error?.message ??
        failure.error?.error ??
        failure.message ??
        'main.common.error'.tr();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => inject<IdRenewalBloc>()
        ..add(IdRenewalStarted(serviceType: widget.serviceType)),
      child: BlocConsumer<IdRenewalBloc, IdRenewalState>(
        listenWhen: (previous, current) =>
            previous.isSubmitted != current.isSubmitted ||
            previous.error != current.error,
        listener: (context, state) {
          if (state.isSubmitted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('main.common.submit_success'.tr())),
            );
            Navigator.of(context).pop();
            return;
          }

          final message = _failureMessage(state.error);
          if (message.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          }
        },
        builder: (context, state) {
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
                            'main.org_title'.tr(),
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
                    if (state.isLoading && state.applicationId == null)
                      Padding(
                        padding: EdgeInsets.only(top: 24.h),
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    else ...[
                      SizedBox(height: 20.h),
                      IndexedStack(
                        index: state.currentStep,
                        children: [
                          ApplicantStepWidget(
                            pinflController: _pinflController,
                            passportController: _passportController,
                            onChanged: (pinfl, passport) => _syncApplicant(),
                          ),
                          FaceIdStepWidget(
                            onPhotoCaptured: (bytes) {
                              _bloc.add(
                                FacePhotoUpdated(Uint8List.fromList(bytes)),
                              );
                            },
                          ),
                          FingerprintStepWidget(
                            onFingerprintsChanged: (fingerprints, disabled) {
                              _bloc.add(
                                FingerprintsUpdated(
                                  fingerprints: fingerprints,
                                  disabledFingers: disabled,
                                ),
                              );
                            },
                          ),
                          SignatureStepWidget(key: _signatureKey),
                          ReviewStepWidget(
                            phoneController: _phoneController,
                            onChanged: (_) => _syncContact(),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            bottomNavigationBar: state.applicationId == null
                ? null
                : CustomStepper(
                    currentStep: state.currentStep,
                    onBack: state.isLoading ? null : _onBack,
                    onNext: state.isLoading
                        ? null
                        : () => _onNext(state.currentStep),
                    steps: _steps,
                  ),
          );
        },
      ),
    );
  }
}
