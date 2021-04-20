import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/src/blocs/advanced_search_bloc/advanced_search_bloc.dart';
import 'package:news/src/blocs/language_bloc/language_bloc.dart';
import 'package:news/src/constants/ColorConstants.dart';
import 'package:news/src/extensions/Color.dart';
import '../blocs/news_bloc/news_bloc.dart';
import '../models/article/article_model.dart';
import 'article_tile.dart';

class GlobalNews extends StatefulWidget {
  @override
  _GlobalNewsState createState() => _GlobalNewsState();
}

class _GlobalNewsState extends State<GlobalNews> {
  @override
  void initState() {
    AdvancedSearchState state =
        BlocProvider.of<AdvancedSearchBloc>(context).state;

    newsBloc.fetchAllNews(
        languageCode:
            BlocProvider.of<LanguageBloc>(context).state.locale.languageCode,
        country: state.country,
        paging: state.paging,
        dateFrom: state.dateFrom,
        dateTo: state.dateTo,
        source: state.source);

    super.initState();
  }

  @override
  void dispose() {
    // uncomment when saving articles offline is implemented? not disposing a bloc could lead to memory leak
    // newsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter News9"),
        backgroundColor: HexColor.fromHex(ColorConstants.primaryColor),
      ),
      body: BlocBuilder<AdvancedSearchBloc, AdvancedSearchState>(
        builder: (context, state) {
          return StreamBuilder(
            stream: newsBloc.allNews,
            builder: (context, AsyncSnapshot<ArticleModel> snapshot) {
              print(snapshot);
              if (snapshot.hasData) {
                print("Global news has data");
                if (snapshot.data.articles.length == 0) {
                  return Center(
                    child: Text('No news for selected criteria!'),
                  );
                } else {
                  return buildList(snapshot);
                }
              } else if (snapshot.hasError) {
                print("Global news error");
                return Text(snapshot.error.toString());
              }

              return Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }

  Widget buildList(AsyncSnapshot<ArticleModel> snapshot) {
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
