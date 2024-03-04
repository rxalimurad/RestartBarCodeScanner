import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

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
                    onTap: () {
                      _scanController.isPresentingScanner.value = true;
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