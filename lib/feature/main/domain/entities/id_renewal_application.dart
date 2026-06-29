import 'package:equatable/equatable.dart';

class IdRenewalApplication extends Equatable {
  final String id;
  final String status;

  const IdRenewalApplication({
    required this.id,
    required this.status,
  });

  @override
  List<Object?> get props => [id, status];
}
