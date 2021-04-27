import 'package:news/src/models/source_model.dart';
import 'package:rxdart/rxdart.dart';
import '../../resources/news_repository.dart';
import '../../models/article/article_model.dart';

class NewsBloc {
  final _repository = NewsRepository();
  final _newsFetcher = PublishSubject<ArticleModel>();
  final _newsFetcherByCategory = PublishSubject<ArticleModel>();
  final _sourcesFetcher = PublishSubject<SourceModel>();
  final _favoriteNewsFetcher = PublishSubject<ArticleModel>();
  final _offlineNewsFetcher = PublishSubject<ArticleModel>();

  Stream<ArticleModel> get allNews => _newsFetcher.stream;

  Stream<ArticleModel> get allNewsByCategory => _newsFetcherByCategory.stream;

  Stream<ArticleModel> get favoriteNews => _favoriteNewsFetcher.stream;

  Stream<ArticleModel> get offlineNews => _offlineNewsFetcher.stream;

  Stream<SourceModel> get allSources => _sourcesFetcher.stream;

  fetchAllNews({
    String languageCode,
    String dateFrom,
    String dateTo,
    String country,
    String source,
    String paging,
    String query = "",
  }) async {
    ArticleModel news = await _repository.fetchAllNews(
        languageCode: languageCode,
        dateFrom: dateFrom,
        dateTo: dateTo,
        country: country,
        source: source,
        paging: paging,
        query: query);

    deleteNewsBox("offline_news");
    insertNewsList(news);
    _newsFetcher.sink.add(news);
  }

  Future<void> fetchAllNewsByCategory({
    String languageCode,
    String country,
    String paging,
    String category,
    String query = "",
  }) async {
    ArticleModel news = await _repository.fetchAllNewsByCategory(
      languageCode: languageCode,
      country: country,
      paging: paging,
      category: category,
      query: query,
    );

    _newsFetcherByCategory.sink.add(news);
  }

  fetchAllSources() async {
    SourceModel sources = await _repository.fetchAllSources();
    _sourcesFetcher.sink.add(sources);
  }

  fetchFavoriteNewsFromDatabase() async {
    var news = await _repository.fetchNews("favorite_news");
    ArticleModel articles = ArticleModel();
    news.forEach((article) {
      articles.articles.add(mapArticle(article));
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
  Future<void> fetchNewsFromDatabase({String keyword}) async {
    var news = await _repository.fetchNews("offline_news");
    ArticleModel articles = ArticleModel();
    news.forEach((article) {
      if (keyword == null) {
        articles.articles.add(mapArticle(article));
      } else if (article.title.toLowerCase().contains(keyword)) {
        articles.articles.add(mapArticle(article));
      }
    });
    _offlineNewsFetcher.sink.add(articles);
  }

  insertNewsList(ArticleModel articlesModel) {
    int counter = 0;
    articlesModel.articles.forEach((element) {
      if (counter > 30) return;
      insertNews("offline_news", element);
      counter++;
    });
    ;
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

  Article mapArticle(Article article) {
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
    _sourcesFetcher.close();
    _favoriteNewsFetcher.close();
    _newsFetcherByCategory.close();
  }
}

final newsBloc = NewsBloc();
