import 'package:json_annotation/json_annotation.dart';

part 'contact_request.g.dart';

@JsonSerializable(createFactory: false)
class ContactRequest {
  final String phone;

  const ContactRequest({required this.phone});

  Map<String, dynamic> toJson() => _$ContactRequestToJson(this);
}
