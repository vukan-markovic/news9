import 'package:firebase_auth/firebase_auth.dart';

class Category {
  int id;
  final String title;
  String uid;

  Category(this.title);

  map() {
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['title'] = this.title;
    map['uid'] = FirebaseAuth.instance.currentUser?.uid ??
        "wOJ3BsX5EnNgFAZYvPeGdK3TCVf2"; //adamrumunce@gmail.com uid added for testing purposes
    return map;
  }
}
