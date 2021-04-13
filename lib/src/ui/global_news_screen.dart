import 'package:flutter/material.dart';

import '../blocs/news_bloc/news_bloc.dart';
import '../models/article_model.dart';
import 'article_tile.dart';

class GlobalNews extends StatefulWidget {
  @override
  _GlobalNewsState createState() => _GlobalNewsState();
}

class _GlobalNewsState extends State<GlobalNews> {
  @override
  void initState() {
    newsBloc.fetchAllNews();
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
        if (snapshot.hasData) {
          return buildList(snapshot);
        } else if (snapshot.hasError) {
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
            return ArticleTile(
              title: snapshot.data.articles[index].title ?? "",
              publishedAt: snapshot.data.articles[index].publishedAt ?? "",
              imgUrl: snapshot.data.articles[index].urlToImage ?? "",
              postUrl: snapshot.data.articles[index].url ?? "",
            );
          }),
    );
  }
}
