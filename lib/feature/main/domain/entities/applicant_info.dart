import 'package:equatable/equatable.dart';

class ApplicantInfo extends Equatable {
  final String pinfl;
  final String passportSeries;
  final String passportNumber;

  const ApplicantInfo({
    required this.pinfl,
    required this.passportSeries,
    required this.passportNumber,
  });

  String get passportDisplay => '$passportSeries $passportNumber';

  @override
  List<Object?> get props => [pinfl, passportSeries, passportNumber];
}
