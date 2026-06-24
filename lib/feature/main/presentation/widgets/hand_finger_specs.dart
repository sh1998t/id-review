class HandViewBox {
  static const double width = 418;
  static const double height = 452;
}

class FingerAssetMeta {
  final String path;
  final double width;
  final double height;

  const FingerAssetMeta({
    required this.path,
    required this.width,
    required this.height,
  });

  double get aspectRatio => width / height;
}

class FingerTipSpec {
  final int finger;
  final double cx;
  final double cy;
  final double rx;
  final double ry;
  final double offsetX;
  final double offsetY;
  final double rotate;
  final double scale;
  final FingerAssetMeta asset;

  const FingerTipSpec({
    required this.finger,
    required this.cx,
    required this.cy,
    required this.rx,
    required this.ry,
    required this.asset,
    this.offsetX = 0,
    this.offsetY = 0,
    this.rotate = 0,
    this.scale = 1,
  });
}

class HandFingerAssets {
  static const finger01 = FingerAssetMeta(
    path: 'assets/finger/finger_01.png',
    width: 140,
    height: 220,
  );
  static const finger02 = FingerAssetMeta(
    path: 'assets/finger/finger_02.png',
    width: 140,
    height: 220,
  );
  static const finger03 = FingerAssetMeta(
    path: 'assets/finger/finger_03.png',
    width: 140,
    height: 220,
  );
  static const finger04 = FingerAssetMeta(
    path: 'assets/finger/finger_04.png',
    width: 140,
    height: 220,
  );
  static const finger05 = FingerAssetMeta(
    path: 'assets/finger/finger_05.png',
    width: 140,
    height: 220,
  );
  static const finger06 = FingerAssetMeta(
    path: 'assets/finger/finger_06.png',
    width: 140,
    height: 220,
  );
  static const finger07 = FingerAssetMeta(
    path: 'assets/finger/finger_07.png',
    width: 140,
    height: 220,
  );
  static const finger08 = FingerAssetMeta(
    path: 'assets/finger/finger_08.png',
    width: 140,
    height: 220,
  );
  static const finger09 = FingerAssetMeta(
    path: 'assets/finger/finger_09.png',
    width: 56,
    height: 109,
  );
  static const finger10 = FingerAssetMeta(
    path: 'assets/finger/finger_10.png',
    width: 117,
    height: 205,
  );
}

class HandFingerSpecs {
  static const leftTips = <FingerTipSpec>[
    FingerTipSpec(
      finger: 1,
      cx: 20,
      cy: 135,
      rx: 20,
      ry: 27,
      offsetY: 22,
      offsetX: 2,
      asset: HandFingerAssets.finger01,
    ),
    FingerTipSpec(
      finger: 2,
      cx: 77,
      cy: 57.4,
      rx: 21,
      ry: 29,
      offsetY: 20,
      asset: HandFingerAssets.finger02,
    ),
    FingerTipSpec(
      finger: 3,
      cx: 139,
      cy: 30,
      rx: 22,
      ry: 30,
      offsetY: 18,
      asset: HandFingerAssets.finger03,
    ),
    FingerTipSpec(
      finger: 4,
      cx: 390,
      cy: 255,
      rx: 28,
      ry: 23,
      offsetY: 14,
      offsetX: 10,
      rotate: -32,
      asset: HandFingerAssets.finger04,
    ),
    FingerTipSpec(
      finger: 5,
      cx: 256,
      cy: 55,
      rx: 22,
      ry: 28,
      offsetY: 20,
      offsetX: -2,
      asset: HandFingerAssets.finger05,
    ),
  ];

  static const rightTips = <FingerTipSpec>[
    FingerTipSpec(
      finger: 6,
      cx: 28.8,
      cy: 257,
      rx: 30,
      ry: 23,
      offsetY: 14,
      offsetX: -10,
      rotate: 36,
      asset: HandFingerAssets.finger06,
    ),
    FingerTipSpec(
      finger: 7,
      cx: 162,
      cy: 55,
      rx: 22,
      ry: 28,
      offsetY: 20,
      asset: HandFingerAssets.finger07,
    ),
    FingerTipSpec(
      finger: 8,
      cx: 278.5,
      cy: 30,
      rx: 22,
      ry: 30,
      offsetY: 18,
      asset: HandFingerAssets.finger08,
    ),
    FingerTipSpec(
      finger: 9,
      cx: 340,
      cy: 57,
      rx: 21,
      ry: 28,
      offsetY: 20,
      offsetX: 2,
      asset: HandFingerAssets.finger09,
    ),
    FingerTipSpec(
      finger: 10,
      cx: 397.5,
      cy: 135,
      rx: 20,
      ry: 26,
      offsetY: 22,
      offsetX: -2,
      asset: HandFingerAssets.finger10,
    ),
  ];
}
