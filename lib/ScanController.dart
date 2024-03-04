import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Model/Model.dart';

class ScanController extends GetxController {
  final searchText = ''.obs;
  final showunScannedProductOnly = true.obs;
  final isLoading = false.obs;
  final products = <ProductModel>[].obs;

  @override
  void onInit() {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    try {
      // Check if the products are already cached
      List<ProductModel> cachedProducts = await getProductsFromCache();
      if (cachedProducts.isNotEmpty) {
        // If cached products exist, return them
        this.products.value = cachedProducts;
      } else {
        // Otherwise, fetch products from Firestore
        QuerySnapshot querySnapshot =
            await FirebaseFirestore.instance.collection('Products').get();
        List<ProductModel> products = querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return ProductModel(
            id: data['id'],
            category: data['category'],
            productName: data['productName'],
            allProductImageURLs:
                List<String>.from(data['allProductImageURLs'] ?? []),
            recommendedAge: data['recommendedAge'],
            recommendedGrade: data['recommendedGrade'],
            desc: data['desc'],
            additionalInfo: data['additionalInfo'],
            barcode: data['barcode'],
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
          "CREATE TABLE products(id TEXT PRIMARY KEY, category TEXT, productName TEXT, allProductImageURLs TEXT, recommendedAge TEXT, recommendedGrade TEXT, desc TEXT, additionalInfo TEXT, barcode TEXT)",
        );
      },
      version: 1,
    );

    final List<Map<String, dynamic>> maps = await db.query('products');
    print(
      join(await getDatabasesPath(), 'products_database.db'),
    );
    await db.close();
    if (maps.isEmpty) {
      return [];
    }
    return List.generate(maps.length, (i) {
      var images = (maps[i]['allProductImageURLs'] ?? []).split(",");

      return ProductModel(
          id: maps[i]['id'],
          category: maps[i]['category'],
          productName: maps[i]['productName'],
          allProductImageURLs: images,
          recommendedAge: maps[i]['recommendedAge'],
          recommendedGrade: maps[i]['recommendedGrade'],
          desc: maps[i]['desc'],
          additionalInfo: maps[i]['additionalInfo'],
          barcode: maps[i]['barcode']);
    });
  }

// Function to cache products
  Future<void> cacheProducts(List<ProductModel> products) async {
    final Database db = await openDatabase(
      join(await getDatabasesPath(), 'products_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE products(id TEXT PRIMARY KEY, category TEXT, productName TEXT, allProductImageURLs TEXT, recommendedAge TEXT, recommendedGrade TEXT, desc TEXT, additionalInfo TEXT, barcode TEXT)",
        );
      },
      version: 1,
    );
    print(
      join(await getDatabasesPath(), 'products_database.db'),
    );
    for (ProductModel product in products) {
      await db.insert(
        'products',
        product.toJsonForDB(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await db.close();
  }

  List<ProductModel> get filteredItems {
    if (searchText.value.isEmpty) {
      return products.where((item) {
        if (showunScannedProductOnly.value) {
          return item.barcode == null || item.barcode!.isEmpty;
        } else {
          return true;
        }
      }).toList();
    } else {
      return products
          .where((item) {
            return (item.productName ?? "")
                    .toLowerCase()
                    .contains(searchText.value.toLowerCase()) ||
                (item.category ?? "")
                    .toLowerCase()
                    .contains(searchText.value.toLowerCase());
          })
          .toList()
          .where((item) {
            if (showunScannedProductOnly.value) {
              return item.barcode == null || item.barcode!.isEmpty;
            } else {
              return true;
            }
          })
          .toList();
    }
  }

  Future<void> updateBarCode(
      {required String barcode, required String id}) async {
    try {
      CollectionReference products =
          FirebaseFirestore.instance.collection('Products');
      DocumentReference productRef = products.doc(id);
      await productRef.update({'barcode': barcode});
      await updateSQLiteTable(id: id, barcode: barcode);
      await fetchProducts();
    } catch (e) {
      print("Failed to update barcode: $e");
    }
  }

  Future<void> updateSQLiteTable(
      {required String id, required String barcode}) async {
    try {
      // Open the database
      final database = openDatabase(
        join(await getDatabasesPath(), 'products_database.db'),
        onCreate: (db, version) {
          // Run the CREATE TABLE query if the table does not exist
          return db.execute(
            "CREATE TABLE IF NOT EXISTS products(id TEXT PRIMARY KEY, category TEXT, productName TEXT, allProductImageURLs TEXT, recommendedAge TEXT, recommendedGrade TEXT, desc TEXT, additionalInfo TEXT, barcode TEXT)",
          );
        },
        version: 1,
      );

      // Update barcode in SQLite table
      final db = await database;
      await db.rawUpdate(
        'UPDATE products SET barcode = ? WHERE id = ?',
        [barcode, id],
      );

      print("SQLite Table Updated");
    } catch (e) {
      print("Failed to update SQLite table: $e");
    }
  }
}
