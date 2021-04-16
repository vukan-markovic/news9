import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news/src/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:news/src/blocs/change_theme_bloc/bloc/change_theme_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/src/blocs/user_page_bloc/user_page_cubit.dart';
import 'package:news/src/constants/enums.dart';
import 'package:news/src/models/user/user.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:formz/formz.dart';
import 'package:flutter/foundation.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

Gender _gender = Gender.male;
TextEditingController _firstNamecontroller;
TextEditingController _lastNamecontroller;
String _imagePath;

class _UserPageState extends State<UserPage> {
  String editText = 'Edit';
  final picker = ImagePicker();
  ImageProvider profileImage;

  Future getImage(String email, String gender) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imagePath = pickedFile.path;

        if (kIsWeb) {
          // context.read<UserPageCubit>().updateUser(email, gender, _imagePath);
          profileImage = Image.network(pickedFile.path).image;
        } else {
          // context.read<UserPageCubit>().updateUser(email, gender, _imagePath);
          profileImage = Image.file(File(_imagePath)).image;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ValueListenableBuilder(
      valueListenable: Hive.box<AppUser>('user').listenable(),
      builder: (context, Box<AppUser> box, widget) {
        AppUser user =
            box.get(context.read<AuthenticationBloc>().state.user.email);
        if (user != null) {
          if (editText == 'Edit') {
            _gender = user.gender == 'Male' ? Gender.male : Gender.female;
            _firstNamecontroller =
                new TextEditingController(text: user.firstName);
            _lastNamecontroller =
                new TextEditingController(text: user.lastName);
            context.read<UserPageCubit>().setInitialValues(user);
          }
          if (profileImage == null) {
            if (user.imagePath != null) {
              if (kIsWeb) {
                profileImage = Image.network(
                  user.imagePath,
                ).image;
              } else {
                profileImage = Image.file(
                  File(user.imagePath),
                ).image;
              }
            } else {
              profileImage = Image.asset('assets/splash.jpg').image;
            }
          }
        }
        return Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    child: GestureDetector(
                      onTap: () => editText == 'Edit'
                          ? null
                          : getImage(user.email, user.gender),
                      child: CircleAvatar(
                        radius: 48,
                        backgroundImage: profileImage,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  if (user != null) ...[
                    Text(
                      '${user.firstName} ${user.lastName}, ${user.dateOfBirth}, ${user.gender}',
                      style: textTheme.headline6,
                    ),
                    SizedBox(height: 8.0),
                    Text(user.email, style: textTheme.headline5),
                    SizedBox(height: 8.0),
                  ],
                  if (editText == 'Save') ...[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text('First name:'),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        _FirstNameInput()
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text('Last name:'),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        _LastNameInput()
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text('Date of birth:'),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Flexible(
                          child: _DateOfBirthInput(
                            user.dateOfBirth,
                          ),
                        ),
                      ],
                    ),
                    _GenderInput(),
                  ],
                  SizedBox(height: 8.0),
                  BlocBuilder<UserPageCubit, UserPageState>(
                    buildWhen: (previous, current) =>
                        previous.status != current.status,
                    builder: (context, state) {
                      return state.status.isSubmissionInProgress
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              key:
                                  const Key('signUpForm_continue_raisedButton'),
                              child: Text(
                                editText,
                                style: TextStyle(fontSize: 16),
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                primary: Colors.blue,
                              ),
                              onPressed: state.status.isValidated
                                  ? () async {
                                      if (editText == 'Save') {
                                        String gender = _gender == Gender.male
                                            ? 'Male'
                                            : 'Female';
                                        await context
                                            .read<UserPageCubit>()
                                            .updateUser(
                                                user.email, gender, _imagePath);
                                      }

                                      setState(() {
                                        if (editText == 'Edit')
                                          editText = 'Save';
                                        else {
                                          editText = 'Edit';
                                        }
                                      });
                                    }
                                  : null,
                            );
                    },
                  ),
                  SizedBox(height: 8.0),
                  Divider(),
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
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.category),
                        title: Text('Your topics'),
                        onTap: () {},
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.settings),
                        title: Text('Advanced search'),
                        onTap: () {},
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.logout),
                        title: Text('Log out'),
                        onTap: () => context
                            .read<AuthenticationBloc>()
                            .add(AuthenticationLogoutRequested()),
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

class _FirstNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserPageCubit, UserPageState>(
      buildWhen: (previous, current) => previous.firstName != current.firstName,
      builder: (context, state) {
        return Flexible(
          child: TextField(
            onChanged: (firstName) =>
                context.read<UserPageCubit>().firstNameChanged(firstName),
            controller: _firstNamecontroller,
            decoration: InputDecoration(
              errorText: state.firstName.invalid
                  ? 'First name must not be empty'
                  : null,
            ),
          ),
        );
      },
    );
  }
}

class _LastNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserPageCubit, UserPageState>(
      buildWhen: (previous, current) => previous.lastName != current.lastName,
      builder: (context, state) {
        return Flexible(
          child: TextField(
            onChanged: (lastName) =>
                context.read<UserPageCubit>().lastNameChanged(lastName),
            controller: _lastNamecontroller,
            decoration: InputDecoration(
              errorText:
                  state.lastName.invalid ? 'Last name must not be empty' : null,
            ),
          ),
        );
      },
    );
  }
}

class _DateOfBirthInput extends StatefulWidget {
  _DateOfBirthInput(this.dateOfBirth);

  final String dateOfBirth;

  @override
  __DateOfBirthInputState createState() => __DateOfBirthInputState();
}

class __DateOfBirthInputState extends State<_DateOfBirthInput> {
  DateTime selectedDate;
  String labelText;

  @override
  void initState() {
    selectedDate = DateTime.parse(widget.dateOfBirth);
    labelText = "${selectedDate.toLocal()}".split(' ')[0];
    super.initState();
  }

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
        context.read<UserPageCubit>().dateOfBirthChanged(labelText);
      });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserPageCubit, UserPageState>(
      buildWhen: (previous, current) =>
          previous.dateOfBirth != current.dateOfBirth,
      builder: (context, state) {
        return TextField(
          key: const Key('dateOfBirthInput_textField'),
          onTap: () => _selectDate(context),
          readOnly: true,
          keyboardType: TextInputType.datetime,
          decoration: InputDecoration(
            labelText: labelText,
            errorText: state.dateOfBirth.invalid
                ? 'Date of birth must be selected'
                : null,
          ),
        );
      },
    );
  }
}

class _GenderInput extends StatefulWidget {
  @override
  __GenderInputState createState() => __GenderInputState();
}

class __GenderInputState extends State<_GenderInput> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text('Gender:'),
        ),
        Expanded(
          flex: 2,
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text('Male'),
                leading: Radio<Gender>(
                  value: Gender.male,
                  groupValue: _gender,
                  onChanged: (Gender value) {
                    setState(() {
                      _gender = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: Text('Female'),
                leading: Radio<Gender>(
                  value: Gender.female,
                  groupValue: _gender,
                  onChanged: (Gender value) {
                    setState(() {
                      _gender = value;
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
