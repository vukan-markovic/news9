import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:news/src/blocs/news_bloc/news_bloc.dart';
import 'package:news/src/models/article/article_model.dart';
import 'package:news/src/ui/favorite_news_screen.dart';
import 'article_details.dart';

class ArticleTile extends StatefulWidget {
  _ArticleTileState createState() => _ArticleTileState();

  final Article article;
  FavoriteNewsScreenState parent;

  ArticleTile({this.article, this.parent});
}

class _ArticleTileState extends State<ArticleTile> {
  Article article;
  String _placeholderImageUrl =
      'https://iitpkd.ac.in/sites/default/files/default_images/default-news-image_0.png';

  @override
  void initState() {
    this.article = widget.article;
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openArticleDetails(context, article),
      onLongPress: () {
        newsBloc.insertNewsByUid("favorite_news", article);
      },
      child: AnimatedContainer(
        alignment: Alignment.topCenter,
        duration: Duration(milliseconds: 800),
        curve: Curves.easeIn,
        child: Stack(children: [
          Card(
              elevation: 3,
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
                            Text('Category placeholder'),
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
              )),
        ]),
      ),
    );
  }
}
