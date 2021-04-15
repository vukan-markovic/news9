import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:news/src/App.dart';
import 'package:news/src/models/article/article_model.dart';
import 'package:news/src/models/category/category.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news/src/models/user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = BlocObserver();

  await Hive.initFlutter();
  Hive..registerAdapter(AppUserAdapter())
    ..registerAdapter(CategoryAdapter())
    ..registerAdapter(ArticleAdapter());
  await Hive.openBox<AppUser>('user');
  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = BlocObserver();

  runApp(App());
}
