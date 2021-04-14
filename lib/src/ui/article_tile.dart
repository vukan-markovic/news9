import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class ArticleTile extends StatelessWidget {
  final String author,
      title,
      description,
      postUrl,
      imgUrl,
      publishedAt,
      content;

  ArticleTile({
    this.author,
    this.title,
    this.description,
    this.postUrl,
    this.imgUrl,
    this.publishedAt,
    this.content,
  });

  formatDate(String date) {
    return Jiffy(date).fromNow();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
                      formatDate(publishedAt),
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
                      imgUrl,
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object exception,
                        StackTrace stackTrace) {
                      return Image.asset('assets/placeholder.png');
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  title,
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
    );
  }
}
