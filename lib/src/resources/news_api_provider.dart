import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' show Client;

import '../models/article_model.dart';

class NewsApiProvider {
  Client client = Client();
  static final String _apiKey = 'a7d73c371f074012846400e5bfff3492';
  static final DateTime _currentDate = DateTime.now();
  static final String _formattedDate = DateFormat('yyyy-MM-dd').format(_currentDate);
  static final String _country = 'rs';

  final _testUrl = Uri.https('newsapi.org', '/v2/top-headlines', {'country': _country, 'from': _formattedDate, 'apiKey': _apiKey});

  Future<ArticleModel> fetchNewsList() async {
    final response = await client.get(_testUrl);
    if (response.statusCode == 200) {
      return ArticleModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load news');
    }
  }
}