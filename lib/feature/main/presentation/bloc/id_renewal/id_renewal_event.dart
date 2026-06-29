part of 'id_renewal_bloc.dart';

@immutable
sealed class IdRenewalEvent {}

class IdRenewalStarted extends IdRenewalEvent {
  final String serviceType;

  IdRenewalStarted({required this.serviceType});
}

class ApplicantUpdated extends IdRenewalEvent {
  final String pinfl;
  final String passport;

  ApplicantUpdated({
    required this.pinfl,
    required this.passport,
  });
}

class FacePhotoUpdated extends IdRenewalEvent {
  final Uint8List photoBytes;

  FacePhotoUpdated(this.photoBytes);
}

class FingerprintsUpdated extends IdRenewalEvent {
  final Map<int, FingerprintPrint> fingerprints;
  final Set<int> disabledFingers;

  FingerprintsUpdated({
    required this.fingerprints,
    required this.disabledFingers,
  });
}

class SignatureUpdated extends IdRenewalEvent {
  final Uint8List signatureBytes;

  SignatureUpdated(this.signatureBytes);
}

class ContactUpdated extends IdRenewalEvent {
  final String phone;

  ContactUpdated(this.phone);
}

class IdRenewalNextStepRequested extends IdRenewalEvent {}

class IdRenewalPreviousStepRequested extends IdRenewalEvent {}

class IdRenewalSubmitted extends IdRenewalEvent {}

class IdRenewalErrorCleared extends IdRenewalEvent {}
