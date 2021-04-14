import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import 'package:news/src/models/article_model.dart';

class ArticleDetails extends StatelessWidget {
  final Article _article;
  final String _placeholderImageUrl =
      'https://iitpkd.ac.in/sites/default/files/default_images/default-news-image_0.png';

  ArticleDetails(this._article);

  formatDate(String date) {
    return Jiffy(date).fromNow();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                children: [
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: _article.source ?? 'Source not stated',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      TextSpan(text: ' | '),
                      TextSpan(
                        text: 'Published ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: formatDate(_article.publishedAt))
                    ]),
                  ),
                  SizedBox(height: 10),
                  Text(
                    _article.title ?? 'No title',
                    style: Theme.of(context).textTheme.headline4,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    _article.description ?? 'No description',
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: 'By ',
                      ),
                      TextSpan(
                        text: _article.author ?? 'Author not stated',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ]),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          icon: Icon(Icons.share_outlined), onPressed: () {}),
                      IconButton(
                          icon: Icon(Icons.share_outlined), onPressed: () {}),
                      IconButton(
                          icon: Icon(Icons.share_outlined), onPressed: () {}),
                      IconButton(
                          icon: Icon(Icons.share_outlined), onPressed: () {}),
                      IconButton(
                          icon: Icon(Icons.share_outlined), onPressed: () {}),
                      IconButton(
                          icon: Icon(Icons.share_outlined), onPressed: () {}),
                    ],
                  ),
                  Image.network(
                    _article.urlToImage ?? _placeholderImageUrl,
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace stackTrace) {
                      return Image.asset('assets/placeholder.png');
                    },
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Link to open in webview',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
