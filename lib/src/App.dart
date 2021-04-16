import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/src/resources/user_repository.dart';
import 'package:news/src/ui/login/login_page.dart';
import 'package:news/src/ui/navigation_screen.dart';
import 'package:news/src/ui/splash_page.dart';
import 'blocs/authentication_bloc/authentication_bloc.dart';
import 'blocs/change_theme_bloc/bloc/change_theme_bloc.dart';
import 'ui/login/login_page.dart';

class App extends StatelessWidget {
  final AuthenticationRepository authenticationRepository =
  AuthenticationRepository();

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
        ),
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChangeThemeBloc()..onDecideThemeChange(),
      child: BlocBuilder<ChangeThemeBloc, ChangeThemeState>(
        builder: (context, state) {
          return MaterialApp(
            theme: state.themeData,
            navigatorKey: _navigatorKey,
            builder: (context, child) {
              return BlocListener<AuthenticationBloc, AuthenticationState>(
                listener: (context, state) {
                  switch (state.status) {
                    case AuthenticationStatus.authenticated:
                      _navigator.pushAndRemoveUntil<void>(
                        NavigationScreen.route(),
                            (route) => false,
                      );
                      break;
                    case AuthenticationStatus.unauthenticated:
                      _navigator.pushAndRemoveUntil<void>(
                        LoginPage.route(),
                            (route) => false,
                      );
                      break;
                    default:
                      break;
                  }
                },
                child: child,
              );
            },
            onGenerateRoute: (_) => SplashPage.route(),
          );
        },
      ),
    );
  }
}