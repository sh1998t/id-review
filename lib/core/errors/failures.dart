import 'package:equatable/equatable.dart';

import '../../feature/auth/data/models/error_model.dart';

abstract class Failure extends Equatable {
  final String? message;
  final int? statusCode;
  final ErrorModel? error;

  const Failure({this.message, this.statusCode, this.error});

  @override
  List<Object?> get props => [message, statusCode, error];
}

class ServerFailure extends Failure {
  const ServerFailure({super.message, super.statusCode, super.error});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.statusCode});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.statusCode});
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.statusCode});
}

class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.statusCode});
}

class UnknownFailure extends Failure {
  const UnknownFailure({required super.message, super.statusCode});
}
