import 'package:mongo_dart/mongo_dart.dart';

import '../Model/Model.dart';
import '../ProductsList/ProductsListScreen.dart';

class MongoDbHelper {
  static final String _dbName = 'Lakeshore';
  static final String _collectionName = 'Products';
  static final String _uri =
      "mongodb+srv://volutiontechnologies:LPkDM7ZDcR47s05e@cluster0.cfk2b7c.mongodb.net/$_dbName?retryWrites=true&w=majority";
  static Future<Db> getDb() async {
    var db = await Db.create(_uri);
    print('Connecting to database');
    await db.open();
    print('Connected to database');
    return db;
  }

  static Future<List<Map<String, dynamic>>> find(int skip, int pageSize,
      String searchText, String category, String age) async {
    print('searchText: $searchText');
    print('category: $category');
    int? defaultminAge = 0;
    int? defaultmaxAge = 500;
    if (age.isNotEmpty) {
      if (ageRanges[age] != null) {
        defaultminAge = ageRanges[age]!['min'];
        defaultmaxAge = ageRanges[age]!['max'];
      }
    }
    final db = await getDb();

    final result = await db
        .collection(_collectionName) //.match('category', category)
        .find(where
            .gte('minAge', defaultminAge)
            .lte('maxAge', defaultmaxAge)
            .match(
              'productName',
              buildCaseInsensitiveRegExp(searchText.trim()),
              caseInsensitive: true,
            )
            .match('category', category)
            .skip(skip)
            .limit(pageSize))
        .toList();
    await db.close();
    return result;
  }

  static String buildCaseInsensitiveRegExp(String input) {
    String pattern = input.split('').map((char) {
      if (char.toUpperCase() != char.toLowerCase()) {
        return '[${char.toUpperCase()}${char.toLowerCase()}]';
      } else {
        return RegExp.escape(char);
      }
    }).join('');
    return pattern;
  }

  static Future<ProductModel?> getProduct(String barcode) async {
    final db = await getDb();
    final product = await db
        .collection(_collectionName)
        .findOne(where.eq('barcode', barcode));
    await db.close();
    if (product == null) {
      return null;
    }
    return ProductModel.formJson(product);
  }

  static Future<ProductModel?> updateBarcode(
    ObjectId produ,
    String newBarcode,
  ) async {
    final db = await getDb();

    try {
      var product = await db.collection(_collectionName).findOne(
            where.eq('_id', produ),
          );

      if (product != null) {
        // Update the barcode
        product['barcode'] = newBarcode;

        // Save the updated product
        await db.collection(_collectionName).replaceOne(
              where.eq('_id', produ),
              product,
            );
      }

      await db.close();

      if (product == null) {
        print('Product not found with ID: ${produ.toString()}');
        return null;
      }

      return ProductModel.formJson(product);
    } catch (e) {
      print('Error updating barcode: $e');
      await db.close();
      return null;
    }
  }
}
