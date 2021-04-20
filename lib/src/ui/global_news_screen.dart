import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final TextEditingController _filter = new TextEditingController();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Flutter News9');

  @override
  void initState() {
    newsBloc.fetchAllNews(
        BlocProvider.of<LanguageBloc>(context).state.locale.languageCode);
    super.initState();
  }

  @override
  void dispose() {
    // uncomment when saving articles offline is implemented? not disposing a bloc could lead to memory leak
    // newsBloc.dispose();
    super.dispose();
  }

  searchNews() {
    newsBloc.fetchAllNews(
        BlocProvider.of<LanguageBloc>(context).state.locale.languageCode,
        _filter.text);
    _closeInputField();
  }

  void _searchPressed() {
    if (this._searchIcon.icon == Icons.search) {
      setState(() {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = _createInputField();
      });
    } else {
      _closeInputField();
    }
  }

  Widget _createInputField() {
    return new TextField(
      controller: _filter,
      autofocus: true,
      style: TextStyle(
        color: HexColor.fromHex(ColorConstants.secondaryWhite),
      ),
      cursorColor: HexColor.fromHex(ColorConstants.secondaryWhite),
      decoration: new InputDecoration(
        prefixIcon: new Icon(
          Icons.search,
          color: HexColor.fromHex(ColorConstants.secondaryWhite),
        ),
        hintText: 'Search...',
        hintStyle:
            TextStyle(color: HexColor.fromHex(ColorConstants.silverGray)),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: HexColor.fromHex(ColorConstants.secondaryWhite),
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: HexColor.fromHex(ColorConstants.secondaryWhite),
          ),
        ),
      ),
      onSubmitted: (_) => searchNews(),
    );
  }

  void _closeInputField() {
    setState(() {
      this._searchIcon = new Icon(Icons.search);
      this._appBarTitle = new Text('Flutter News9');
      _filter.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle,
        backgroundColor: HexColor.fromHex(ColorConstants.primaryColor),
        actions: <Widget>[
          IconButton(
            icon: _searchIcon,
            onPressed: () => _searchPressed(),
          )
        ],
      ),
      body: StreamBuilder(
        stream: newsBloc.allNews,
        builder: (context, AsyncSnapshot<ArticleModel> snapshot) {
          if (snapshot.hasData) {
            print("Global news has data");
            return buildList(snapshot);
          } else if (snapshot.hasError) {
            print("Global news error");
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
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
