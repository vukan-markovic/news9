import 'package:flutter/material.dart';
import 'package:news/src/models/article/article_model.dart';
import '../article_tile.dart';

class GlobalNewsList extends StatelessWidget {
  GlobalNewsList(this.snapshot);

  final AsyncSnapshot<ArticleModel> snapshot;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => ArticleTile(article: snapshot.data.articles[index]),
        childCount: snapshot.data.articles.length,
      ),
    );
  }
}
