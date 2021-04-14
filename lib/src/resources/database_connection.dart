import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseConnection {
  setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = directory.path + 'db_news9';
    var database =
        await openDatabase(path, version: 1, onCreate: _onCreateDatabase);
    return database;
  }

  _onCreateDatabase(Database database, int version) async {
    // await database.execute(
    //     "CREATE TABLE user(id TEXT, email TEXT, emailVerified INTEGER, firstName TEXT, lastName TEXT, dateOfBirth TEXT, gender TEXT");
    await database.execute(
        "CREATE TABLE selected_category(id INTEGER PRIMARY KEY, title TEXT, uid TEXT)");
  }
}
