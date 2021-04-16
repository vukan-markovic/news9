import 'package:flutter/material.dart';
import 'package:news/src/models/article/article_model.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter_social_content_share/flutter_social_content_share.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_share/social_share.dart';

class ArticleDetails extends StatelessWidget {
  final Article _article;
  final String _placeholderImageUrl =
      'https://iitpkd.ac.in/sites/default/files/default_images/default-news-image_0.png';

  ArticleDetails(this._article);

  formatDate(String date) {
    return Jiffy(date).fromNow();
  }

  _shareFacebook(String url) async {
    FlutterSocialContentShare.share(
      type: ShareType.facebookWithoutImage,
      url: url,
      quote: "Check out this news article",
    );
  }

  _shareTwitter(String url) async {
    SocialShare.shareTwitter(
      "Check out this news article",
      url: _article.url,
      hashtags: ["levi9", "flutter", "internship", "news9"],
    );
  }

  _shareWhatsapp(String url) async {
    SocialShare.shareWhatsapp(
      "Check out this news article: \n $url",
    );
  }

  _shareEmail(String url) async {
    FlutterSocialContentShare.shareOnEmail(
      recipients: [],
      subject: "Check out this news article",
      body: url,
      isHTML: true,
    );
  }

  _shareSms(String url) async {
    SocialShare.shareSms(
      "Check out this news article: \n",
      url: url,
      trailingText: '',
    );
  }

  _copyToClipboard(context, String url) async {
    SocialShare.copyToClipboard("Check out this news article: \n $url");
  }

  Future<void> _launchInWebViewWithJavaScript(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(height: 10),
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
                      icon: Icon(FontAwesomeIcons.facebook),
                      onPressed: () => _shareFacebook(_article.url),
                    ),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.twitter),
                      onPressed: () => _shareTwitter(_article.url),
                    ),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.whatsapp),
                      onPressed: () => _shareWhatsapp(_article.url),
                    ),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.sms),
                      onPressed: () => _shareSms(_article.url),
                    ),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.envelope),
                      onPressed: () => _shareEmail(_article.url),
                    ),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.clipboard),
                      onPressed: () => _copyToClipboard(context, _article.url),
                    ),
                  ],
                ),
                SizedBox(height: 10),
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
                OutlinedButton(
                  onPressed: () =>
                      _launchInWebViewWithJavaScript(_article.url),
                  child: Text(
                    'Open the whole article',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}