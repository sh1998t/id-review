import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/id_renewal_application.dart';

part 'application_response_model.g.dart';

@JsonSerializable()
class ApplicationResponseModel {
  final String id;
  final String status;

  const ApplicationResponseModel({
    required this.id,
    required this.status,
  });

  factory ApplicationResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ApplicationResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationResponseModelToJson(this);

  IdRenewalApplication toEntity() {
    return IdRenewalApplication(id: id, status: status);
  }
}
