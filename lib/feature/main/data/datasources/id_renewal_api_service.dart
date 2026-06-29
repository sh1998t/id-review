import 'package:dio/dio.dart';
import 'package:id_renew/core/constants/app_constants.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../models/applicant_request.dart';
import '../models/application_response_model.dart';
import '../models/contact_request.dart';
import '../models/create_application_request.dart';
import '../models/fingerprint_upload_request.dart';
import '../models/signature_request.dart';

part 'id_renewal_api_service.g.dart';

@RestApi()
@singleton
abstract class IdRenewalApiService {
  @factoryMethod
  factory IdRenewalApiService(Dio dio) = _IdRenewalApiService;

  @POST(AppConstants.idRenewalApplications)
  Future<ApplicationResponseModel> createApplication(
    @Body() CreateApplicationRequest request,
  );

  @POST(AppConstants.idRenewalApplicant)
  Future<void> saveApplicant(
    @Path('id') String applicationId,
    @Body() ApplicantRequest request,
  );

  @POST(AppConstants.idRenewalFace)
  @MultiPart()
  Future<void> uploadFacePhoto(
    @Path('id') String applicationId,
    @Part(name: 'photo') MultipartFile photo,
  );

  @POST(AppConstants.idRenewalFingerprints)
  Future<void> uploadFingerprints(
    @Path('id') String applicationId,
    @Body() FingerprintUploadRequest request,
  );

  @POST(AppConstants.idRenewalSignature)
  Future<void> uploadSignature(
    @Path('id') String applicationId,
    @Body() SignatureRequest request,
  );

  @POST(AppConstants.idRenewalContact)
  Future<void> saveContact(
    @Path('id') String applicationId,
    @Body() ContactRequest request,
  );

  @POST(AppConstants.idRenewalSubmit)
  Future<ApplicationResponseModel> submitApplication(
    @Path('id') String applicationId,
  );
}
