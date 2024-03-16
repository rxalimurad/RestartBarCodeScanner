import 'package:mongo_dart/mongo_dart.dart';

import '../LocalDataHandler/LocalDataHandler.dart';
import '../Model/Model.dart';
import '../ProductsList/ProductsListScreen.dart';

enum LoginResponseStatus {
  success,
  alreadyExist,
  error,
  userNotExist,
  passwordNotCorrect,
}

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
    var user = await LocalDataHandler.getUserData();

    try {
      var product = await db.collection(_collectionName).findOne(
            where.eq('_id', produ),
          );

      if (product != null) {
        // Update the barcode
        product['barcode'] = newBarcode;
        product['updatedAt'] = DateTime.now().toIso8601String();
        product['user'] = user?.email ?? '';

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

  static deleteUser(String email) async {
    final db = await getDb();
    await db.collection('Users').deleteOne(where.eq('email', email));
    await db.close();
  }

  static Future<LoginResponseStatus> createrUser(
      String name, String email, String phoneNumber, String password) async {
    try {
      final db = await getDb();
      // Check if user with the same email already exists
      var userExists = await db.collection('Users').findOne({'email': email});
      if (userExists != null) {
        return LoginResponseStatus.alreadyExist; // User already exists
      }

      // If user doesn't exist, create a new user
      await db.collection('Users').insert({
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
        'password': password,
      });

      return LoginResponseStatus.success; // User created successfully
    } catch (e) {
      // Handle any errors
      print('Error creating user: $e');
      return LoginResponseStatus.error; // Error occurred
    }
  }

  static Future<LoginResponseStatus> loginUser(
      String email, String password) async {
    try {
      final db = await getDb();
      final user =
          await db.collection('Users').findOne(where.eq('email', email));
      await db.close();

      if (user == null) {
        return LoginResponseStatus.userNotExist; // User does not exist
      }

      // User exists, but check if the password is correct
      if (user['password'] != password) {
        return LoginResponseStatus
            .passwordNotCorrect; // Password is not correct
      }

      print('User: $user');
      LocalDataHandler.saveUserData(user);
      return LoginResponseStatus.success; // Login successful
    } catch (e) {
      // Handle any errors
      print('Error during login: $e');
      return LoginResponseStatus.error; // Error occurred
    }
  }

  static Future<bool> verifyRecordExistence(
      String email, String phoneNumber) async {
    try {
      final db = await getDb();
      final userWithEmail = await db
          .collection('Users')
          .findOne(where.eq('email', email).eq('phoneNumber', phoneNumber));

      await db.close();

      // Check if a user with the provided email exists
      if (userWithEmail != null) {
        return true;
      }

      // If neither user with email nor user with phone number exists, return false
      return false;
    } catch (e) {
      // Handle any errors
      print('Error verifying record existence: $e');
      return false; // Return false in case of error
    }
  }

  static changePassword(String email, String password) async {
    final db = await getDb();
    final user = await db.collection('Users').findOne(
          where.eq('email', email),
        );
    if (user != null) {
      user['password'] = password;
      await db.collection('Users').replaceOne(
            where.eq('email', email),
            user,
          );
    }
    await db.close();
  }
}
