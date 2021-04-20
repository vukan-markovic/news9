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
  static final String _apiKey = 'a041896ae3e446e583455e49070ec8b1';
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
      this.country = 'rs';
    } else {
      this.country = country;
    }
    print('AAAAAAAAAAAAA' + query);
    if (dateFrom.isEmpty && dateTo.isEmpty) {
      _testUrl = Uri.https('newsapi.org', '/v2/top-headlines', {
        if (languageCode != 'sr') 'language': languageCode,
        'pageSize': paging,
        'q': query,
        'apiKey': _apiKey,
        'sources': source.toLowerCase() != 'all' ? source : '',
        'country': country != 'All'
            ? countries.keys.firstWhere((k) => countries[k] == country)
            : '',
      });
    } else {
      _testUrl = Uri.https('newsapi.org', '/v2/everything', {
        if (languageCode != 'sr') 'language': languageCode,
        'from': Jiffy(DateTime.parse(dateFrom)).format('yyyy-MM-dd'),
        'to': Jiffy(DateTime.parse(dateTo)).format('yyyy-MM-dd'),
        'pageSize': paging,
        'q': query,
        'language': languageCode,
        'apiKey': _apiKey,
        'sources': 'bbc-news', //TODO Add new default sources
      });
    }

    final response = await client.get(_testUrl);

    if (response.statusCode == 200) {
      return ArticleModel.fromJson(json.decode(response.body));
    } else {
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
}
