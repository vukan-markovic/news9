import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/src/blocs/category_bloc/category_bloc.dart';
import 'package:news/src/utils/app_localizations.dart';

import '../constants/ColorConstants.dart';
import '../extensions/Color.dart';

class TopicSelectScreen extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => TopicSelectScreen());
  }

  _TopicSelectScreenState createState() => _TopicSelectScreenState();
}

class _TopicSelectScreenState extends State<TopicSelectScreen> {
  List<String> _selectedCategories = [];
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    getFromFuture();
    _selectedCategories = _selectedCategories ?? [];
    _categories = [
      AppLocalizations.of(context).translate('category_business'),
      AppLocalizations.of(context).translate('category_entertainment'),
      AppLocalizations.of(context).translate('category_general'),
      AppLocalizations.of(context).translate('category_health'),
      AppLocalizations.of(context).translate('category_science'),
      AppLocalizations.of(context).translate('category_sports'),
      AppLocalizations.of(context).translate('category_technology'),
    ];
  }

  getFromFuture() async {
    _selectedCategories = await categoryBloc.getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 38, left: 8),
                child: Text(
                  AppLocalizations.of(context).translate('topic_title'),
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: HexColor.fromHex(ColorConstants.lightBlack)),
                )),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(top: 8, left: 8),
              child: Text(
                  AppLocalizations.of(context).translate('topic_subtitle'),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: HexColor.fromHex(ColorConstants.silverGray))),
            ),
            Container(alignment: Alignment.center, child: _gridView()),
            Expanded(
              child: Container(
                alignment: Alignment.bottomCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints.tightFor(
                      width: double.infinity, height: 60),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            _selectedCategories.length >= 2
                                ? HexColor.fromHex(ColorConstants.primaryColor)
                                : HexColor.fromHex(
                                    ColorConstants.primaryColorDisabled))),
                    onPressed: _selectedCategories.length >= 2
                        ? () {
                            categoryBloc.deleteCategoriesByUid(
                                FirebaseAuth.instance.currentUser?.uid ??
                                    "wOJ3BsX5EnNgFAZYvPeGdK3TCVf2");
                            categoryBloc.insetCategoryList(_selectedCategories);
                          }
                        : null,
                    child: Text(
                      AppLocalizations.of(context).translate('finish'),
                      style: TextStyle(
                          color:
                              HexColor.fromHex(ColorConstants.secondaryWhite)),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _gridView() {
    return GridView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 5 / 2.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setTileState(index);
            },
            child: Card(
              color: _selectedCategories.contains(_categories[index])
                  ? HexColor.fromHex(ColorConstants.primaryColor)
                  : Colors.white,
              child: Center(
                child: Text(
                  _categories[index],
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: _selectedCategories.contains(_categories[index])
                          ? HexColor.fromHex(ColorConstants.secondaryWhite)
                          : HexColor.fromHex(ColorConstants.lightBlack)),
                ),
              ),
            ),
          );
        });
  }

  void setTileState(int index) {
    setState(() {
      _selectedCategories.contains(_categories[index])
          ? _selectedCategories.remove(_categories[index])
          : _selectedCategories.add(_categories[index]);
      print(_selectedCategories);
    });
  }
}
