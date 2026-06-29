// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:id_renew/core/di/dio_module.dart' as _i495;
import 'package:id_renew/core/modules/modules.dart' as _i905;
import 'package:id_renew/core/notifier/auth_notifier.dart' as _i534;
import 'package:id_renew/core/utils/app_preference.dart' as _i584;
import 'package:id_renew/feature/auth/data/datasources/auth_api_service.dart'
    as _i379;
import 'package:id_renew/feature/auth/data/repositories/auth_repository_impl.dart'
    as _i811;
import 'package:id_renew/feature/auth/domain/repositories/auth_repository.dart'
    as _i419;
import 'package:id_renew/feature/auth/presentation/bloc/auth/auth_bloc.dart'
    as _i226;
import 'package:id_renew/feature/main/data/datasources/id_renewal_api_service.dart'
    as _i769;
import 'package:id_renew/feature/main/data/repositories/id_renewal_repository_impl.dart'
    as _i252;
import 'package:id_renew/feature/main/domain/repositories/id_renewal_repository.dart'
    as _i271;
import 'package:id_renew/feature/main/presentation/bloc/id_renewal/id_renewal_bloc.dart'
    as _i484;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final modules = _$Modules();
    final dioModule = _$DioModule();
    gh.singleton<_i558.FlutterSecureStorage>(() => modules.storage);
    gh.singleton<_i584.AppPreference>(
      () => _i584.AppPreference(gh<_i558.FlutterSecureStorage>()),
    );
    gh.singleton<_i361.Dio>(
      () => dioModule.getUnauthorizedDioClient(gh<_i584.AppPreference>()),
      instanceName: 'UnauthorizedClient',
    );
    gh.singleton<_i534.AuthNotifier>(
      () => _i534.AuthNotifier(gh<_i584.AppPreference>()),
    );
    gh.singleton<_i361.Dio>(
      () => dioModule.getAuthorizedDioClient(
        gh<_i584.AppPreference>(),
        gh<_i534.AuthNotifier>(),
      ),
    );
    gh.singleton<_i379.AuthApiService>(
      () => _i379.AuthApiService(
        gh<_i361.Dio>(instanceName: 'UnauthorizedClient'),
      ),
    );
    gh.lazySingleton<_i419.AuthRepository>(
      () => _i811.AuthRepositoryImpl(
        gh<_i379.AuthApiService>(),
        gh<_i534.AuthNotifier>(),
      ),
    );
    gh.singleton<_i769.IdRenewalApiService>(
      () => _i769.IdRenewalApiService(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i271.IdRenewalRepository>(
      () => _i252.IdRenewalRepositoryImpl(gh<_i769.IdRenewalApiService>()),
    );
    gh.factory<_i484.IdRenewalBloc>(
      () => _i484.IdRenewalBloc(gh<_i271.IdRenewalRepository>()),
    );
    gh.factory<_i226.AuthBloc>(
      () => _i226.AuthBloc(gh<_i419.AuthRepository>()),
    );
    return this;
  }
}

class _$Modules extends _i905.Modules {}

class _$DioModule extends _i495.DioModule {}
