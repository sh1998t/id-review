import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class Fap60CaptureResult {
  final bool success;
  final String? error;
  final int imageType;
  final bool isLeftHand;
  final int fingers;
  final List<int> quality;
  final List<Uint8List?> fingerImages;

  const Fap60CaptureResult({
    required this.success,
    this.error,
    this.imageType = 0,
    this.isLeftHand = false,
    this.fingers = 0,
    this.quality = const [],
    this.fingerImages = const [],
  });
}

class Fap60Client {
  Fap60Client({this.host = '127.0.0.1', this.port = 7777});

  final String host;
  final int port;
  int _requestId = 0;

  Future<bool> isDeviceOpen() async {
    final resp = await _request({'method': 'status'});
    if (resp['status'] != 'ok') return false;

    final attached = resp['deviceAttached'] == true;
    final permitted = resp['devicePermitted'] == true;
    final open = resp['deviceOpen'] == true;

    return attached && permitted && open;
  }

  Future<Fap60CaptureResult> capture({required int imageType}) async {
    final resp = await _request(
      {'method': 'picture', 'imageType': imageType},
      timeout: const Duration(seconds: 120),
    );

    if (resp['status'] != 'ok') {
      return Fap60CaptureResult(
        success: false,
        error: resp['error']?.toString() ?? 'Unknown error',
        imageType: imageType,
      );
    }

    final quality = (resp['quality'] as List<dynamic>? ?? [])
        .map((e) => (e as num).toInt())
        .toList();

    final images = (resp['fingerImages'] as List<dynamic>? ?? [])
        .map<Uint8List?>((e) {
          if (e == null) return null;
          return base64Decode(e as String);
        })
        .toList();

    return Fap60CaptureResult(
      success: true,
      imageType: imageType,
      isLeftHand: resp['isLeftHand'] == true,
      fingers: (resp['fingers'] as num?)?.toInt() ?? images.length,
      quality: quality,
      fingerImages: images,
    );
  }

  Future<Map<String, dynamic>> _request(
    Map<String, dynamic> payload, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final id = '${++_requestId}';
    final body = {
      'id': id,
      'device': 'FAP60',
      ...payload,
    };

    final socket = await Socket.connect(host, port, timeout: timeout);
    try {
      socket.write('${jsonEncode(body)}\n');
      await socket.flush();

      final buffer = StringBuffer();
      await for (final data in socket.timeout(timeout)) {
        buffer.write(utf8.decode(data));
        if (buffer.toString().contains('\n')) break;
      }

      final line = buffer.toString().trim();
      if (line.isEmpty) {
        return {'status': 'error', 'error': 'Empty response'};
      }
      return jsonDecode(line) as Map<String, dynamic>;
    } finally {
      await socket.close();
    }
  }
}
