import 'package:flutter/material.dart';

const primaryColor = darkBlueColor;
const darkGreenColor = Color(0xFF006400);
const darkRedColor = Color(0xFFC00000);
const darkBlueColor = Color(0xFF3076B5);

Color hexToColor(String hexString) {
  hexString = hexString.replaceFirst('#', '');
  return Color(int.parse(hexString.substring(0, 6), radix: 16) + 0xFF000000);
}
