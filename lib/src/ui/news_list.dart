import 'package:flutter/material.dart';
import 'package:news/src/models/article/article_model.dart';

import 'article_tile.dart';

class NewsList extends StatelessWidget {
  NewsList(this.snapshot);

  final AsyncSnapshot<ArticleModel> snapshot;

  @override
  Widget build(BuildContext context) {
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
