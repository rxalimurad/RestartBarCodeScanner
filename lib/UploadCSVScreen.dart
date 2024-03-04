import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restart_scanner/Constants.dart';

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
            SizedBox(
              height: 20,
            ),
            Obx(() {
              if (controller.pickedFileURL.value.isNotEmpty) {
                return Text(
                    "Selected File: ${controller.pickedFileURL.value.split("/").last}");
              } else {
                return Text("No file selected");
              }
            }),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(primaryColor),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              onPressed: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();

                if (result?.files.single.path != null) {
                  controller.selectFile(result!.files.single.path!);
                } else {
                  // User canceled the picker
                }
              },
              child: Text("Select File"),
            ),
            Obx(() {
              if (controller.pickedFileURL.isNotEmpty) {
                return ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(primaryColor),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: () async {
                    // Upload to server
                    // Read file content and upload products
                    final pickedFileURL = controller.pickedFileURL.value;
                    if (pickedFileURL.isNotEmpty) {
                      final products =
                          await controller.readFileContent(pickedFileURL);
                      if (products != null) {
                        controller.uploadProductsToFirestore(
                            products.sublist(1, products.length - 1));
                      }
                    }
                  },
                  child: Obx(() {
                    return !controller.isLoading.value
                        ? Text("Upload to Server")
                        : CircularProgressIndicator();
                  }),
                );
              } else {
                return SizedBox();
              }
            }),
            Spacer(),
            Obx(() {
              if (controller.totalRecords.value != 0) {
                return Column(
                  children: [
                    _buildDataRow(
                        "Total Records", controller.totalRecords.value),
                    _buildDataRow("Processed", controller.uploadedCount.value),
                    _buildDataRow(
                        "Already Exist", controller.alreadyExist.value),
                    _buildDataRow("Failed", controller.failedCount.value),
                  ],
                );
              } else {
                return SizedBox();
              }
            }),
            Spacer(),
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
