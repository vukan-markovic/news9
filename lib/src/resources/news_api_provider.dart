import 'dart:async';
import 'dart:convert';
import 'package:jiffy/jiffy.dart';
import 'package:http/http.dart' show Client;

import '../models/article/article_model.dart';

class NewsApiProvider {
  Client client = Client();
  static final String _apiKey = 'a7d73c371f074012846400e5bfff3492';

  // use current day or given date period from the settings
  static final String _formattedDate =
      Jiffy(DateTime.now()).format('yyyy-MM-dd');

  // static final String _country = 'us';
  static String _searchQuery = '';

  Future<ArticleModel> fetchNewsList(String languageCode) async {
    Uri _testUrl;

    if (languageCode == 'sr') {
      _testUrl = Uri.https('newsapi.org', '/v2/top-headlines', {
        'country': 'rs',
        'from': _formattedDate,
        'q': _searchQuery,
        'apiKey': _apiKey,
      });
    } else {
      _testUrl = Uri.https('newsapi.org', '/v2/top-headlines', {
        'language': languageCode,
        'from': _formattedDate,
        'q': _searchQuery,
        'apiKey': _apiKey,
      });
    }

    final response = await client.get(_testUrl);
    if (response.statusCode == 200) {
      return ArticleModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load news');
    }
  }
}
