import 'package:hive/hive.dart';

class CategoryRepository {
  final String key = "category";

  insertCategory(data) async {
    var box = await Hive.openBox('category');
    box.put(key, data);
  }

  deleteCategories() async {
    var box = await Hive.openBox('category');
    box.delete(key);
  }

  getAllCategories() async {
    var box = await Hive.openBox('category');
    List<String> categories = box.get(key);
    box.close();
    return categories;
  }
}
