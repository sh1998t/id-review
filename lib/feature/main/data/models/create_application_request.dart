import 'package:json_annotation/json_annotation.dart';

part 'create_application_request.g.dart';

@JsonSerializable(createFactory: false)
class CreateApplicationRequest {
  @JsonKey(name: 'service_type')
  final String serviceType;

  const CreateApplicationRequest({required this.serviceType});

  Map<String, dynamic> toJson() => _$CreateApplicationRequestToJson(this);
}
