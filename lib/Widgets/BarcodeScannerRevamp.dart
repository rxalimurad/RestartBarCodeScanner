import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:simple_barcode_scanner/enum.dart';
import 'package:simple_barcode_scanner/screens/window.dart';

/// Barcode scanner for mobile and desktop devices
class BarcodeScannerRevamped extends StatelessWidget {
  final String lineColor;
  final String cancelButtonText;
  final bool isShowFlashIcon;
  final ScanType scanType;
  final Function(String) onScanned;
  final String? appBarTitle;
  final bool? centerTitle;
  final Widget? loadingWidget;
  var isScanned = false.obs;

  BarcodeScannerRevamped({
    Key? key,
    required this.lineColor,
    required this.cancelButtonText,
    required this.isShowFlashIcon,
    required this.scanType,
    required this.onScanned,
    this.appBarTitle,
    this.centerTitle,
    this.loadingWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isWindows) {
      ///Get Window barcode Scanner UI
      return WindowBarcodeScanner(
        lineColor: lineColor,
        cancelButtonText: cancelButtonText,
        isShowFlashIcon: isShowFlashIcon,
        scanType: scanType,
        onScanned: onScanned,
        appBarTitle: appBarTitle,
        centerTitle: centerTitle,
      );
    } else {
      /// Scan Android and ios barcode scanner with flutter_barcode_scanner
      _scanBarcodeForMobileAndTabDevices();
      return Scaffold(
        body: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Center(child: CircularProgressIndicator()),
              if (isScanned.value) ...[
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    loadingWidget ??
                        Text(
                          "Please wait...",
                          style: TextStyle(fontSize: 16),
                        ),
                  ],
                ),
              ],
              Spacer(),
            ],
          );
        }),
      );
    }
  }

  _scanBarcodeForMobileAndTabDevices() async {
    /// Scan barcode for mobile devices
    ScanMode scanMode;
    switch (scanType) {
      case ScanType.barcode:
        scanMode = ScanMode.BARCODE;
        break;
      case ScanType.qr:
        scanMode = ScanMode.QR;
        break;
      default:
        scanMode = ScanMode.DEFAULT;
        break;
    }
    String barcode = await FlutterBarcodeScanner.scanBarcode(
        lineColor, cancelButtonText, isShowFlashIcon, scanMode);
    isScanned.value = true;
    onScanned(barcode);
  }
}
