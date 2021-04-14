import 'package:firebase_auth/firebase_auth.dart';

class ArticleModel {
  String _status;
  int _totalResults;
  List<Article> _articles = [];

  ArticleModel.fromDatabase(List<Map<String, dynamic>> response) {
    response.forEach((res) {
      articles.add(Article.create(
          res["author"],
          res["title"],
          res["description"],
          res["url"],
          res["urlToImage"],
          res["publishedAt"],
          res["source"]));
    });
  }

  ArticleModel.fromJson(Map<String, dynamic> parsedJson) {
    _status = parsedJson['status'];
    _totalResults = parsedJson['totalResults'];
    List<Article> temp = [];
    int _listLength = parsedJson['articles'].length;

    for (int i = 0; i < _listLength; i++) {
      Article article = Article(parsedJson['articles'][i]);

      temp.add(article);
    }
    _articles = temp;
  }

  String get status => _status;

  int get totalarticles => _totalResults;

  List<Article> get articles => _articles;
}

class Article {
  String _author;
  String _title;
  String _description;
  String _url;
  String _urlToImage;
  String _publishedAt;
  Source _source;

  Article.create(this._author, this._title, this._description, this._url,
      this._urlToImage, this._publishedAt, this._source);

  Article(article) {
    _author = article['author'];
    _title = article['title'];
    _description = article['description'];
    _url = article['url'];
    _urlToImage = article['urlToImage'];
    _publishedAt = article['publishedAt'];
    _source = Source.fromJson(article['source']);
  }

  String get author => _author;

  String get title => _title;

  String get description => _description;

  String get url => _url;

  String get urlToImage => _urlToImage;

  String get publishedAt => _publishedAt;

  String get source => _source.name;

  toMap() {
    var map = Map<String, dynamic>();
    map['author'] = this.author;
    map['title'] = this.title;
    map['description'] = this.description;
    map['url'] = this.url;
    map['urlToImage'] = this.urlToImage;
    map['publishedAt'] = this.publishedAt;
    map['source'] = this.source;
    map['uid'] = FirebaseAuth.instance.currentUser?.uid ??
        "wOJ3BsX5EnNgFAZYvPeGdK3TCVf2"; //adamrumunce@gmail.com uid added for testing purposes
    return map;
  }
}

class Source{
  String id;
  String name;

  Source({this.id, this.name});

  factory Source.fromJson(Map<String, dynamic> parsedJson){
    return Source(
      id: parsedJson['id'],
      name : parsedJson['name'],
    );
  }

}