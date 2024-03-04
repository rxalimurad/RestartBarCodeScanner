import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:simple_barcode_scanner/enum.dart';
import 'package:simple_barcode_scanner/screens/io_device.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import 'ProductView.dart';
import 'ScanController.dart';

class ScanScreen extends StatelessWidget {
  final ScanController _scanController = Get.put(ScanController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan Barcodes"),
        actions: [
          IconButton(
            onPressed: () {
              _scanController.isFiltering.value = !_scanController.isFiltering.value;
            },
            icon: Icon(_scanController.isFiltering.value ? Icons.visibility : Icons.visibility_off),
          ),
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
              Obx(() => Text("Total items: ${_scanController.products.length}")),
              Obx(() => Text("Scanned items: ${_scanController.products.length}")),
            ],
          ),
          SizedBox(height: 16.0),
          Obx(
                () => _scanController.isLoading.value
                ? CircularProgressIndicator()
                : Expanded(
              child: ListView.builder(
                itemCount: _scanController.filteredItems.length,
                itemBuilder: (context, index) {
                  final item = _scanController.filteredItems[index];
                  return ListTile(
                    onTap: () async {
                      showModalBottomSheet(context: context, builder: (BuildContext context) {
                        return BarcodeScanner(
                          lineColor: "#ff6666",
                          cancelButtonText: "Cancel",
                          isShowFlashIcon: true,
                          scanType: ScanType.barcode,
                          appBarTitle: "Scan Barcode",
                          centerTitle: true,
                          onScanned: (res) {
                            print(res);
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