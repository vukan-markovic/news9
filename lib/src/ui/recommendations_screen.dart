import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/src/blocs/advanced_search_bloc/advanced_search_bloc.dart';
import 'package:news/src/blocs/category_bloc/category_bloc.dart';
import 'package:news/src/blocs/language_bloc/language_bloc.dart';
import 'package:news/src/blocs/news_bloc/news_bloc.dart';
import 'package:news/src/constants/ColorConstants.dart';
import 'package:news/src/constants/categories.dart';
import 'package:news/src/extensions/Color.dart';
import 'package:news/src/models/article/article_model.dart';
import 'package:news/src/ui/news_list.dart';
import 'package:news/src/ui/search/search_app_bar.dart';
import 'package:news/src/utils/app_localizations.dart';

String _selectedCategory;
AdvancedSearchState state;

class RecommendationsScreen extends StatefulWidget {
  @override
  _RecommendationsScreenState createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  List<String> _selectedCategories = [];
  final TextEditingController _filter = new TextEditingController();

  @override
  void initState() {
    getFromFuture();
    super.initState();
  }

  getFromFuture() async {
    _selectedCategories = await categoryBloc.getAllCategories();
    _selectedCategory = _selectedCategories[0];

    state = BlocProvider.of<AdvancedSearchBloc>(context).state;

    newsBloc.fetchAllNewsByCategory(
      languageCode:
          BlocProvider.of<LanguageBloc>(context).state.locale.languageCode,
      country: state.country,
      paging: state.paging,
      category: _selectedCategory,
    );
  }

  searchNews() {
    newsBloc.fetchAllNewsByCategory(
        languageCode:
            BlocProvider.of<LanguageBloc>(context).state.locale.languageCode,
        country: state.country,
        paging: state.paging,
        category: _selectedCategory,
        query: _filter.text);
  }

  void sortNews() {
    newsBloc.sortRecommendedNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(_filter, searchNews, true, sortNews),
      body: BlocBuilder<AdvancedSearchBloc, AdvancedSearchState>(
        builder: (context, state) {
          return StreamBuilder(
            stream: newsBloc.allNewsByCategory,
            builder: (context, AsyncSnapshot<ArticleModel> snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Expanded(
                      child: CategoriesList(_selectedCategories),
                    ),
                    if (snapshot.data.articles.length == 0)
                      Expanded(
                        flex: 4,
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context).translate('no_news'),
                          ),
                        ),
                      )
                    else
                      Expanded(
                        flex: 4,
                        child: NewsList(snapshot),
                      ),
                  ],
                );
              } else if (snapshot.hasError) {
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

class CategoriesList extends StatelessWidget {
  CategoriesList(this.selectedCategories);

  final List<String> selectedCategories;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: selectedCategories.length,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            return CategoryTile(selectedCategories[index]);
          }),
    );
  }
}

class CategoryTile extends StatefulWidget {
  CategoryTile(this.category);

  final String category;

  @override
  _CategoryTileState createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = widget.category;
        });

        newsBloc.fetchAllNewsByCategory(
          languageCode:
              BlocProvider.of<LanguageBloc>(context).state.locale.languageCode,
          country: state.country,
          paging: state.paging,
          category: _selectedCategory,
        );
      },
      child: ConstrainedBox(
        constraints: new BoxConstraints(
          minWidth: 150,
        ),
        child: Card(
          color: widget.category == _selectedCategory
              ? HexColor.fromHex(ColorConstants.primaryColor)
              : Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                getIconOfCategory(widget.category),
              ),
              SizedBox(width: 4),
              Text(
                AppLocalizations.of(context).translate(widget.category),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: widget.category == _selectedCategory
                      ? HexColor.fromHex(ColorConstants.secondaryWhite)
                      : HexColor.fromHex(ColorConstants.lightBlack),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
