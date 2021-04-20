import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/src/blocs/advanced_search_bloc/advanced_search_bloc.dart';
import 'package:news/src/blocs/news_bloc/news_bloc.dart';
import 'package:news/src/constants/countries.dart';
import 'package:news/src/models/article/article_model.dart';
import 'package:news/src/models/source_model.dart';
import 'package:news/src/utils/app_localizations.dart';

Source source;
String country;

class AdvancedSearchInput extends StatefulWidget {
  @override
  _AdvancedSearchInputState createState() => _AdvancedSearchInputState();
}

class _AdvancedSearchInputState extends State<AdvancedSearchInput> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdvancedSearchBloc, AdvancedSearchState>(
      builder: (context, state) {
        if (source == null && country == null) {
          source = Source(name: state.source);
          country = state.country;
        }

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
                  _DateInput(state.dateFrom, state.dateTo),
                  _CountryInput(),
                  _SourceInput(),
                  _PagingInput(state.paging),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CountryInput extends StatefulWidget {
  @override
  __CountryInputState createState() => __CountryInputState();
}

class __CountryInputState extends State<_CountryInput> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text('Country:'),
        ),
        Expanded(
          flex: 3,
          child: DropdownButton<String>(
            value: country,
            icon: const Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            onChanged: (String newValue) {
              setState(() {
                country = newValue;
                if (country != 'All') {
                  source = Source(name: 'All', id: 'all');

                  BlocProvider.of<AdvancedSearchBloc>(context).add(
                    AdvancedSearchSelected(
                        source: source.id,
                        dateFrom: '',
                        dateTo: '',
                        country: country),
                  );
                }
              });
            },
            items:
                countries.values.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _SourceInput extends StatefulWidget {
  @override
  __SourceInputState createState() => __SourceInputState();
}

class __SourceInputState extends State<_SourceInput> {
  @override
  void initState() {
    newsBloc.fetchAllSources();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: newsBloc.allSources,
        builder: (context, AsyncSnapshot<SourceModel> snapshot) {
          if (snapshot.hasData) {
            return Row(
              children: [
                Expanded(
                  child: Text('Source:'),
                ),
                Expanded(
                  flex: 3,
                  child: DropdownButton<Source>(
                    value: source,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    onChanged: (Source newValue) {
                      setState(() {
                        source = newValue;
                        if (source.name != 'All') {
                          country = 'All';

                          BlocProvider.of<AdvancedSearchBloc>(context).add(
                            AdvancedSearchSelected(
                                source: source.id,
                                dateFrom: '',
                                dateTo: '',
                                country: country),
                          );
                        }
                      });
                    },
                    items: snapshot.data.sources
                        .map<DropdownMenuItem<Source>>((Source value) {
                      return DropdownMenuItem<Source>(
                        value: value,
                        child: Text(value.name),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return Center(child: CircularProgressIndicator());
        });
  }
}

class _PagingInput extends StatefulWidget {
  _PagingInput(this.paging);

  final String paging;

  @override
  __PagingInputState createState() => __PagingInputState(paging);
}

class __PagingInputState extends State<_PagingInput> {
  __PagingInputState(this.paging);

  String paging;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text('News per page:'),
        ),
        SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: DropdownButton<String>(
            value: paging,
            icon: const Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            onChanged: (String newValue) {
              setState(() {
                paging = newValue;
                BlocProvider.of<AdvancedSearchBloc>(context).add(
                  AdvancedSearchPagingSelected(newValue),
                );
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
        ),
      ],
    );
  }
}

class _DateInput extends StatefulWidget {
  _DateInput(this.dateFrom, this.dateTo);

  final String dateFrom;
  final String dateTo;

  @override
  __DateInputState createState() => __DateInputState();
}

class __DateInputState extends State<_DateInput> {
  DateTime selectedDateFrom;
  DateTime selectedDateTo;
  String labelTextFrom;
  String labelTextTo;

  @override
  void initState() {
    selectedDateFrom = widget.dateFrom.isNotEmpty
        ? DateTime.parse(widget.dateFrom)
        : DateTime.now();

    labelTextFrom = "${selectedDateFrom.toLocal()}".split(' ')[0];

    selectedDateTo = widget.dateTo.isNotEmpty
        ? DateTime.parse(widget.dateTo)
        : DateTime.now();

    labelTextTo = "${selectedDateTo.toLocal()}".split(' ')[0];
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTimeRange picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000, 1),
      lastDate: DateTime.now(),
      initialDateRange:
          DateTimeRange(start: selectedDateFrom, end: selectedDateTo),
    );
    if (picked != null)
      setState(() {
        selectedDateFrom = picked.start;
        selectedDateTo = picked.end;
        labelTextFrom = "${selectedDateFrom.toLocal()}".split(' ')[0];
        labelTextTo = "${selectedDateTo.toLocal()}".split(' ')[0];

        source = Source(name: 'All', id: 'all');
        country = 'All';

        BlocProvider.of<AdvancedSearchBloc>(context).add(
          AdvancedSearchSelected(
              source: source.id,
              dateFrom: selectedDateFrom.toString(),
              dateTo: selectedDateTo.toString(),
              country: country),
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          child: Icon(
            Icons.calendar_today,
          ),
          onTap: () => _selectDate(context),
        ),
        SizedBox(width: 16),
        Text('From: $labelTextFrom'),
        SizedBox(width: 16),
        Text('To: $labelTextTo'),
      ],
    );
  }
}
