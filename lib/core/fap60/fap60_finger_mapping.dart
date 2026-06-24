/// Maps FAP60 scanner slot indices to standard finger numbers (1–10).
class Fap60FingerMapping {
  /// Left 4 fingers on scanner: little → index.
  static const leftFour = [4, 3, 2, 1];

  /// Right 4 fingers on scanner: index → little.
  static const rightFour = [7, 8, 9, 10];

  /// Two thumbs: right then left.
  static const twoThumbs = [6, 5];

  static List<int> fingersForImageType(int imageType, {bool isLeftHand = false}) {
    switch (imageType) {
      case 0:
        return leftFour;
      case 1:
        return rightFour;
      case 3:
        return twoThumbs;
      default:
        return isLeftHand ? leftFour : rightFour;
    }
  }

  static int? resolveImageType(Set<int> disabled, List<int> groupFingers) {
    final active = groupFingers.where((f) => !disabled.contains(f)).toList();
    if (active.isEmpty) return null;

    if (_sameSet(groupFingers, leftFour)) return 0;
    if (_sameSet(groupFingers, rightFour)) return 1;
    if (_sameSet(groupFingers, twoThumbs)) return 3;
    return null;
  }

  static bool _sameSet(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  static bool isGroupFullyDisabled(Set<int> disabled, List<int> groupFingers) {
    return groupFingers.every(disabled.contains);
  }
}
