import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:news/src/blocs/login_bloc/login_cubit.dart';
import 'package:news/src/ui/sign_up/sign_up_page.dart';

import '../dialog.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          AppDialog.showAppDialog(
            context: context,
            title: 'Incorrect password/email!',
            body:
                'The email and/or password you entered are incorrect. Please try again.',
          );
        } else if (state.status.isSubmissionSuccess && !state.emailVerified) {
          AppDialog.showAppDialog(
            context: context,
            title: 'Email not verified',
            body:
                'Your email is not verified. Please verify your email address.',
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
                    'Login',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                _EmailInput(),
                SizedBox(height: 8.0),
                _PasswordInput(),
                SizedBox(height: 8.0),
                _LoginButton(),
                SizedBox(height: 8.0),
                TextButton(
                  onPressed: () {},
                  child: Text('Reset password'),
                ),
                SizedBox(height: 24.0),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pushReplacement(SignUpPage.route()),
                  child: Text('Sign up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_emailInput_textField'),
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person),
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
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<LoginCubit>().passwordChanged(password),
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.vpn_key),
            labelText: 'Password',
            helperText: '',
            errorText: state.password.invalid ? 'Invalid password' : null,
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : Container(
                width: 200,
                child: ElevatedButton(
                  key: const Key('loginForm_continue_raisedButton'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    primary: Colors.blue,
                  ),
                  child: Text(
                    'LOG IN',
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: state.status.isValidated
                      ? () async {
                          await context
                              .read<LoginCubit>()
                              .logInWithCredentials();
                        }
                      : null,
                ),
              );
      },
    );
  }
}
