import 'package:flutter/material.dart';
import 'package:news/src/constants/enums.dart';
import 'package:news/src/utils/app_localizations.dart';

SortOptions options = SortOptions.date;
SortOrder order = SortOrder.desc;

SortOptions optionsRecommended = SortOptions.date;
SortOrder orderRecommended = SortOrder.desc;

SortOptions optionsFavorites = SortOptions.date;
SortOrder orderFavorites = SortOrder.desc;

class FilterNewsDialog {
  static Future<bool> showFilterNewsDialog(context, String screen) async {
    if (screen == 'recommended') {
      options = optionsRecommended;
      order = orderRecommended;
    } else {
      options = optionsFavorites;
      order = orderFavorites;
    }

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Sort news by date, title or source"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                _OptionsInput(),
                SizedBox(height: 8),
                _OrderInput(),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context).translate('ok')),
              onPressed: () {
                Navigator.of(context).pop(true);
                if (screen == 'recommended') {
                  optionsRecommended = options;
                  orderRecommended = order;
                } else {
                  optionsFavorites = options;
                  orderFavorites = order;
                }
              },
            ),
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ],
        );
      },
    );
  }
}

class _OptionsInput extends StatefulWidget {
  @override
  _OptionsInputState createState() => _OptionsInputState();
}

class _OptionsInputState extends State<_OptionsInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Sort by:'),
        ListTile(
          title: Text('Date'),
          trailing: Radio<SortOptions>(
            value: SortOptions.date,
            groupValue: options,
            onChanged: (SortOptions value) {
              setState(() {
                options = value;
              });
            },
          ),
        ),
        ListTile(
          title: Text('Title'),
          trailing: Radio<SortOptions>(
            value: SortOptions.title,
            groupValue: options,
            onChanged: (SortOptions value) {
              setState(() {
                options = value;
              });
            },
          ),
        ),
        ListTile(
          title: Text('Source'),
          trailing: Radio<SortOptions>(
            value: SortOptions.source,
            groupValue: options,
            onChanged: (SortOptions value) {
              setState(() {
                options = value;
              });
            },
          ),
        ),
      ],
    );
  }
}

class _OrderInput extends StatefulWidget {
  @override
  _OrderInputState createState() => _OrderInputState();
}

class _OrderInputState extends State<_OrderInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Order:'),
        ListTile(
          title: Text('ASC'),
          trailing: Radio<SortOrder>(
            value: SortOrder.asc,
            groupValue: order,
            onChanged: (SortOrder value) {
              setState(() {
                order = value;
              });
            },
          ),
        ),
        ListTile(
          title: Text('DESC'),
          trailing: Radio<SortOrder>(
            value: SortOrder.desc,
            groupValue: order,
            onChanged: (SortOrder value) {
              setState(() {
                order = value;
              });
            },
          ),
        ),
      ],
    );
  }
}
