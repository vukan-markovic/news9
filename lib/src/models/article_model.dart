class ArticleModel {
  String _status;
  int _totalResults;
  List<_Article> _articles = [];

  ArticleModel.fromJson(Map<String, dynamic> parsedJson) {
    _status = parsedJson['status'];
    _totalResults = parsedJson['totalResults'];
    List<_Article> temp = [];
    int _listLength = parsedJson['articles'].length;
    
    for (int i = 0; i < _listLength; i++) {
      _Article article = _Article(parsedJson['articles'][i]);

      temp.add(article);
    }
    _articles = temp;
  }

  String get status => _status;

  int get totalarticles => _totalResults;

  List<_Article> get articles => _articles;
}

class _Article {
  String _author;
  String _title;
  String _description;
  String _url;
  String _urlToImage;
  String _publishedAt;
  String _content;

  _Article(article) {
    _author = article['author'];
    _title = article['title'];
    _description = article['description'];
    _url = article['url'];
    _urlToImage = article['urlToImage'];
    _publishedAt = article['publishedAt'];
    _content = article['content'];
  }

  String get author => _author;

  String get title => _title;

  String get description => _description;

  String get url => _url;

  String get urlToImage => _urlToImage;

  String get publishedAt => _publishedAt;

  String get content => _content;
}
