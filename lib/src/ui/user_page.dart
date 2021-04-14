import 'package:flutter/material.dart';
import 'package:news/src/blocs/change_theme_bloc/bloc/change_theme_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircleAvatar(
                radius: 48,
                backgroundImage: null,
                child: Icon(Icons.person_outline, size: 48),
              ),
              SizedBox(height: 8.0),
              Text("First Name, Last Name...", style: textTheme.headline6),
              SizedBox(height: 8.0),
              Text("Email", style: textTheme.headline5),
              SizedBox(height: 8.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  primary: Colors.blue,
                ),
                child: Text(
                  'Edit',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {},
              ),
              SizedBox(height: 8.0),
              ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.language),
                    title: Text('Language'),
                    trailing: Text('EN'),
                    onTap: () {},
                  ),
                  SwitchListTile(
                    title: Text('Dark mode'),
                    value: _darkMode,
                    onChanged: (bool value) {
                      setState(() {
                        _darkMode = value;
                        if (_darkMode) {
                          context.read<ChangeThemeBloc>().onDarkThemeChange();
                        } else {
                          context.read<ChangeThemeBloc>().onLightThemeChange();
                        }
                      });
                    },
                    secondary: Icon(Icons.nights_stay),
                  ),
                  ListTile(
                    leading: Icon(Icons.category),
                    title: Text('Your topics'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Advanced search'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Log out'),
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
