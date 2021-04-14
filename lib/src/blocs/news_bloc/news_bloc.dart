import 'package:firebase_auth/firebase_auth.dart';
import 'package:news/src/models/category.dart';
import 'package:rxdart/rxdart.dart';
import '../../resources/news_repository.dart';
import '../../models/article_model.dart';

class NewsBloc {
  final _repository = NewsRepository();
  final _newsFetcher = PublishSubject<ArticleModel>();

  Stream<ArticleModel> get allNews => _newsFetcher.stream;

  Stream<ArticleModel> get favoriteNews => _newsFetcher.stream;

  fetchAllNews() async {
    ArticleModel news = await _repository.fetchAllNews();
    deleteNewsByUid(FirebaseAuth.instance.currentUser?.uid ??
        "wOJ3BsX5EnNgFAZYvPeGdK3TCVf2");
    insertNewsList(news);
    _newsFetcher.sink.add(news);
  }

  fetchFavoriteNewsFromDatabase() async {
    ArticleModel news = await _repository.fetchNews("favorite_news");
    _newsFetcher.sink.add(news);
  }

  fetchNewsFromDatabase() async {
    ArticleModel news = await _repository.fetchNews("offline_news");
    _newsFetcher.sink.add(news);
  }

  insertNewsList(ArticleModel articlesModel) async {
    int counter = 0;
    articlesModel.articles.forEach((element) {
      if (counter > 30) return;
      insertNews("offline_news", element);
      counter++;
    });
  }

  insertFavoriteNews(Article article) async {
    insertNews("favorite_news", article);
  }

  insertNews(table, Article article) async {
    _repository.insertNews(table, article.toMap());
  }

  deleteNewsByUid(String uid) async {
    _repository.deleteNewsByUid(uid);
  }

  dispose() {
    _newsFetcher.close();
  }
}

final newsBloc = NewsBloc();
