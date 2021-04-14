import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:news/src/blocs/reset_password_bloc/reset_password_cubit.dart';
import 'package:news/src/blocs/reset_password_bloc/reset_password_state.dart';
import 'package:news/src/ui/login/login_page.dart';

import '../dialog.dart';

class ResetPasswordForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          AppDialog.showAppDialog(
            context: context,
            title: 'Incorrect email!',
            body: 'The email you entered are incorrect. Please try again.',
          );
        } else if (state.status.isSubmissionSuccess) {
          Navigator.of(context).pushReplacement(LoginPage.route());
          AppDialog.showAppDialog(
            context: context,
            title: 'Reset password email sent!',
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
                    'Reset password',
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
                _ResetPasswordButton(),
                SizedBox(height: 8.0),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pushReplacement(LoginPage.route()),
                  child: Text('Sign in'),
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
    return BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('resetPasswordForm_emailInput_textField'),
          onChanged: (email) =>
              context.read<ResetPasswordCubit>().emailChanged(email),
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

class _ResetPasswordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : Container(
                width: 200,
                child: ElevatedButton(
                  key: const Key('resetPasswordForm_continue_raisedButton'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    primary: Colors.blue,
                  ),
                  child: Text(
                    'Reset password',
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: state.status.isValidated
                      ? () async {
                          await context
                              .read<ResetPasswordCubit>()
                              .resetPassword();
                        }
                      : null,
                ),
              );
      },
    );
  }
}
