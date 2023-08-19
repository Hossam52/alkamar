import 'package:flutter/material.dart';

class ColorManager {
  ColorManager._();
  static Color primary = HexColor.fromHex('#343541');
  static Color primaryOpacity70 = HexColor.fromHex('#46343541');
  static Color accentColor = HexColor.fromHex('#34D1B6');
  static Color settingsColor = accentColor.withOpacity(0.7);

  static Color darkPrimary = HexColor.fromHex('#007A50');
  static Color darkGrey = HexColor.fromHex('#525252');
  static Color grey = HexColor.fromHex('#B0B0B0');
  static Color lightGrey = HexColor.fromHex('#737477');
  static Color grey1 = HexColor.fromHex('#737477');
  static Color white = HexColor.fromHex('#ffffff');
  static Color error = HexColor.fromHex('#ff0000');
  static Color fillColor = HexColor.fromHex('#28A68C5B');
  static Color cpationColor = Colors.white;
  static Color highlight = HexColor.fromHex("#D6DAFF");

  static Color logout = HexColor.fromHex('#ff0000');
  static Color hintColor = Colors.white54;

  static Color percent100Color = Colors.green.withOpacity(0.7);
  static Color percent85To100Color = Colors.orange.withOpacity(0.7);
  static Color percent70To85Color = Colors.blue.withOpacity(0.7);
  static Color percent50To70Color = Colors.black.withOpacity(0.7);
  static Color percentLessThan50Color = Colors.red.withOpacity(0.7);

  static Color attendedColor = Colors.green.withOpacity(0.82);
  static Color isLateColor = Colors.red.withOpacity(0.8);
  static Color forgotColor = Colors.yellow.withOpacity(0.8);
  static Color cancelColor = Colors.purple.withOpacity(0.8);

  static Color paidColor = Colors.green.withOpacity(0.82);
  static Color notPaidColor = Colors.red.withOpacity(0.8);
  static Color latePaidColor = Colors.yellow.withOpacity(0.8);

  static Color studentStatusColor = Colors.red;
}

extension HexColor on Color {
  static Color fromHex(String hexString) {
    hexString = hexString.replaceAll('#', '');
    if (hexString.length == 6) {
      hexString = 'FF' + hexString;
    }
    return Color(int.parse(hexString, radix: 16));
  }
}
