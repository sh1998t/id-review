import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AppInputMasks {
  AppInputMasks._();

  /// JShShIR: 00000000000000
  static final pinfl = MaskTextInputFormatter(
    mask: '##############',
    filter: {
      '#': RegExp(r'[0-9]'),
    },
  );

  /// Pasport: AA 0000000
  static final passport = MaskTextInputFormatter(
    mask: 'AA #######',
    filter: {
      'A': RegExp(r'[A-Za-z]'),
      '#': RegExp(r'[0-9]'),
    },
  );

  /// Tug'ilgan sana: 00.00.0000
  static final birthDate = MaskTextInputFormatter(
    mask: '##.##.####',
    filter: {
      '#': RegExp(r'[0-9]'),
    },
  );

  /// Telefon: +998 00 000 00 00
  static final phone = MaskTextInputFormatter(
    mask: '+998 ## ### ## ##',
    filter: {
      '#': RegExp(r'[0-9]'),
    },
  );
}