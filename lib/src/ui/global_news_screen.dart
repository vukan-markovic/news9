import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/src/blocs/language_bloc/language_bloc.dart';

import '../blocs/news_bloc/news_bloc.dart';
import '../models/article/article_model.dart';
import 'article_tile.dart';

class GlobalNews extends StatefulWidget {
  @override
  _GlobalNewsState createState() => _GlobalNewsState();
}

class _GlobalNewsState extends State<GlobalNews> {
  @override
  void initState() {
    newsBloc.fetchAllNews(
        BlocProvider.of<LanguageBloc>(context).state.locale.languageCode);
    super.initState();
  }

  @override
  void dispose() {
    // uncomment when saving articles offline is implemented? not disposing a bloc could lead to memory leak
    // newsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: newsBloc.allNews,
      builder: (context, AsyncSnapshot<ArticleModel> snapshot) {
        print(snapshot);
        if (snapshot.hasData) {
          print("Global news has data");
          return buildList(snapshot);
        } else if (snapshot.hasError) {
          print("Global news error");
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget buildList(AsyncSnapshot<ArticleModel> snapshot) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: ListView.builder(
          itemCount: snapshot.data.articles.length,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            return ArticleTile(article: snapshot.data.articles[index]);
          }),
    );
  }
}
