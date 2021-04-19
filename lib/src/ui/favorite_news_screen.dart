import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/src/blocs/news_bloc/news_bloc.dart';
import 'package:news/src/constants/ColorConstants.dart';
import 'package:news/src/extensions/Color.dart';
import 'package:news/src/models/article/article_model.dart';

import 'article_tile.dart';

class FavoriteNewsScreen extends StatefulWidget {
  _FavoriteNewsScreenState createState() => _FavoriteNewsScreenState();
}

class _FavoriteNewsScreenState extends State<FavoriteNewsScreen> {
  @override
  void initState() {
    newsBloc.fetchFavoriteNewsFromDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter News9"),
        backgroundColor: HexColor.fromHex(ColorConstants.primaryColor),
      ),
      body: Container(
        child: StreamBuilder(
          stream: newsBloc.favoriteNews,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print("i have data");
              return buildList(snapshot);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
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
    // newsBloc.dispose();
    super.dispose();
  }
}
