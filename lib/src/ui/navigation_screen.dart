import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/src/constants/ColorConstants.dart';
import 'package:news/src/extensions/Color.dart';
import 'package:news/src/ui/favorite_news_screen.dart';
import 'package:news/src/ui/profile/profile.dart';
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
  final List<Widget> _pageOptions = [
    GlobalNews(),
    Container(child: Text("Recommended news")),
    FavoriteNewsScreen(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              label: AppLocalizations.of(context).translate('global'),
              backgroundColor: HexColor.fromHex(ColorConstants.primaryColor)),
          BottomNavigationBarItem(
            icon: _currentIndex == 1
                ? Icon(Icons.star_rounded)
                : Icon(Icons.star_border_rounded),
            label: AppLocalizations.of(context).translate('recommended'),
            backgroundColor: HexColor.fromHex(ColorConstants.primaryColor),
          ),
          BottomNavigationBarItem(
            icon: _currentIndex == 2
                ? Icon(Icons.bookmark_rounded)
                : Icon(Icons.bookmark_border_rounded),
            label: AppLocalizations.of(context).translate('favorites'),
            backgroundColor: HexColor.fromHex(ColorConstants.primaryColor),
          ),
          BottomNavigationBarItem(
            icon: _currentIndex == 3
                ? Icon(Icons.person_rounded)
                : Icon(Icons.person_outline_rounded),
            label: AppLocalizations.of(context).translate('profile'),
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
