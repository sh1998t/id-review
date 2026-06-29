import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class FingerprintPrint extends Equatable {
  final int fingerNumber;
  final int quality;
  final Uint8List bytes;

  const FingerprintPrint({
    required this.fingerNumber,
    required this.quality,
    required this.bytes,
  });

  @override
  List<Object?> get props => [fingerNumber, quality, bytes];
}
