import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import '../../resources/news_repository.dart';
import '../../models/article/article_model.dart';

class NewsBloc {
  final _repository = NewsRepository();
  final _newsFetcher = PublishSubject<ArticleModel>();
  final _favoriteNewsFetcher = PublishSubject<ArticleModel>();

  Stream<ArticleModel> get allNews => _newsFetcher.stream;

  Stream<ArticleModel> get favoriteNews => _favoriteNewsFetcher.stream;

  fetchAllNews() async {
    ArticleModel news = await _repository.fetchAllNews();
    deleteNewsBox("offline_news");
    insertNewsList(news);
    _newsFetcher.sink.add(news);
  }

  fetchFavoriteNewsFromDatabase() async {
    var news = await _repository.fetchNews("favorite_news");
    ArticleModel articles = ArticleModel();
    news.forEach((i) {
      articles.articles.add(Article.create(
          i.author as String,
          i.title as String,
          i.description as String,
          i.url as String,
          i.urlToImage as String,
          i.publishedAt as String,
          Source(id: i.source?.id as String, name: i.source?.name as String),
          i.uuid as String));
    });
    _favoriteNewsFetcher.sink.add(articles);
  }

  fetchNewsFromDatabase() async {
    ArticleModel news = await _repository.fetchNews("offline_news");
    _favoriteNewsFetcher.sink.add(news);
  }

  insertNewsList(ArticleModel articlesModel) {
    int counter = 0;
    articlesModel.articles.forEach((element) {
      if (counter > 30) return;
      insertNews("offline_news", element);
      counter++;
    });
  }

  insertNewsByUid(boxName, article) {
    Uuid uuid = Uuid();
    article.uuid = uuid.v4();
    _repository.insertNewsByUuid(boxName, article, uuid);
  }

  insertNews(boxName, Article article) {
    _repository.insertNews(boxName, article);
  }

  deleteNewsBox(boxName) {
    _repository.deleteNewsBox(boxName);
  }

  deleteNewsByUuid(String uuid) {
    _repository.deleteNewsByUuid('favorite_news', uuid);
  }

  dispose() {
    _newsFetcher.close();
    _favoriteNewsFetcher.close();
  }
}

final newsBloc = NewsBloc();
