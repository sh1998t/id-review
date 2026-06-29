part of 'id_renewal_bloc.dart';

@freezed
abstract class IdRenewalState with _$IdRenewalState {
  const factory IdRenewalState({
    @Default(false) bool isLoading,
    @Default(0) int currentStep,
    String? applicationId,
    String? applicationStatus,
    String? serviceType,
    ApplicantInfo? applicant,
    Uint8List? facePhoto,
    @Default({}) Map<int, FingerprintPrint> fingerprints,
    @Default({}) Set<int> disabledFingers,
    Uint8List? signature,
    String? phone,
    @Default(false) bool isSubmitted,
    Failure? error,
  }) = _IdRenewalState;
}
