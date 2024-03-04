import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'Model/Model.dart'; // Import GetX package

// Define a controller to manage state
class UploadCSVController extends GetxController {
  var pickedFileURL = "".obs;
  var uploadedCount = 0.obs;
  var failedCount = 0.obs;
  var totalRecords = 0.obs;
  var alreadyExist = 0.obs;
  var isLoading = false.obs;

  void selectFile(String fileURL) {
    pickedFileURL.value = fileURL;
  }

  void uploadProductsToFirestore(List<ProductModel> productsList) async {
    print("Uploading products to Firestore");
    print(productsList.length);
    totalRecords.value = productsList.length;
    print(productsList.first.id);
    print(productsList.first.category);
    print(productsList.first.productName);
    print(productsList.first.allProductImageURLs);
    print(productsList.first.desc);
    print(productsList.first.additionalInfo);
    isLoading.value = true;
    uploadedCount.value = 0;
    alreadyExist.value = 0;
    failedCount.value = 0;

    final db = FirebaseFirestore.instance;
    WriteBatch batch = db.batch();

    for (var product in productsList) {
      final snapshot = await db
          .collection('Products')
          .where('productName', isEqualTo: product.productName)
          .where('category', isEqualTo: product.category)
          .get();

      if (snapshot.docs.isNotEmpty) {
        alreadyExist++;
      } else {
        final productRef = db.collection('Products').doc(product.id);

        batch.set(productRef, product.toJson());
        uploadedCount++;
      }
    }
    try {
      await batch.commit();
      print("Batch updated successfully.");
    } catch (e) {
      print(e);
    }
    isLoading.value = false;
  }

  Future<List<ProductModel>?> readFileContent(String? url) async {
    if (url == null) {
      return null;
    }

    try {
      String csvString = await rootBundle.loadString(url);
      List<List<dynamic>> csvTable = CsvToListConverter().convert(csvString);
      List<ProductModel> products = [];
      var idx = 0;
      print(csvTable.length);
      for (var row in csvTable) {
        if (row.length == 6) {
          String category = row[0];
          String name = row[1];
          String desc = row[4];
          String additionalInfo = row[5];
          List<String> imageURLs = [];
          if (row[2] != null) {
            String imgURL = row[2];
            List<String> arrURL = imgURL.split(",");
            for (var url in arrURL) {
              imageURLs.add(url.trim());
            }
          }
          String? recommendedAge;
          String? recommendedGrade;
          if (row[3] != null && row[3]!.isNotEmpty) {
            String raAge = row[3]!;
            List<String> arrURL = raAge.split("/");
            recommendedAge = arrURL[0].trim();
            if (arrURL.length > 1) {
              recommendedGrade = arrURL[1].trim();
            }
          }
          products.add(ProductModel(
              id: "$idx",
              category: category,
              productName: name,
              allProductImageURLs: imageURLs,
              recommendedAge: recommendedAge,
              recommendedGrade: recommendedGrade,
              desc: desc,
              additionalInfo: additionalInfo,
              barcode: null));
          idx++;
        }
      }

      // Update totalRecords.value if totalRecords is a variable accessible here

      return products;
    } catch (e) {
      print('Error parsing CSV: $e');
      return null;
    }
  }
}
