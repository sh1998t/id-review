// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorModel _$ErrorModelFromJson(Map<String, dynamic> json) => ErrorModel(
  errors: json['errors'] == null
      ? null
      : ErrorDataModel.fromJson(json['errors']),
  message: json['message'] as String?,
  error: json['error'] as String?,
  statusCode: (json['statusCode'] as num?)?.toInt(),
);

Map<String, dynamic> _$ErrorModelToJson(ErrorModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'errors': instance.errors,
      'error': instance.error,
      'statusCode': instance.statusCode,
    };

ErrorDataModel _$ErrorDataModelFromJson(Map<String, dynamic> json) =>
    ErrorDataModel(
      errors: (json['errors'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ErrorDataModelToJson(ErrorDataModel instance) =>
    <String, dynamic>{'errors': instance.errors};
