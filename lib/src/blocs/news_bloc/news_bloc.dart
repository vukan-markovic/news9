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
      articles.articles.add(mapArticle(i));
    });
    _favoriteNewsFetcher.sink.add(articles);
  }

  Future<List<String>> fetchFavoriteTitles() async {
    var news = await _repository.fetchNews("favorite_news");
    List<String> favoriteTitles = [];
    news.forEach((i) {
      favoriteTitles.add(i.title);
    });
    return favoriteTitles;
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

  insertNewsByUid(boxName, article) async {
    if (!article.isFavorite) {
      print("added to favorites");
      _repository.insertNewsByUuid(boxName, article, article.title);
    } else {
      _repository.deleteNewsByUuid(boxName, article.title);
      print("deleted from favorites");
    }
    fetchFavoriteNewsFromDatabase();
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

  mapArticle(Article article) {
    return Article.create(
        article.author,
        article.title,
        article.description,
        article.url,
        article.urlToImage,
        article.publishedAt,
        Source(id: article.source?.id, name: article.source?.name),
        true);
  }

  Future<bool> isArticleInFavorites(String articleTitle) async {
    List<String> favoriteTitles = await fetchFavoriteTitles();
    if (favoriteTitles.contains(articleTitle)) {
      return true;
    } else
      return false;
  }

  dispose() {
    _newsFetcher.close();
    _favoriteNewsFetcher.close();
  }
}

final newsBloc = NewsBloc();
