import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Model/Model.dart'; // Import GetX package

// Define a controller to manage state
class UploadCSVController extends GetxController {
  var pickedFileURL = Rxn<Uri>();
  var uploadedCount = 0.obs;
  var failedCount = 0.obs;
  var totalRecords = 0.obs;
  var alreadyExist = 0.obs;
  var isLoading = false.obs;

  void selectFile(Uri? fileURL) {
    pickedFileURL.value = fileURL;
  }

  void uploadProductsToFirestore(List<ProductModel> productsList) async {
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
        final productRef = db.collection('Products').doc();
        batch.set(productRef, product.toJson());
        uploadedCount++;
      }
    }

    await batch.commit();

    isLoading.value = false;
  }

  List<ProductModel>? readFileContent(Uri url) {
    List<ProductModel> products = [];
    try {
      // Your CSV parsing logic here
      totalRecords.value = products.length;
      return products;
    } catch (e) {
      print('Error parsing CSV: $e');
      return null;
    }
  }
}