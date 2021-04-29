import 'package:flutter/material.dart';
import 'package:news/src/models/article/article_model.dart';
import 'article_details.dart';
import 'favorite_news_screen.dart';

class MostPopularNews extends StatelessWidget {
  MostPopularNews(this.articles);

  final List<Article> articles;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: articles.length,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            return NewsTile(article: articles[index]);
          }),
    );
  }
}

class NewsTile extends StatefulWidget {
  NewsTile({this.article, this.parent});

  final Article article;
  final FavoriteNewsScreenState parent;

  @override
  _NewsTileState createState() => _NewsTileState();
}

class _NewsTileState extends State<NewsTile> {
  bool isArticleFavorite;
  String _placeholderImageUrl =
      'https://iitpkd.ac.in/sites/default/files/default_images/default-news-image_0.png';

  @override
  void initState() {
    this.isArticleFavorite = widget.article.isFavorite ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        bool isParentFavoriteScreen = widget.parent != null;

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ArticleDetails(
              article: widget.article,
              isFavorite: isArticleFavorite,
              isParentFavoriteScreen: isParentFavoriteScreen,
              callback: (value) {
                setState(() {
                  isArticleFavorite = value;
                });
              }),
        ));
      },
      child: ConstrainedBox(
        constraints: new BoxConstraints(
          minWidth: MediaQuery.of(context).size.width / 2,
        ),
        child: Card(
          child: Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      widget.article.urlToImage ?? _placeholderImageUrl,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width / 2,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace stackTrace) {
                        return Image.asset('assets/placeholder.png');
                      },
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              widget.article.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              widget.article.description.substring(
                                      0,
                                      (widget.article.description.length ~/
                                          3)) +
                                  "...",
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
