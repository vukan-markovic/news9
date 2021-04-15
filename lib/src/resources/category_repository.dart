import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

class CategoryRepository {
  final String uid =
      FirebaseAuth.instance.currentUser?.uid ?? "wOJ3BsX5EnNgFAZYvPeGdK3TCVf2";

  insertCategory(data) async {
    var box = await Hive.openBox('category');
    box.put(uid, data);
  }

  deleteCategoriesByUid() async {
    var box = await Hive.openBox('category');
    box.delete(uid);
  }

  getAllCategories() async {
    var box = await Hive.openBox('category');
    return box.get(uid);
  }
}
