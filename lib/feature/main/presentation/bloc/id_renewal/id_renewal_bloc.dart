import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:id_renew/core/errors/failures.dart';
import 'package:id_renew/core/types/typedefs.dart';
import 'package:id_renew/feature/main/domain/entities/applicant_info.dart';
import 'package:id_renew/feature/main/domain/entities/fingerprint_print.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../data/models/applicant_request.dart';
import '../../../domain/repositories/id_renewal_repository.dart';

part 'id_renewal_bloc.freezed.dart';
part 'id_renewal_event.dart';
part 'id_renewal_state.dart';

@injectable
class IdRenewalBloc extends Bloc<IdRenewalEvent, IdRenewalState> {
  final IdRenewalRepository _repository;

  IdRenewalBloc(this._repository) : super(const IdRenewalState()) {
    on<IdRenewalStarted>(_onStarted);
    on<ApplicantUpdated>(_onApplicantUpdated);
    on<FacePhotoUpdated>(_onFacePhotoUpdated);
    on<FingerprintsUpdated>(_onFingerprintsUpdated);
    on<SignatureUpdated>(_onSignatureUpdated);
    on<ContactUpdated>(_onContactUpdated);
    on<IdRenewalNextStepRequested>(_onNextStep);
    on<IdRenewalPreviousStepRequested>(_onPreviousStep);
    on<IdRenewalSubmitted>(_onSubmitted);
    on<IdRenewalErrorCleared>((event, emit) {
      emit(state.copyWith(error: null));
    });
  }

