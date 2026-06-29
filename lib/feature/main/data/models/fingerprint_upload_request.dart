import 'package:json_annotation/json_annotation.dart';

import 'fingerprint_item_model.dart';

part 'fingerprint_upload_request.g.dart';

@JsonSerializable(createFactory: false)
class FingerprintUploadRequest {
  @JsonKey(name: 'disabled_fingers')
  final List<int> disabledFingers;

  final List<FingerprintItemModel> prints;

  const FingerprintUploadRequest({
    required this.disabledFingers,
    required this.prints,
  });

  Map<String, dynamic> toJson() => _$FingerprintUploadRequestToJson(this);
}
