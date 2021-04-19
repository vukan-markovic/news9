import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/src/blocs/language_bloc/language_bloc.dart';
import 'package:news/src/constants/languages.dart';
import 'package:news/src/utils/app_localizations.dart';

class LanguageInput extends StatelessWidget {
  final List<String> supportedLanguages = [
    'EN',
    'DE',
    'ES',
    'FR',
    'IT',
    'NL',
    'NO',
    'PT',
    'RU',
    'ZH'
  ];

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(Icons.language),
      title: Text(
        AppLocalizations.of(context).translate('language'),
      ),
      trailing: Text(
        context.read<LanguageBloc>().state.locale.languageCode.toUpperCase(),
      ),
      children: [
        Column(
          children: _buildExpandableContent(context),
        ),
      ],
    );
  }

  List<Widget> _buildExpandableContent(BuildContext context) {
    List<Widget> columnContent = [];

    for (String language in supportedLanguages)
      columnContent.add(
        new ListTile(
          title: new Text(
            language,
            style: new TextStyle(fontSize: 18.0),
          ),
          onTap: () {
            BlocProvider.of<LanguageBloc>(context)
                .add(LanguageSelected(languages[language.toLowerCase()]));
          },
        ),
      );

    return columnContent;
  }
}
