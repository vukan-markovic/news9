import 'package:rxdart/rxdart.dart';
import '../../resources/news_repository.dart';
import '../../models/article_model.dart';

class NewsBloc {
  final _repository = NewsRepository();
  final _newsFetcher = PublishSubject<ArticleModel>();

  Stream<ArticleModel> get allNews => _newsFetcher.stream;

  fetchAllNews() async {
    ArticleModel news = await _repository.fetchAllNews();
    _newsFetcher.sink.add(news);
  }

  dispose() {
    _newsFetcher.close();
  }
}

final newsBloc = NewsBloc();