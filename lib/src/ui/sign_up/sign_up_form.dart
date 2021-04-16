import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:news/src/blocs/sign_up_bloc/sign_up_cubit.dart';
import 'package:news/src/constants/enums.dart';
import 'package:news/src/ui/login/login_page.dart';
import 'package:news/src/utils/app_localizations.dart';

import '../dialog.dart';

class SignUpForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          AppDialog.showAppDialog(
            context: context,
            title: 'Sign up failed!',
            body: 'The sign up failed. Please try again.',
          );
        } else if (state.status.isSubmissionSuccess) {
          Navigator.of(context).pushReplacement(LoginPage.route());
          AppDialog.showAppDialog(
            context: context,
            title: 'Verification email sent!',
            body: 'Please check your inbox and follow the instructions.',
          );
        }
      },
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context).translate('sign_up'),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                _FirstNameInput(),
                SizedBox(height: 8.0),
                _LastNameInput(),
                SizedBox(height: 8.0),
                _DateOfBirthInput(),
                SizedBox(height: 8.0),
                _EmailInput(),
                SizedBox(height: 8.0),
                _PasswordInput(),
                SizedBox(height: 8.0),
                _GenderInput(),
                SizedBox(height: 8.0),
                _SignUpButton(),
                SizedBox(height: 8.0),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pushReplacement(LoginPage.route()),
                  child: Text(AppLocalizations.of(context).translate('log_in')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FirstNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.firstName != current.firstName,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_firstNameInput_textField'),
          onChanged: (firstName) =>
              context.read<SignUpCubit>().firstNameChanged(firstName),
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person),
            labelText: 'First Name',
            helperText: '',
            errorText:
                state.firstName.invalid ? 'First name must not be empty' : null,
          ),
        );
      },
    );
  }
}

class _LastNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.lastName != current.lastName,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_lastNameInput_textField'),
          onChanged: (lastName) =>
              context.read<SignUpCubit>().lastNameChanged(lastName),
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person),
            labelText: 'Last Name',
            helperText: '',
            errorText:
                state.lastName.invalid ? 'Last name must not be empty' : null,
          ),
        );
      },
    );
  }
}

class _DateOfBirthInput extends StatefulWidget {
  @override
  __DateOfBirthInputState createState() => __DateOfBirthInputState();
}

class __DateOfBirthInputState extends State<_DateOfBirthInput> {
  DateTime selectedDate = DateTime.now();
  String labelText = 'Date of birth';

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
        context.read<SignUpCubit>().dateOfBirthChanged(labelText);
      });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
          previous.dateOfBirth != current.dateOfBirth,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_dateOfBirthInput_textField'),
          onTap: () => _selectDate(context),
          readOnly: true,
          keyboardType: TextInputType.datetime,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person),
            labelText: labelText,
            helperText: '',
            errorText: state.dateOfBirth.invalid
                ? 'Date of birth must be selected'
                : null,
          ),
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_emailInput_textField'),
          onChanged: (email) => context.read<SignUpCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.email_outlined),
            labelText: 'Email',
            helperText: '',
            errorText: state.email.invalid ? 'Invalid email' : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<SignUpCubit>().passwordChanged(password),
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock),
            labelText: 'Password',
            helperText:
                '1 uppercase letter, 1 lowercase letter, 1 number, 1 special character and min length of 12 characters.',
            errorText: state.password.invalid ? 'Invalid password' : null,
          ),
        );
      },
    );
  }
}

Gender _gender = Gender.male;

class _GenderInput extends StatefulWidget {
  @override
  __GenderInputState createState() => __GenderInputState();
}

class __GenderInputState extends State<_GenderInput> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(child: Icon(Icons.person)),
        SizedBox(width: 8.0),
        Flexible(child: Text(AppLocalizations.of(context).translate('gender'))),
        Expanded(
          flex: 2,
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(AppLocalizations.of(context).translate('male')),
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
                title: Text(AppLocalizations.of(context).translate('female')),
                leading: Radio<Gender>(
                  value: Gender.female,
                  groupValue: _gender,
                  onChanged: (Gender value) {
                    setState(() {
                      _gender = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('signUpForm_continue_raisedButton'),
                child: Text(
                  AppLocalizations.of(context).translate('create_account'),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  primary: Colors.blue,
                ),
                onPressed: state.status.isValidated
                    ? () async {
                        String gender =
                            _gender == Gender.male ? 'Male' : 'Female';
                        await context
                            .read<SignUpCubit>()
                            .signUpFormSubmitted(gender);
                        context.read<SignUpCubit>().sendVerificationEmail();
                      }
                    : null,
              );
      },
    );
  }
}
