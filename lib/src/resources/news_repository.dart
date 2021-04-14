import 'dart:async';

import 'package:news/src/resources/database_connection.dart';
import 'package:sqflite/sqflite.dart';

import 'news_api_provider.dart';
import '../models/article_model.dart';

class NewsRepository {
  final newsApiProvider = NewsApiProvider();
  final _databaseConnection = DatabaseConnection();

  static Database _database;

  Future<Database> get database async {
    if (_database != null)
      return _database;
    else {
      _database = await _databaseConnection.setDatabase();
      return database;
    }
  }

  Future<ArticleModel> fetchAllNews() => newsApiProvider.fetchNewsList();

  Future<ArticleModel> fetchNews(table) async {
    var connection = await database;
    return ArticleModel.fromDatabase(await connection.query(table));
  }

  insertNews(table, data) async {
    var connection = await database;
    return await connection.insert(table, data);
  }

  deleteNewsByUid(String uid) async {
    var connection = await database;
    return await connection
        .rawDelete("DELETE FROM offline_news WHERE uid =?", [uid]);
  }
}
