import 'dart:async';

import 'news_api_provider.dart';
import '../models/article_model.dart';

class NewsRepository {
  final newsApiProvider = NewsApiProvider();

  Future<ArticleModel> fetchAllNews() => newsApiProvider.fetchNewsList();
}