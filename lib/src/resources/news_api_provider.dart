import 'dart:async';
import 'dart:convert';
import 'package:jiffy/jiffy.dart';
import 'package:http/http.dart' show Client;
import 'package:news/src/constants/countries.dart';
import 'package:news/src/models/source_model.dart';
import '../models/article/article_model.dart';

class NewsApiProvider {
  Client client = Client();
  String country;
  static final String _apiKey = '4460355a5e504e9db438ca6df6fc1df1';
  Uri _testUrl;

  Future<ArticleModel> fetchNewsList({
    String languageCode,
    String dateFrom,
    String dateTo,
    String country,
    String source,
    String paging,
    String sorting,
    String query = "",
  }) async {
    if (languageCode == 'sr') {
      this.country = 'Serbia';
    } else {
      this.country = country;
    }

    if (dateFrom.isEmpty && dateTo.isEmpty) {
      _testUrl = Uri.https('newsapi.org', '/v2/top-headlines', {
        if (languageCode != 'sr') 'language': languageCode,
        'pageSize': paging,
        'q': query,
        'apiKey': _apiKey,
        'sources': source.toLowerCase() != 'all' ? source : '',
        'country': this.country != 'All'
            ? countries.keys.firstWhere((k) => countries[k] == this.country)
            : '',
      });
    } else {
      _testUrl = Uri.https('newsapi.org', '/v2/everything', {
        if (languageCode != 'sr') 'language': languageCode,
        'from': Jiffy(DateTime.parse(dateFrom)).format('yyyy-MM-dd'),
        'to': Jiffy(DateTime.parse(dateTo)).format('yyyy-MM-dd'),
        'pageSize': paging,
        'q': query.isEmpty ? 'a' : query,
        'language': languageCode,
        'apiKey': _apiKey,
      });
    }

    final response = await client.get(_testUrl);

    if (response.statusCode == 200) {
      return ArticleModel.fromJson(json.decode(response.body));
    } else {
      print(response.body);
      throw Exception('Failed to load news');
    }
  }

  Future<SourceModel> fetchSourcesList() async {
    final _url = Uri.https('newsapi.org', 'v2/sources', {
      'apiKey': _apiKey,
    });

    final response = await client.get(_url);

    if (response.statusCode == 200) {
      return SourceModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load sources');
    }
  }

  Future<ArticleModel> fetchNewsListByCategory({
    String languageCode,
    String country,
    String paging,
    String category,
    String query,
  }) async {
    if (languageCode == 'sr') {
      this.country = 'Serbia';
    } else {
      this.country = country;
    }

    _testUrl = Uri.https('newsapi.org', '/v2/top-headlines', {
      if (languageCode != 'sr') 'language': languageCode,
      'pageSize': paging,
      'q': query,
      'apiKey': _apiKey,
      'category': category,
      'country': this.country != 'All'
          ? countries.keys.firstWhere((k) => countries[k] == this.country)
          : '',
    });

    final response = await client.get(_testUrl);

    if (response.statusCode == 200) {
      return ArticleModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load news');
    }
  }

  Future<ArticleModel> fetchMostPopularNews(
      String languageCode, String country) async {
    _testUrl = Uri.https('newsapi.org', '/v2/everything', {
      if (languageCode != 'sr') 'language': languageCode,
      'apiKey': _apiKey,
      'sortBy': 'popularity',
      'q': 'a',
    });

    final response = await client.get(_testUrl);

    if (response.statusCode == 200) {
      return ArticleModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load most popular news');
    }
  }
}
