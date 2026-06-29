import 'package:dio/dio.dart';
import 'package:id_renew/core/constants/app_constants.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../models/auth_response_model.dart';
import '../models/login_request.dart';

part 'auth_api_service.g.dart';

@RestApi()
@singleton
abstract class AuthApiService {
  @factoryMethod
  factory AuthApiService(@Named('UnauthorizedClient') Dio dio) = _AuthApiService;

  @POST(AppConstants.auth)
  Future<HttpResponse<AuthResponseModel>> authLogin(
    @Body() LoginRequest request,
  );
}
