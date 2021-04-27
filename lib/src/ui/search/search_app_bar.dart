import 'package:flutter/material.dart';
import 'package:news/src/constants/ColorConstants.dart';
import 'package:news/src/extensions/Color.dart';
import 'package:news/src/ui/search/search_news.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  SearchAppBar(this.filter, this.searchNews);

  final TextEditingController filter;
  final void Function() searchNews;

  @override
  _SearchAppBarState createState() => _SearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(50);
}

class _SearchAppBarState extends State<SearchAppBar> {
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Flutter News9');

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _appBarTitle,
      backgroundColor: HexColor.fromHex(ColorConstants.primaryColor),
      actions: <Widget>[
        IconButton(
          icon: _searchIcon,
          onPressed: () => _searchPressed(),
        )
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
