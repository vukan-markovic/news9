import 'package:flutter/material.dart';
import 'package:news/src/constants/ColorConstants.dart';
import 'package:news/src/extensions/Color.dart';
import 'package:news/src/models/article/article_model.dart';
import 'package:news/src/utils/app_localizations.dart';
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

  _shareFacebook(context, String url) async {
    FlutterSocialContentShare.share(
      type: ShareType.facebookWithoutImage,
      url: url,
      quote: AppLocalizations.of(context).translate('checkout_article'),
    );
  }

  _shareTwitter(context, String url) async {
    SocialShare.shareTwitter(
      AppLocalizations.of(context).translate('checkout_article'),
      url: _article.url,
      hashtags: ["levi9", "flutter", "internship", "news9"],
    );
  }

  _shareWhatsapp(context, String url) async {
    SocialShare.shareWhatsapp(
      AppLocalizations.of(context).translate('checkout_article') + ": \n $url",
    );
  }

  _shareEmail(context, String url) async {
    FlutterSocialContentShare.shareOnEmail(
      recipients: [],
      subject: AppLocalizations.of(context).translate('checkout_article'),
      body: url,
      isHTML: true,
    );
  }

  _shareSms(context, String url) async {
    SocialShare.shareSms(
      AppLocalizations.of(context).translate('checkout_article') + ": \n",
      url: url,
      trailingText: '',
    );
  }

  _copyToClipboard(context, String url) async {
    SocialShare.copyToClipboard(
        AppLocalizations.of(context).translate('checkout_article') +
            ": \n $url");
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
      appBar: AppBar(
        title: Text('Flutter News9 - ' + _article.source.name),
        backgroundColor: HexColor.fromHex(ColorConstants.primaryColor),
      ),
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
                      text: _article.source.name ??
                          AppLocalizations.of(context)
                              .translate('source_not_stated'),
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    TextSpan(text: ' | '),
                    TextSpan(
                      text:
                          AppLocalizations.of(context).translate('published') +
                              ' ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: formatDate(_article.publishedAt))
                  ]),
                ),
                SizedBox(height: 10),
                Text(
                  _article.title ??
                      AppLocalizations.of(context).translate('no_title'),
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  _article.description ??
                      AppLocalizations.of(context).translate('no_description'),
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
                      text: _article.author ??
                          AppLocalizations.of(context)
                              .translate('author_not_stated'),
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
                      onPressed: () => _shareFacebook(context, _article.url),
                    ),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.twitter),
                      onPressed: () => _shareTwitter(context, _article.url),
                    ),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.whatsapp),
                      onPressed: () => _shareWhatsapp(context, _article.url),
                    ),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.sms),
                      onPressed: () => _shareSms(context, _article.url),
                    ),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.envelope),
                      onPressed: () => _shareEmail(context, _article.url),
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
                  onPressed: () => _launchInWebViewWithJavaScript(_article.url),
                  child: Text(
                    AppLocalizations.of(context).translate('whole_article'),
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
