import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/src/blocs/news_bloc/news_bloc.dart';
import 'package:news/src/constants/ColorConstants.dart';
import 'package:news/src/extensions/Color.dart';
import 'package:news/src/models/article/article_model.dart';

import 'article_tile.dart';
import 'dialogs/filter_news_dialog.dart';

class FavoriteNewsScreen extends StatefulWidget {
  FavoriteNewsScreenState createState() => FavoriteNewsScreenState();
}

class FavoriteNewsScreenState extends State<FavoriteNewsScreen> {
  @override
  void initState() {
    newsBloc.fetchFavoriteNewsFromDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          title: Text("Flutter News9"),
          backgroundColor: HexColor.fromHex(ColorConstants.primaryColor),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.filter_alt),
              onPressed: () async {
                var sortNews = await FilterNewsDialog.showFilterNewsDialog(
                    context, 'favorites');
                if (sortNews) newsBloc.sortFavoritesNews();
              },
            ),
          ],
        ),
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
    snapshot.data.articles.forEach((element) {
      print(element.title);
    });
    print(snapshot.data.articles.length);
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: ListView.builder(
          itemCount: snapshot.data.articles.length,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            return ArticleTile(
                article: snapshot.data.articles[index], parent: this);
          }),
    );
  }

  @override
  void dispose() {
    // newsBloc.dispose();
    super.dispose();
  }
}
