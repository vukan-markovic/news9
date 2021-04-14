import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/src/blocs/news_bloc/news_bloc.dart';
import 'package:news/src/models/article_model.dart';

import 'article_tile.dart';

class FavoriteNewsScreen extends StatefulWidget {
  _FavoriteNewsScreenState createState() => _FavoriteNewsScreenState();
}

class _FavoriteNewsScreenState extends State<FavoriteNewsScreen> {
  @override
  void initState() {
    newsBloc.fetchNewsFromDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: newsBloc.favoriteNews,
        builder: (context, snapshot) {
          print(snapshot);
          if (snapshot.hasData) {
            print("i have data");
            return buildList(snapshot);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
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

  @override
  void dispose() {
    newsBloc.dispose();
    super.dispose();
  }
}
