import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:share/share.dart';

import 'package:news/src/blocs/news_bloc/news_bloc.dart';
import 'package:news/src/models/article/article_model.dart';
import 'package:news/src/constants/ColorConstants.dart';
import 'package:news/src/extensions/Color.dart';
import 'package:news/src/utils/app_localizations.dart';
import 'article_details.dart';

class ArticleTile extends StatefulWidget {
  _ArticleTileState createState() => _ArticleTileState();

  final Article article;
  final String backgroundColor;

  ArticleTile({@required this.article, this.backgroundColor});
}

class _ArticleTileState extends State<ArticleTile> {
  Article article;
  String _placeholderImageUrl =
      'https://iitpkd.ac.in/sites/default/files/default_images/default-news-image_0.png';
  bool isArticleFavorite;

  @override
  void initState() {
    this.article = widget.article;
    this.isArticleFavorite = article.isFavorite ?? false;
    super.initState();
  }

  @override
  void didUpdateWidget(ArticleTile oldWidget) {
    if (article != widget.article) {
      setState(() {
        article = widget.article;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  formatDate(String date) {
    return Jiffy(date).fromNow();
  }

  void _openArticleDetails(BuildContext context, Article article) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ArticleDetails(article)));
  }

  _shareArticle() {
    Share.share(
        "${AppLocalizations.of(context).translate('checkout_article')} \n ${article.url}");
  }

  _saveArticle() {
    newsBloc.insertNewsByUid("favorite_news", article);
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.33,
      child: GestureDetector(
        onTap: () => _openArticleDetails(context, article),
        child: AnimatedContainer(
          alignment: Alignment.topCenter,
          duration: Duration(milliseconds: 800),
          curve: Curves.easeIn,
          child: Stack(children: [
            Card(
              elevation: 3,
              color: widget.backgroundColor != null ? HexColor?.fromHex(widget.backgroundColor) : HexColor.fromHex(ColorConstants.secondaryWhite),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  margin: EdgeInsets.only(bottom: 24),
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(6),
                            bottomLeft: Radius.circular(6))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(article.source.name),
                            Text(
                              formatDate(article.publishedAt),
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            article.urlToImage ?? _placeholderImageUrl,
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace stackTrace) {
                              return Image.asset('assets/placeholder.png');
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          article.title,
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
      secondaryActions: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideAction(
              child: Container(
                height: 60,
                child: Card(
                  color: HexColor.fromHex(ColorConstants.primaryColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context).translate('Save') + " ",
                        style: TextStyle(
                          color:
                              HexColor.fromHex(ColorConstants.secondaryWhite),
                        ),
                      ),
                      isArticleFavorite
                          ? Icon(
                              Icons.bookmark_rounded,
                              color: HexColor.fromHex(
                                  ColorConstants.secondaryWhite),
                            )
                          : Icon(
                              Icons.bookmark_border_rounded,
                              color: HexColor.fromHex(
                                  ColorConstants.secondaryWhite),
                            ),
                    ],
                  ),
                ),
              ),
              onTap: () => _saveArticle(),
            ),
            SizedBox(
              height: 15,
            ),
            SlideAction(
              child: Container(
                height: 60,
                child: Card(
                  color: HexColor.fromHex(ColorConstants.primaryColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context).translate('Share') + " ",
                        style: TextStyle(
                          color:
                              HexColor.fromHex(ColorConstants.secondaryWhite),
                        ),
                      ),
                      Icon(
                        Icons.share_outlined,
                        color: HexColor.fromHex(ColorConstants.secondaryWhite),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () => _shareArticle(),
            ),
          ],
        ),
      ],
    );
  }
}
