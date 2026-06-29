import 'dart:typed_data';

import '../../../../core/types/typedefs.dart';
import '../entities/applicant_info.dart';
import '../entities/fingerprint_print.dart';
import '../entities/id_renewal_application.dart';

abstract class IdRenewalRepository {
  ResultFuture<IdRenewalApplication> createApplication({
    required String serviceType,
  });

  ResultFuture<void> saveApplicant({
    required String applicationId,
    required ApplicantInfo applicant,
  });

  ResultFuture<void> uploadFacePhoto({
    required String applicationId,
    required Uint8List photoBytes,
  });

  ResultFuture<void> uploadFingerprints({
    required String applicationId,
    required List<FingerprintPrint> fingerprints,
    required Set<int> disabledFingers,
  });

  ResultFuture<void> uploadSignature({
    required String applicationId,
    required Uint8List signatureBytes,
  });

  ResultFuture<void> saveContact({
    required String applicationId,
    required String phone,
  });

  ResultFuture<IdRenewalApplication> submitApplication({
    required String applicationId,
  });
}
