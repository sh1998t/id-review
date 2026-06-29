import 'package:json_annotation/json_annotation.dart';

part 'signature_request.g.dart';

@JsonSerializable(createFactory: false)
class SignatureRequest {
  @JsonKey(name: 'image_base64')
  final String imageBase64;

  const SignatureRequest({required this.imageBase64});

  Map<String, dynamic> toJson() => _$SignatureRequestToJson(this);
}
