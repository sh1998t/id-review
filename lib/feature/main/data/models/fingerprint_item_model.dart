import 'package:json_annotation/json_annotation.dart';

part 'fingerprint_item_model.g.dart';

@JsonSerializable(createFactory: false)
class FingerprintItemModel {
  final int finger;

  final int quality;

  @JsonKey(name: 'image_base64')
  final String imageBase64;

  const FingerprintItemModel({
    required this.finger,
    required this.quality,
    required this.imageBase64,
  });

  Map<String, dynamic> toJson() => _$FingerprintItemModelToJson(this);
}
