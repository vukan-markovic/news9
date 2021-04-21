import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/src/blocs/category_bloc/category_bloc.dart';
import 'package:news/src/models/category/category_tile.dart';
import 'package:news/src/utils/app_localizations.dart';
import 'package:news/src/utils/shared_preferences_topic_select_service.dart';
import '../constants/ColorConstants.dart';
import '../extensions/Color.dart';
import 'navigation_screen.dart';

class TopicSelectScreen extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => TopicSelectScreen());
  }

  _TopicSelectScreenState createState() => _TopicSelectScreenState();
}

class _TopicSelectScreenState extends State<TopicSelectScreen> {
  List<String> _selectedCategories = [];
  List<CategoryTile> _categories = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getFromFuture();
    });

    super.initState();
  }

  getFromFuture() async {
    _selectedCategories = await categoryBloc.getAllCategories();

    setState(() {
      _selectedCategories = _selectedCategories ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    _categories = [
      CategoryTile(
        title: AppLocalizations.of(context).translate('category_business'),
        icon: Icons.business,
      ),
      CategoryTile(
        title: AppLocalizations.of(context).translate('category_entertainment'),
        icon: Icons.sports_esports,
      ),
      CategoryTile(
        title: AppLocalizations.of(context).translate('category_general'),
        icon: Icons.home,
      ),
      CategoryTile(
        title: AppLocalizations.of(context).translate('category_health'),
        icon: Icons.local_hospital,
      ),
      CategoryTile(
        title: AppLocalizations.of(context).translate('category_science'),
        icon: Icons.science,
      ),
      CategoryTile(
        title: AppLocalizations.of(context).translate('category_sports'),
        icon: Icons.sports_soccer,
      ),
      CategoryTile(
        title: AppLocalizations.of(context).translate('category_technology'),
        icon: Icons.computer,
      ),
    ];

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 38, left: 8),
                        child: Text(
                          AppLocalizations.of(context).translate('topic_title'),
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color:
                                  HexColor.fromHex(ColorConstants.lightBlack)),
                        )),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(top: 8, left: 8),
                      child: Text(
                          AppLocalizations.of(context)
                              .translate('topic_subtitle'),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color:
                                  HexColor.fromHex(ColorConstants.silverGray))),
                    ),
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
                                      ? HexColor.fromHex(
                                          ColorConstants.primaryColor)
                                      : HexColor.fromHex(ColorConstants
                                          .primaryColorDisabled))),
                          onPressed: _selectedCategories.length >= 2
                              ? () async {
                                  categoryBloc.deleteCategoriesByUid(
                                      FirebaseAuth.instance.currentUser?.uid ??
                                          "wOJ3BsX5EnNgFAZYvPeGdK3TCVf2");
                                  categoryBloc
                                      .insetCategoryList(_selectedCategories);

                                  final sharedPrefService =
                                      await SharedPreferencesTopicSelectService
                                          .instance;

                                  if (sharedPrefService.isFirstTime()) {
                                    sharedPrefService.setValue();

                                    Navigator.of(context)
                                        .pushAndRemoveUntil<void>(
                                      NavigationScreen.route(),
                                      (route) => false,
                                    );
                                  } else {
                                    Navigator.of(context)
                                        .pop(); //TODO Go to Recommendation screen when implemented.
                                  }
                                }
                              : null,
                          child: Text(
                            AppLocalizations.of(context).translate('finish'),
                            style: TextStyle(
                              color: HexColor.fromHex(
                                  ColorConstants.secondaryWhite),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gridView() {
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
              color: _selectedCategories.contains(_categories[index].title)
                  ? HexColor.fromHex(ColorConstants.primaryColor)
                  : Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Row(
                  children: [
                    Icon(_categories[index].icon),
                    SizedBox(width: 4),
                    Text(
                      _categories[index].title,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: _selectedCategories
                                  .contains(_categories[index].title)
                              ? HexColor.fromHex(ColorConstants.secondaryWhite)
                              : HexColor.fromHex(ColorConstants.lightBlack)),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void setTileState(int index) {
    setState(() {
      _selectedCategories.contains(_categories[index].title)
          ? _selectedCategories.remove(_categories[index].title)
          : _selectedCategories.add(_categories[index].title);
    });
  }
}
