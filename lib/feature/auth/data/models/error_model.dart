import 'package:json_annotation/json_annotation.dart';

part 'error_model.g.dart';

@JsonSerializable()
class ErrorModel {
  final String? message;
  final ErrorDataModel? errors;
  final String? error;
  final int? statusCode;

  const ErrorModel({
    this.errors,
    this.message,
    this.error,
    this.statusCode,
  });

  factory ErrorModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ErrorModel();
    }
    return _$ErrorModelFromJson(json);
  }
}

@JsonSerializable()
class ErrorDataModel {
  final List<String> errors;

  ErrorDataModel({required this.errors});

  factory ErrorDataModel.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return ErrorDataModel(
        errors: (json['errors'] as List<dynamic>? ?? [])
            .map((e) => e.toString())
            .toList(),
      );
    } else if (json is String) {
      return ErrorDataModel(errors: [json]);
    }
    return ErrorDataModel(
      errors: (json as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() => _$ErrorDataModelToJson(this);
}
