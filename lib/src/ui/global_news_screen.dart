import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/src/blocs/connectivity_bloc/connectivity_bloc.dart';
import 'package:news/src/blocs/language_bloc/language_bloc.dart';
import 'package:news/src/constants/ColorConstants.dart';
import 'package:news/src/extensions/Color.dart';
import 'package:provider/provider.dart';
import 'package:news/src/blocs/advanced_search_bloc/advanced_search_bloc.dart';
import 'package:news/src/blocs/language_bloc/language_bloc.dart';
import 'package:news/src/ui/news_list.dart';
import 'package:news/src/ui/search/search_app_bar.dart';
import 'package:news/src/utils/app_localizations.dart';
import '../blocs/news_bloc/news_bloc.dart';
import '../models/article/article_model.dart';

class GlobalNews extends StatefulWidget {
  @override
  _GlobalNewsState createState() => _GlobalNewsState();
}

class _GlobalNewsState extends State<GlobalNews> {
  var activeStream;

  final TextEditingController _filter = new TextEditingController();
  Widget _appBarTitle = new Text('Flutter News9');
  AdvancedSearchState state;

  @override
  void initState() {
    state = BlocProvider.of<AdvancedSearchBloc>(context).state;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    var connectionState = Provider.of<ConnectivityStatus>(context);
    print(connectionState);
    if (connectionState == ConnectivityStatus.Offline) {
      newsBloc.fetchNewsFromDatabase();
      activeStream = newsBloc.offlineNews;
      this._appBarTitle = Text("Flutter News9 - Offline");
      print("showing news From db");
    } else if (connectionState == ConnectivityStatus.Cellular ||
        connectionState == ConnectivityStatus.WiFi) {
      newsBloc.fetchAllNews(
          languageCode:
              BlocProvider.of<LanguageBloc>(context).state.locale.languageCode,
          country: state.country,
          paging: state.paging,
          dateFrom: state.dateFrom,
          dateTo: state.dateTo,
          source: state.source);
      activeStream = newsBloc.allNews;
      this._appBarTitle = Text("Flutter News9");
      print("showing news From api");
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // uncomment when saving articles offline is implemented? not disposing a bloc could lead to memory leak
    // newsBloc.dispose();
    super.dispose();
  }

  searchNews() {
    var connectionState = Provider.of<ConnectivityStatus>(context, listen: false);
    if (connectionState == ConnectivityStatus.Offline) {
      newsBloc.fetchNewsFromDatabase(keyword: _filter.text);
    } else if (connectionState == ConnectivityStatus.Cellular ||
        connectionState == ConnectivityStatus.WiFi) {
      newsBloc.fetchAllNews(
          languageCode:
              BlocProvider.of<LanguageBloc>(context).state.locale.languageCode,
          country: state.country,
          paging: state.paging,
          dateFrom: state.dateFrom,
          dateTo: state.dateTo,
          source: state.source,
          query: _filter.text);
      _closeInputField();
    }
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
      appBar: SearchAppBar(_filter, searchNews),
      body: BlocBuilder<AdvancedSearchBloc, AdvancedSearchState>(
        builder: (context, state) {
          return StreamBuilder(
            stream: this.activeStream,
            builder: (context, AsyncSnapshot<ArticleModel> snapshot) {
              print(snapshot);
              if (snapshot.hasData) {
                print("Global news has data");
                if (snapshot.data.articles.length == 0) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context).translate('no_news'),
                    ),
                  );
                } else {
                  return NewsList(snapshot);
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
}
