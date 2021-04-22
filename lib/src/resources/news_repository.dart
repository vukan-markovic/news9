import 'dart:async';
import 'package:hive/hive.dart';
import 'package:news/src/models/source_model.dart';
import 'news_api_provider.dart';
import '../models/article/article_model.dart';

class NewsRepository {
  final newsApiProvider = NewsApiProvider();

  Future<ArticleModel> fetchAllNews(
          {String languageCode,
          String dateFrom,
          String dateTo,
          String country,
          String source,
          String paging,
          String query = ""}) =>
      newsApiProvider.fetchNewsList(
        languageCode: languageCode,
        dateFrom: dateFrom,
        dateTo: dateTo,
        country: country,
        source: source,
        paging: paging,
        query: query,
      );

  fetchAllNewsByCategory({
    String languageCode,
    String country,
    String source,
    String paging,
    String category,
  }) =>
      newsApiProvider.fetchNewsListByCategory(
        languageCode: languageCode,
        country: country,
        paging: paging,
        category: category,
      );

  Future<SourceModel> fetchAllSources() => newsApiProvider.fetchSourcesList();

  fetchNews(String boxName) async {
    var box = await Hive.openBox(boxName);
    return box.values;
  }

  insertNews(boxName, data) async {
    var box = await Hive.openBox(boxName);
    box.add(data);
  }

  insertNewsByUuid(boxName, data, uuid) async {
    var box = await Hive.openBox(boxName);
    box.put(data.title, data);
  }

  //function should call box.clear() but doesn't work
  deleteNewsBox(boxName) async {
    var box = await Hive.openBox(boxName);
    for (int i = 0; i < box.length; i++) {
      box.deleteAt(i);
    }
  }

  deleteNewsByUuid(boxName, uuid) async {
    var box = await Hive.openBox(boxName);
    box.delete(uuid);
  }
}
