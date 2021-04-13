import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/src/constants/Strings.dart';

import '../constants/ColorConstants.dart';
import '../constants/ColorConstants.dart';
import '../constants/ColorConstants.dart';
import '../extensions/Color.dart';
import '../extensions/Color.dart';
import '../extensions/Color.dart';
import '../extensions/Color.dart';

class TopicSelectScreen extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => TopicSelectScreen());
  }

  _TopicSelectScreenState createState() => _TopicSelectScreenState();
}

class _TopicSelectScreenState extends State<TopicSelectScreen> {
  final List<String> _categories = [
    "Business",
    "Entertainment",
    "General",
    "Health",
    "Science",
    "Sports",
    "Technology"
  ];


  @override
  void initState() {
    _selectedCategories = List.filled(7, false);
  }

  List<bool> _selectedCategories = [];

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
                  Strings.topicTitle,
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: HexColor.fromHex(ColorConstants.lightBlack)),
                )),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(top: 8, left: 8),
              child: Text(Strings.topicSubtitle,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: HexColor.fromHex(ColorConstants.silverGray))),
            ),
            Container(
              alignment: Alignment.center,
              child: GridView.builder(
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
                        setState(() {
                          _selectedCategories[index] = _selectedCategories[index] == true ? false : true;
                        });
                      },
                      child: Card(
                        color: _selectedCategories[index] == true
                            ? Colors.blue
                            : Colors.white,
                        child: Center(
                          child: Text(
                            _categories[index],
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {},
                child: Text(Strings.finish),
              ),
            )
          ],
        ),
      ),
    );
  }
}
