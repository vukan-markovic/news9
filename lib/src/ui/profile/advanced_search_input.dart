import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/src/constants/enums.dart';
import 'package:news/src/utils/app_localizations.dart';

class AdvancedSearchInput extends StatefulWidget {
  @override
  _AdvancedSearchInputState createState() => _AdvancedSearchInputState();
}

class _AdvancedSearchInputState extends State<AdvancedSearchInput> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(Icons.settings),
      title: Text(
        AppLocalizations.of(context).translate('advanced_search'),
      ),
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DateInput(),
              _CountryInput(),
              _SourceInput(),
              _PagingInput(),
              _SortingInput(),
            ],
          ),
        ),
      ],
    );
  }
}

class _CountryInput extends StatefulWidget {
  @override
  __CountryInputState createState() => __CountryInputState();
}

class __CountryInputState extends State<_CountryInput> {
  String dropdownValue = 'Country';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['Country', 'Two', 'Free', 'Four']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class _SourceInput extends StatefulWidget {
  @override
  __SourceInputState createState() => __SourceInputState();
}

class __SourceInputState extends State<_SourceInput> {
  String dropdownValue = 'Source';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['Source', 'Two', 'Free', 'Four']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class _PagingInput extends StatefulWidget {
  @override
  __PagingInputState createState() => __PagingInputState();
}

class __PagingInputState extends State<_PagingInput> {
  String dropdownValue = '20';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('News per page:'),
        SizedBox(width: 8),
        DropdownButton<String>(
          value: dropdownValue,
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
            });
          },
          items: <String>['10', '20', '50', '100']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _SortingInput extends StatefulWidget {
  @override
  __SortingInputState createState() => __SortingInputState();
}

class __SortingInputState extends State<_SortingInput> {
  Sort _sorting = Sort.asc;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text('Sort:')),
        Expanded(
          flex: 3,
          child: ListTile(
            title: Text('ASC'),
            leading: Radio<Sort>(
              value: Sort.asc,
              groupValue: _sorting,
              onChanged: (Sort value) {
                setState(() {
                  _sorting = value;
                });
              },
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: ListTile(
            title: Text('DSC'),
            leading: Radio<Sort>(
              value: Sort.desc,
              groupValue: _sorting,
              onChanged: (Sort value) {
                setState(() {
                  _sorting = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _DateInput extends StatefulWidget {
  @override
  __DateInputState createState() => __DateInputState();
}

class __DateInputState extends State<_DateInput> {
  DateTime selectedDate = DateTime.now();
  String labelText = "${DateTime.now().toLocal()}".split(' ')[0];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        labelText = "${selectedDate.toLocal()}".split(' ')[0];
        // context.read<SignUpCubit>().dateOfBirthChanged(labelText);
      });
  }

  @override
  Widget build(BuildContext context) {
    // return BlocBuilder<SignUpCubit, SignUpState>(
    //   buildWhen: (previous, current) =>
    //       previous.dateOfBirth != current.dateOfBirth,
    //   builder: (context, state) {
    return Row(
      children: [
        GestureDetector(
          child: Icon(
            Icons.calendar_today,
          ),
          onTap: () => _selectDate(context),
        ),
        SizedBox(width: 8),
        Text(labelText),
      ],
    );
    //     },
    //   );
    // }
  }
}