  Future<void> _onStarted(
    IdRenewalStarted event,
    Emitter<IdRenewalState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        error: null,
        serviceType: event.serviceType,
        currentStep: 0,
        isSubmitted: false,
      ),
    );

    final result = await _repository.createApplication(
      serviceType: event.serviceType,
    );

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure)),
      (application) => emit(
        state.copyWith(
          isLoading: false,
          applicationId: application.id,
          applicationStatus: application.status,
        ),
      ),
    );
  }

  void _onApplicantUpdated(
    ApplicantUpdated event,
    Emitter<IdRenewalState> emit,
  ) {
    try {
      final request = ApplicantRequest.fromForm(
        pinfl: event.pinfl,
        passport: event.passport,
      );

      emit(
        state.copyWith(
          applicant: ApplicantInfo(
            pinfl: request.pinfl,
            passportSeries: request.passportSeries,
            passportNumber: request.passportNumber,
          ),
          error: null,
        ),
      );
    } on FormatException catch (error) {
      emit(state.copyWith(error: ValidationFailure(message: error.message)));
    }
  }

  void _onFacePhotoUpdated(
    FacePhotoUpdated event,
    Emitter<IdRenewalState> emit,
  ) {
    emit(state.copyWith(facePhoto: event.photoBytes, error: null));
  }

  void _onFingerprintsUpdated(
    FingerprintsUpdated event,
    Emitter<IdRenewalState> emit,
  ) {
    emit(
      state.copyWith(
        fingerprints: event.fingerprints,
        disabledFingers: event.disabledFingers,
        error: null,
      ),
    );
  }

  void _onSignatureUpdated(
    SignatureUpdated event,
    Emitter<IdRenewalState> emit,
  ) {
    emit(state.copyWith(signature: event.signatureBytes, error: null));
  }

  void _onContactUpdated(
    ContactUpdated event,
    Emitter<IdRenewalState> emit,
  ) {
    emit(state.copyWith(phone: event.phone.trim(), error: null));
  }

  Future<void> _onNextStep(
    IdRenewalNextStepRequested event,
    Emitter<IdRenewalState> emit,
  ) async {
    if (state.isLoading) return;

    final applicationId = state.applicationId;
    if (applicationId == null) {
      emit(
        state.copyWith(
          error: const UnknownFailure(message: 'Application is not created'),
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));

    final result = await _saveCurrentStep(applicationId);

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure)),
      (_) {
        if (state.currentStep >= 4) {
          emit(state.copyWith(isLoading: false));
          return;
        }
        emit(
          state.copyWith(
            isLoading: false,
            currentStep: state.currentStep + 1,
          ),
        );
      },
    );
  }

  void _onPreviousStep(
    IdRenewalPreviousStepRequested event,
    Emitter<IdRenewalState> emit,
  ) {
    if (state.currentStep <= 0 || state.isLoading) return;
    emit(state.copyWith(currentStep: state.currentStep - 1, error: null));
  }

  Future<void> _onSubmitted(
    IdRenewalSubmitted event,
    Emitter<IdRenewalState> emit,
  ) async {
    final applicationId = state.applicationId;
    if (applicationId == null) {
      emit(
        state.copyWith(
          error: const UnknownFailure(message: 'Application is not created'),
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));

    final contactResult = await _saveContact(applicationId);

    await contactResult.fold(
      (failure) async {
        emit(state.copyWith(isLoading: false, error: failure));
      },
      (_) async {
        final submitResult = await _repository.submitApplication(
          applicationId: applicationId,
        );

        submitResult.fold(
          (failure) => emit(state.copyWith(isLoading: false, error: failure)),
          (application) => emit(
            state.copyWith(
              isLoading: false,
              isSubmitted: true,
              applicationStatus: application.status,
            ),
          ),
        );
      },
    );
  }

  ResultFuture<void> _saveCurrentStep(String applicationId) {
    switch (state.currentStep) {
      case 0:
        return _saveApplicant(applicationId);
      case 1:
        return _saveFace(applicationId);
      case 2:
        return _saveFingerprints(applicationId);
      case 3:
        return _saveSignature(applicationId);
      case 4:
        return _saveContact(applicationId);
      default:
        return Future.value(const Right(null));
    }
  }

  ResultFuture<void> _saveApplicant(String applicationId) async {
    final applicant = state.applicant;
    if (applicant == null || applicant.pinfl.length != 14) {
      return const Left(
        ValidationFailure(message: 'PINFL must contain 14 digits'),
      );
    }

    return _repository.saveApplicant(
      applicationId: applicationId,
      applicant: applicant,
    );
  }

  ResultFuture<void> _saveFace(String applicationId) async {
    final photo = state.facePhoto;
    if (photo == null || photo.isEmpty) {
      return const Left(
        ValidationFailure(message: 'Face photo is required'),
      );
    }

    return _repository.uploadFacePhoto(
      applicationId: applicationId,
      photoBytes: photo,
    );
  }

  ResultFuture<void> _saveFingerprints(String applicationId) async {
    final requiredFingers = <int>{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
      ..removeAll(state.disabledFingers);

    final missing = requiredFingers.where(
      (finger) => !state.fingerprints.containsKey(finger),
    );

    if (missing.isNotEmpty) {
      return Left(
        ValidationFailure(
          message: 'Missing fingerprints: ${missing.join(', ')}',
        ),
      );
    }

    return _repository.uploadFingerprints(
      applicationId: applicationId,
      fingerprints: state.fingerprints.values.toList(),
      disabledFingers: state.disabledFingers,
    );
  }

  ResultFuture<void> _saveSignature(String applicationId) async {
    final signature = state.signature;
    if (signature == null || signature.isEmpty) {
      return const Left(
        ValidationFailure(message: 'Signature is required'),
      );
    }

    return _repository.uploadSignature(
      applicationId: applicationId,
      signatureBytes: signature,
    );
  }

  ResultFuture<void> _saveContact(String applicationId) async {
    final phone = state.phone;
    if (phone == null || phone.replaceAll(RegExp(r'\D'), '').length < 12) {
      return const Left(
        ValidationFailure(message: 'Phone number is required'),
      );
    }

    return _repository.saveContact(
      applicationId: applicationId,
      phone: phone,
    );
  }
}
