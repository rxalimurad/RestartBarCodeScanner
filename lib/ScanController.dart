import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'Model/Model.dart';

class ScanController extends GetxController {
  final searchText = ''.obs;
  final isFiltering = true.obs;
  final isLoading = false.obs;
  final products = <ProductModel>[].obs;

  @override
  void onInit() {
    fetchProducts();
  }


  void fetchProducts() async {
    isLoading.value = true;

    try {
      // Check if the products are already cached
      List<ProductModel> cachedProducts = await getProductsFromCache();
      if (cachedProducts.isNotEmpty) {
        // If cached products exist, return them
        this.products.value = cachedProducts;
      } else {
        // Otherwise, fetch products from Firestore
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Products').get();
        List<ProductModel> products = querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return ProductModel(
            id: doc.id,
            category: data['category'],
            productName: data['productName'],
            allProductImageURLs: List<String>.from(data['allProductImageURLs']),
            recommendedAge: data['recommendedAge'],
            recommendedGrade: data['recommendedGrade'],
            desc: data['desc'],
            additionalInfo: data['additionalInfo'],
          );
        }).toList();

        // Cache the fetched products
        await cacheProducts(products);

        // Set the fetched products to the value
        this.products.value = products;
      }
    } catch (error) {
      print('Error fetching products: $error');
    }

    isLoading.value = false;
  }

// Function to retrieve products from cache
  Future<List<ProductModel>> getProductsFromCache() async {
    final Database db = await openDatabase(
      join(await getDatabasesPath(), 'products_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE products(id TEXT PRIMARY KEY, category TEXT, productName TEXT, allProductImageURLs TEXT, recommendedAge TEXT, recommendedGrade TEXT, desc TEXT, additionalInfo TEXT)",
        );
      },
      version: 1,
    );

    final List<Map<String, dynamic>> maps = await db.query('products');

    await db.close();
    print("images ${maps[0]['category']}");
    return List.generate(maps.length, (i) {
      var images = maps[i]['allProductImageURLs'].map((ele) => "${ele}").toList();

      return ProductModel(
        id: maps[i]['id'],
        category: maps[i]['category'],
        productName: maps[i]['productName'],
        allProductImageURLs: List<String>.from(images),
        recommendedAge: maps[i]['recommendedAge'],
        recommendedGrade: maps[i]['recommendedGrade'],
        desc: maps[i]['desc'],
        additionalInfo: maps[i]['additionalInfo'],
      );
    });
  }

// Function to cache products
  Future<void> cacheProducts(List<ProductModel> products) async {
    final Database db = await openDatabase(
      join(await getDatabasesPath(), 'products_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE products(id TEXT PRIMARY KEY, category TEXT, productName TEXT, allProductImageURLs TEXT, recommendedAge TEXT, recommendedGrade TEXT, desc TEXT, additionalInfo TEXT)",
        );
      },
      version: 1,
    );

    for (ProductModel product in products) {
      await db.insert(
        'products',
        product.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await db.close();
  }


  List<ProductModel> get filteredItems {
    if (searchText.value.isEmpty) {
      return products;
    } else {
      return products.where((item) {
        return (item.productName ?? "").toLowerCase().contains(searchText.value.toLowerCase()) ||
            (item.category ?? "").toLowerCase().contains(searchText.value.toLowerCase());
      }).toList();
    }
  }
}