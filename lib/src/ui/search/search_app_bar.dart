import 'package:flutter/material.dart';
import 'package:news/src/constants/ColorConstants.dart';
import 'package:news/src/extensions/Color.dart';
import 'package:news/src/ui/dialogs/filter_news_dialog.dart';
import 'package:news/src/ui/search/search_news.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  SearchAppBar(
      this.filter, this.searchNews, this.showFilterButton, this.sortNews,
      [this.appBarTitle]);

  final TextEditingController filter;
  final void Function() searchNews;
  final void Function() sortNews;
  final bool showFilterButton;
  final Widget appBarTitle;

  @override
  _SearchAppBarState createState() => _SearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(50);
}

class _SearchAppBarState extends State<SearchAppBar> {
  Icon _searchIcon = Icon(Icons.search);
  Widget _appBarTitle;

  @override
  void initState() {
    _appBarTitle = widget.appBarTitle ?? Text('Flutter News9');
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SearchAppBar oldWidget) {
    _appBarTitle = widget.appBarTitle ?? Text('Flutter News9');
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _appBarTitle,
      backgroundColor: HexColor.fromHex(ColorConstants.primaryColor),
      actions: <Widget>[
        IconButton(
          icon: _searchIcon,
          onPressed: () => _searchPressed(),
        ),
        if (widget.showFilterButton)
          IconButton(
            icon: Icon(Icons.filter_alt),
            onPressed: () async {
              var sortNews = await FilterNewsDialog.showFilterNewsDialog(
                  context, 'recommended');
              if (sortNews) widget.sortNews();
            },
          ),
      ],
    );
  }

  void _searchPressed() {
    if (this._searchIcon.icon == Icons.search) {
      setState(() {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle =
            SearchNews(widget.filter, widget.searchNews, _closeInputField);
      });
    } else {
      _closeInputField();
    }
  }

  void _closeInputField() {
    setState(() {
      this._searchIcon = new Icon(Icons.search);
      this._appBarTitle = new Text('Flutter News9');
      widget.filter.clear();
    });
  }
}
