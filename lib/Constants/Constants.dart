import 'package:flutter/material.dart';

const primaryColor = darkBlueColor;
const darkGreenColor = Color(0xFF006400);
const darkRedColor = Color(0xFFC00000);
const darkBlueColor = Color(0xFF3076B5);
const namePlaceholder = '__Name__';
const emailPlaceholder = '__Email__';
const phonePlaceholder = '__Phone__';
const newUserEmailTemplate =
    '<div style=\"overflow-x: auto;\">\r\n    <p>A new user signed up with the following details.<\/p>\r\n    <figure class=\"table\" style=\"margin: 0;\">\r\n        <table style=\"width: 100%; border-collapse: collapse;\">\r\n            <tbody>\r\n                <tr>\r\n                    <th style=\"border: 1px solid #dddddd; text-align: left; padding: 8px;\">Name<\/th>\r\n                    <td style=\"border: 1px solid #dddddd; text-align: left; padding: 8px;\">__Name__<\/td>\r\n                <\/tr>\r\n                <tr>\r\n                    <th style=\"border: 1px solid #dddddd; text-align: left; padding: 8px;\">Email<\/th>\r\n                    <td style=\"border: 1px solid #dddddd; text-align: left; padding: 8px;\">__Email__<\/td>\r\n                <\/tr>\r\n                <tr>\r\n                    <th style=\"border: 1px solid #dddddd; text-align: left; padding: 8px;\">Phone Number<\/th>\r\n                    <td style=\"border: 1px solid #dddddd; text-align: left; padding: 8px;\">__Phone__<\/td>\r\n                <\/tr>\r\n            <\/tbody>\r\n        <\/table>\r\n        <figcaption><\/figcaption>\r\n    <\/figure>\r\n<\/div>\r\n';

Color hexToColor(String hexString) {
  hexString = hexString.replaceFirst('#', '');
  return Color(int.parse(hexString.substring(0, 6), radix: 16) + 0xFF000000);
}
