import 'package:flutter/material.dart';
import 'package:news/src/constants/ColorConstants.dart';
import 'package:news/src/extensions/Color.dart';

class SearchNews extends StatelessWidget {
  SearchNews(this.filter, this.searchNews, this.closeInputField);

  final TextEditingController filter;
  final void Function() searchNews;
  final void Function() closeInputField;

  @override
  Widget build(BuildContext context) {
    return new TextField(
      controller: filter,
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
      onSubmitted: (_) {
        searchNews();
        closeInputField();
      },
    );
  }
}
