import 'package:flutter/foundation.dart';
import 'package:news/src/resources/category_repository.dart';
import 'package:rxdart/rxdart.dart';

class CategoryBloc {
  final _categoryRepository = CategoryRepository();
  final _categoryFetches = PublishSubject<List<String>>();

  Stream<List<String>> get selectedCategories => _categoryFetches.stream;

  insetCategoryList(List<String> data) {
    _categoryRepository.insertCategory(data);
  }

  insertCategory(Category category) async {
    _categoryRepository.insertCategory(category);
  }

  deleteCategoriesByUid(String uid) async {
    _categoryRepository.deleteCategoriesByUid();
  }

  getAllCategories() async {
    return await _categoryRepository.getAllCategories();
  }

  dispose() {
    _categoryFetches.close();
  }
}

final categoryBloc = CategoryBloc();
