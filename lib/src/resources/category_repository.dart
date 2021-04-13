import 'package:news/src/resources/database_connection.dart';
import 'package:sqflite/sqflite.dart';

class CategoryRepository {
  DatabaseConnection _databaseConnection;

  CategoryRepository() {
    _databaseConnection = DatabaseConnection();
  }

  static Database _database;

  Future<Database> get database async {
    if (_database != null)
      return _database;
    else {
      _database = await _databaseConnection.setDatabase();
      return database;
    }
  }

  insertCategory(table, data) async {
    var connection = await database;
    return await connection.insert(table, data);
  }

  deleteCategoriesByUid(uid) async {
    var connection = await database;
    return await connection.rawDelete("DELETE FROM selected_category WHERE uid =?", [uid]);
  }

  getAllCategories(table) async {
    var connection = await database;
    return await connection.query(table);
  }
}
