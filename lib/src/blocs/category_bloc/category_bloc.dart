import 'package:news/src/models/category.dart';
import 'package:news/src/resources/category_repository.dart';
import 'package:rxdart/rxdart.dart';

class CategoryBloc {
  final _categoryRepository = CategoryRepository();
  final _categoryFetches = PublishSubject<List<String>>();

  Stream<List<String>> get selectedCategories => _categoryFetches.stream;

  insetCategoryList(List<String> data) {
    data.forEach((element) {
      insertCategory(Category(element));
    });
  }

  insertCategory(Category category) async {
    _categoryRepository.insertCategory('selected_category', category.map());
  }

  deleteCategoriesByUid(String uid) async {
    _categoryRepository.deleteCategoriesByUid(uid);
  }

  getAllCategories() async {
    List<String> categories = [];
    var response =
        await _categoryRepository.getAllCategories('selected_category');
    response.forEach((category) {
      categories.add(category['title']);
    });
    return categories;
    // _categoryFetches.sink.add(categories);
  }

  dispose() {
    _categoryFetches.close();
  }
}

final categoryBloc = CategoryBloc();
