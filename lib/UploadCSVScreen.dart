import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'UploadCSVController.dart';

class UploadCSVScreen extends StatelessWidget {
  final UploadCSVController controller = Get.put(UploadCSVController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload CSV'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Select the scrapped CSV file.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            Obx(() {
              if (controller.pickedFileURL.value != null) {
                return Text("Selected File: ${controller.pickedFileURL.value!.path}");
              } else {
                return Text("No file selected");
              }
            }),
            ElevatedButton(
              onPressed: () {
                // Open file picker
              },
              child: Text("Select File"),
            ),
            ElevatedButton(
              onPressed: () {
                // Upload to server
                // Read file content and upload products
                final pickedFileURL = controller.pickedFileURL.value;
                if (pickedFileURL != null) {
                  final products = controller.readFileContent(pickedFileURL);
                  if (products != null) {
                    controller.uploadProductsToFirestore(products);
                  }
                }
              },
              child: Obx(() {
                return !controller.isLoading.value
                    ? Text("Upload to Server")
                    : CircularProgressIndicator();
              }),
            ),
            Spacer(),
            Obx(() {
              if (controller.totalRecords.value != 0) {
                return Column(
                  children: [
                    _buildDataRow("Total Records", controller.totalRecords.value),
                    _buildDataRow("Uploaded", controller.uploadedCount.value),
                    _buildDataRow("Already Exist", controller.alreadyExist.value),
                    _buildDataRow("Failed", controller.failedCount.value),
                  ],
                );
              } else {
                return SizedBox();
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(String title, int value) {
    return Row(
      children: [
        Text(title),
        Spacer(),
        Text(value.toString()),
      ],
    );
  }
}