import 'package:rxdart/rxdart.dart';
import '../../resources/news_repository.dart';
import '../../models/article/article_model.dart';

class NewsBloc {
  final _repository = NewsRepository();
  final _newsFetcher = PublishSubject<ArticleModel>();

  Stream<ArticleModel> get allNews => _newsFetcher.stream;

  Stream<ArticleModel> get favoriteNews => _newsFetcher.stream;

  fetchAllNews(String languageCode) async {
    ArticleModel news = await _repository.fetchAllNews(languageCode);
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
          Source(id: i.source?.id as String, name: i.source?.name as String)));
    });
    print(articles.articles);
    _newsFetcher.sink.add(articles);
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

  insertNews(boxName, Article article) async {
    _repository.insertNews(boxName, article);
  }

  deleteNewsBox(boxName) {
    _repository.deleteNewsBox(boxName);
  }

  deleteNewsByUid(String uid) async {
    _repository.deleteNewsByUid('favorite_news', uid);
  }

  dispose() {
    _newsFetcher.close();
  }
}

final newsBloc = NewsBloc();
