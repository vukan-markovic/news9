import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    // find a way to implement date from now e.g. 5 minutes ago, 3 days ago
    final DateTime _dateToFormat = DateTime.parse(date);
    final String _formattedDate =
        DateFormat('dd. MMMM yyyy.').format(_dateToFormat);

    return _formattedDate;
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
                    Text(formatDate(publishedAt)),
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
                    )),
                SizedBox(
                  height: 10,
                ),
                Text(
                  title,
                  maxLines: 2,
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
