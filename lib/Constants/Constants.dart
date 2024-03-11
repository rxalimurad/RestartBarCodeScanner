import 'package:flutter/material.dart';

const primaryColor = Colors.black;
const darkGreenColor = Color(0xFF006400);

Color hexToColor(String hexString) {
  hexString = hexString.replaceFirst('#', '');
  return Color(int.parse(hexString.substring(0, 6), radix: 16) + 0xFF000000);
}
