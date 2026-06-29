import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/notifier/auth_notifier.dart';
import '../../../../core/types/typedefs.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_api_service.dart';
import '../models/error_model.dart';
import '../models/login_request.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _authApiService;
  final AuthNotifier _authNotifier;

  AuthRepositoryImpl(this._authApiService, this._authNotifier);

  @override
  ResultFuture<void> login(LoginRequest request) async {
    try {
      final response = await _authApiService.authLogin(request);
      final data = response.data;

      await _authNotifier.setToken(
        accessToken: data.accessToken,
        refreshToken: data.refreshToken,
      );

      return const Right(null);
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
    } catch (error) {
      return Left(UnknownFailure(message: error.toString()));
    }
  }
}
