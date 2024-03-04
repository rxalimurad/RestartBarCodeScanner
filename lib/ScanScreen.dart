import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:restart_scanner/Constants.dart';
import 'package:simple_barcode_scanner/enum.dart';
import 'package:simple_barcode_scanner/screens/io_device.dart';

import 'ProductView.dart';
import 'ScanController.dart';

class ScanScreen extends StatelessWidget {
  final ScanController _scanController = Get.put(ScanController());
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan Barcodes"),
        actions: [
          Obx(() {
            return TextButton(
              onPressed: () {
                _scanController.showunScannedProductOnly.value =
                    !_scanController.showunScannedProductOnly.value;
              },
              child: Text(
                  _scanController.showunScannedProductOnly.value
                      ? "Showing unscanned"
                      : "Showing All",
                  style: TextStyle(color: primaryColor)),
            );
          }),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              onChanged: (value) {
                _scanController.searchText.value = value;
              },
              decoration: InputDecoration(
                hintText: "Search",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Obx(() =>
                  Text("Total items: ${_scanController.products.length}")),
              Obx(() => Text(
                  "Scanned items: ${_scanController.products.where((element) => element.barcode != null && element.barcode!.isNotEmpty).length}")),
            ],
          ),
          SizedBox(height: 16.0),
          Obx(
            () => _scanController.isLoading.value
                ? CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _scanController.filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _scanController.filteredItems[index];
                        return ListTile(
                          onTap: () async {
                            double currentPosition =
                                _scrollController.position.pixels;
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return BarcodeScanner(
                                    lineColor: "#ff6666",
                                    cancelButtonText: "Cancel",
                                    isShowFlashIcon: true,
                                    scanType: ScanType.barcode,
                                    appBarTitle: "Scan Barcode",
                                    centerTitle: true,
                                    onScanned: (res) async {
                                      if (res.isEmpty || res == "-1") {
                                        Navigator.pop(context);
                                        return;
                                      }
                                      print("Barcode: $res");
                                      Fluttertoast.showToast(
                                          msg: "Barcode: $res",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 3,
                                          backgroundColor: Colors.black,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                      await _scanController.updateBarCode(
                                          barcode: res, id: item.id);
                                      Navigator.pop(context);
                                      _scrollController.jumpTo(currentPosition);
                                    },
                                  );
                                });
                          },
                          title: ProductView(product: item),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
