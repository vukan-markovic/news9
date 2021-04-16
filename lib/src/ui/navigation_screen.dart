import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/src/blocs/language_bloc/language_bloc.dart';
import 'package:news/src/constants/ColorConstants.dart';
import 'package:news/src/constants/enums.dart';
import 'package:news/src/extensions/Color.dart';
import 'package:news/src/ui/favorite_news_screen.dart';
import 'package:news/src/ui/user_page.dart';
import 'package:news/src/utils/app_localizations.dart';
import 'global_news_screen.dart';

class NavigationScreen extends StatefulWidget {
  _NavigationScreenState createState() => _NavigationScreenState();

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => NavigationScreen());
  }
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _currentIndex = 0;

  //Todo Replace the Containers with the screens when created

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pageOptions = [
      GlobalNews(),
      Container(
          child:
              Text(AppLocalizations.of(context).translate('recommended_news'))),
      FavoriteNewsScreen(),
      UserPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter News9"),
        backgroundColor: HexColor.fromHex(ColorConstants.primaryColor),
        actions: [
          ElevatedButton(
            child: Text('AR'),
            onPressed: () => BlocProvider.of<LanguageBloc>(context).add(
              LanguageSelected(Language.AR),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            child: Text('EN'),
            onPressed: () => BlocProvider.of<LanguageBloc>(context).add(
              LanguageSelected(Language.EN),
            ),
          ),
        ],
      ),
      body: _pageOptions[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 30,
        items: [
          BottomNavigationBarItem(
              icon: _currentIndex == 0
                  ? Icon(Icons.home_rounded)
                  : Icon(Icons.home_outlined),
              label: 'Global',
              backgroundColor: HexColor.fromHex(ColorConstants.primaryColor)),
          BottomNavigationBarItem(
            icon: _currentIndex == 1
                ? Icon(Icons.star_rounded)
                : Icon(Icons.star_border_rounded),
            label: 'Recommended',
            backgroundColor: HexColor.fromHex(ColorConstants.primaryColor),
          ),
          BottomNavigationBarItem(
            icon: _currentIndex == 2
                ? Icon(Icons.bookmark_rounded)
                : Icon(Icons.bookmark_border_rounded),
            label: 'Favorite',
            backgroundColor: HexColor.fromHex(ColorConstants.primaryColor),
          ),
          BottomNavigationBarItem(
            icon: _currentIndex == 3
                ? Icon(Icons.person_rounded)
                : Icon(Icons.person_outline_rounded),
            label: 'Profile',
            backgroundColor: HexColor.fromHex(ColorConstants.primaryColor),
          ),
        ],
        onTap: setCurrentIndex,
      ),
    );
  }

  void setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
