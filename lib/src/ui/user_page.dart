import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:news/src/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:news/src/blocs/change_theme_bloc/bloc/change_theme_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/src/models/user/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ValueListenableBuilder(
      valueListenable: Hive.box<AppUser>('user').listenable(),
      builder: (context, box, widget) {
        AppUser user =
            box.get(context.read<AuthenticationBloc>().state.user.email);
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
                  Text(
                    '${user.firstName} ${user.lastName}, ${user.dateOfBirth}, ${user.gender}',
                    style: textTheme.headline6,
                  ),
                  SizedBox(height: 8.0),
                  Text(user.email, style: textTheme.headline5),
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
                        value: context
                                    .read<ChangeThemeBloc>()
                                    .state
                                    .themeData
                                    .brightness ==
                                Brightness.light
                            ? false
                            : true,
                        onChanged: (bool value) {
                          if (value) {
                            context.read<ChangeThemeBloc>().onDarkThemeChange();
                          } else {
                            context
                                .read<ChangeThemeBloc>()
                                .onLightThemeChange();
                          }
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
      },
    );
  }
}
