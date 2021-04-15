import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

part 'article_model.g.dart';

class ArticleModel {
  String _status;
  int _totalResults;
  List<Article> _articles = [];

  ArticleModel();

  ArticleModel.fromDatabase(this._articles);

  ArticleModel.fromJson(Map<String, dynamic> parsedJson) {
    _status = parsedJson['status'];
    _totalResults = parsedJson['totalResults'];
    List<Article> temp = [];
    int _listLength = parsedJson['articles'].length;

    for (int i = 0; i < _listLength; i++) {
      Article article = Article.fromJson(parsedJson['articles'][i]);

      temp.add(article);
    }
    _articles = temp;
  }

  String get status => _status;

  int get totalarticles => _totalResults;

  List<Article> get articles => _articles;
}

@HiveType(typeId: 1)
class Article {
  @HiveField(0)
  String _author;

  @HiveField(1)
  String _title;

  @HiveField(2)
  String _description;

  @HiveField(3)
  String _url;

  @HiveField(4)
  String _urlToImage;

  @HiveField(5)
  String _publishedAt;

  @HiveField(6)
  Source _source;

  @HiveField(7)
  String uuid;

  Article();

  Article.create(this._author, this._title, this._description, this._url,
      this._urlToImage, this._publishedAt, this._source);

  Article.fromJson(article) {
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
}

@HiveType(typeId: 2)
class Source {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  Source({this.id, this.name});

  factory Source.fromJson(Map<String, dynamic> parsedJson) {
    return Source(
      id: parsedJson['id'],
      name: parsedJson['name'],
    );
  }
}
