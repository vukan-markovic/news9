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
        color: HexColor.fromHex(ColorConstants.selectedTextColor),
      ),
      cursorColor: HexColor.fromHex(ColorConstants.selectedTextColor),
      decoration: new InputDecoration(
        prefixIcon: new Icon(
          Icons.search,
          color: HexColor.fromHex(ColorConstants.selectedTextColor),
        ),
        hintText: 'Search...',
        hintStyle:
            TextStyle(color: HexColor.fromHex(ColorConstants.selectedTextColor)),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: HexColor.fromHex(ColorConstants.selectedTextColor),
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: HexColor.fromHex(ColorConstants.secondaryColor),
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
