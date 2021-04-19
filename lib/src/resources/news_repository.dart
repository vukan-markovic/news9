import 'dart:async';

import 'package:hive/hive.dart';

import 'news_api_provider.dart';
import '../models/article/article_model.dart';

class NewsRepository {
  final newsApiProvider = NewsApiProvider();

  Future<ArticleModel> fetchAllNews(String languageCode) =>
      newsApiProvider.fetchNewsList(languageCode);

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
    box.put('uuid', data);
  }

  //function should call box.clear() but doesn't work
  deleteNewsBox(boxName) async {
    var box = await Hive.openBox(boxName);
    for (int i = 0; i < box.length; i++) {
      box.deleteAt(i);
    }
  }

  deleteNewsByUid(boxName, uuid) async {
    var box = await Hive.openBox(boxName);
    box.delete(uuid);
  }
}
