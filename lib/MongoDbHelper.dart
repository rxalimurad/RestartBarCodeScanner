import 'package:mongo_dart/mongo_dart.dart';

class MongoDbHelper {
  static final String _dbName = 'Lakeshore';
  static final String _collectionName = 'Products';
  static final String _uri =
      "mongodb+srv://volutiontechnologies:LPkDM7ZDcR47s05e@cluster0.cfk2b7c.mongodb.net/$_dbName?retryWrites=true&w=majority";
  static Future<Db> getDb() async {
    var db = await Db.create(_uri);

    await db.open();
    return db;
  }

  static Future<List<Map<String, dynamic>>> find(
      int skip, int pageSize, String searchText) async {
    final db = await getDb();
    final result = await db
        .collection(_collectionName)
        .find(where.match('productName', searchText).skip(skip).limit(pageSize))
        .toList();
    await db.close();
    return result;
  }
}
