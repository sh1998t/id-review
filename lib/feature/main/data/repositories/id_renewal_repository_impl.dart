import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/types/typedefs.dart';
import '../../../auth/data/models/error_model.dart';
import '../../domain/entities/applicant_info.dart';
import '../../domain/entities/fingerprint_print.dart';
import '../../domain/entities/id_renewal_application.dart';
import '../../domain/repositories/id_renewal_repository.dart';
import '../datasources/id_renewal_api_service.dart';
import '../models/applicant_request.dart';
import '../models/contact_request.dart';
import '../models/create_application_request.dart';
import '../models/fingerprint_item_model.dart';
import '../models/fingerprint_upload_request.dart';
import '../models/signature_request.dart';

@LazySingleton(as: IdRenewalRepository)
class IdRenewalRepositoryImpl implements IdRenewalRepository {
  final IdRenewalApiService _apiService;

  IdRenewalRepositoryImpl(this._apiService);

  @override
  ResultFuture<IdRenewalApplication> createApplication({
    required String serviceType,
  }) {
    return _guard(() async {
      final response = await _apiService.createApplication(
        CreateApplicationRequest(serviceType: serviceType),
      );
      return response.toEntity();
    });
  }

  @override
  ResultFuture<void> saveApplicant({
    required String applicationId,
    required ApplicantInfo applicant,
  }) {
    return _guard(() async {
      await _apiService.saveApplicant(
        applicationId,
        ApplicantRequest.fromEntity(applicant),
      );
    });
  }

  @override
  ResultFuture<void> uploadFacePhoto({
    required String applicationId,
    required Uint8List photoBytes,
  }) {
    return _guard(() async {
      await _apiService.uploadFacePhoto(
        applicationId,
        MultipartFile.fromBytes(
          photoBytes,
          filename: 'face.jpg',
          contentType: DioMediaType('image', 'jpeg'),
        ),
      );
    });
  }

  @override
  ResultFuture<void> uploadFingerprints({
    required String applicationId,
    required List<FingerprintPrint> fingerprints,
    required Set<int> disabledFingers,
  }) {
    return _guard(() async {
      await _apiService.uploadFingerprints(
        applicationId,
        FingerprintUploadRequest(
          disabledFingers: disabledFingers.toList()..sort(),
          prints: fingerprints
              .map(
                (print) => FingerprintItemModel(
                  finger: print.fingerNumber,
                  quality: print.quality,
                  imageBase64: base64Encode(print.bytes),
                ),
              )
              .toList(),
        ),
      );
    });
  }

  @override
  ResultFuture<void> uploadSignature({
    required String applicationId,
    required Uint8List signatureBytes,
  }) {
    return _guard(() async {
      await _apiService.uploadSignature(
        applicationId,
        SignatureRequest(imageBase64: base64Encode(signatureBytes)),
      );
    });
  }

  @override
  ResultFuture<void> saveContact({
    required String applicationId,
    required String phone,
  }) {
    return _guard(() async {
      await _apiService.saveContact(
        applicationId,
        ContactRequest(phone: phone),
      );
    });
  }

  @override
  ResultFuture<IdRenewalApplication> submitApplication({
    required String applicationId,
  }) {
    return _guard(() async {
      final response = await _apiService.submitApplication(applicationId);
      return response.toEntity();
    });
  }

  ResultFuture<T> _guard<T>(Future<T> Function() action) async {
    try {
      final result = await action();
      return Right(result);
    } on DioException catch (error) {
      return Left(
        ServerFailure(
          message: error.response?.statusMessage,
          statusCode: error.response?.statusCode,
          error: ErrorModel.fromJson(
            error.response?.data is Map<String, dynamic>
                ? error.response?.data as Map<String, dynamic>
                : null,
          ),
        ),
      );
    } on FormatException catch (error) {
      return Left(ValidationFailure(message: error.message));
    } catch (error) {
      return Left(UnknownFailure(message: error.toString()));
    }
  }
}
