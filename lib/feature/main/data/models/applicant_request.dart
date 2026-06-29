import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/applicant_info.dart';

part 'applicant_request.g.dart';

@JsonSerializable(createFactory: false)
class ApplicantRequest {
  final String pinfl;

  @JsonKey(name: 'passport_series')
  final String passportSeries;

  @JsonKey(name: 'passport_number')
  final String passportNumber;

  const ApplicantRequest({
    required this.pinfl,
    required this.passportSeries,
    required this.passportNumber,
  });

  factory ApplicantRequest.fromEntity(ApplicantInfo info) {
    return ApplicantRequest(
      pinfl: info.pinfl,
      passportSeries: info.passportSeries,
      passportNumber: info.passportNumber,
    );
  }

  factory ApplicantRequest.fromForm({
    required String pinfl,
    required String passport,
  }) {
    final normalized = passport.trim().toUpperCase();
    final match = RegExp(r'^([A-Z]{2})\s*(\d{7})$').firstMatch(normalized);

    if (match == null) {
      throw FormatException('Invalid passport format: $passport');
    }

    return ApplicantRequest(
      pinfl: pinfl.trim(),
      passportSeries: match.group(1)!,
      passportNumber: match.group(2)!,
    );
  }

  Map<String, dynamic> toJson() => _$ApplicantRequestToJson(this);
}
