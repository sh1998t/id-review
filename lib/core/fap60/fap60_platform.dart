import 'dart:io';

import 'package:flutter/services.dart';

class Fap60ScannerStatus {
  final bool attached;
  final bool permitted;
  final bool open;
  final int openRetCode;
  final int vid;
  final int pid;

  const Fap60ScannerStatus({
    this.attached = false,
    this.permitted = false,
    this.open = false,
    this.openRetCode = -1,
    this.vid = 0,
    this.pid = 0,
  });

  bool get isReady => attached && permitted && open;

  factory Fap60ScannerStatus.fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) return const Fap60ScannerStatus();
    return Fap60ScannerStatus(
      attached: map['deviceAttached'] == true,
      permitted: map['devicePermitted'] == true,
      open: map['deviceOpen'] == true,
      openRetCode: (map['openRetCode'] as num?)?.toInt() ?? -1,
      vid: (map['vid'] as num?)?.toInt() ?? 0,
      pid: (map['pid'] as num?)?.toInt() ?? 0,
    );
  }
}

class Fap60Platform {
  static const _channel = MethodChannel('com.example.id_renew/fap60');

  static Future<Fap60ScannerStatus> connectScanner() async {
    if (!Platform.isAndroid) return const Fap60ScannerStatus();
    try {
      final result = await _channel.invokeMethod<Map<Object?, Object?>>(
        'connectScanner',
      );
      return Fap60ScannerStatus.fromMap(result);
    } on PlatformException {
      return const Fap60ScannerStatus();
    }
  }
}
