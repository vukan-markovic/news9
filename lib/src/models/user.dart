import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class AppUser extends Equatable {
  const AppUser({
    @required this.email,
    @required this.id,
  });

  final String email;
  final String id;

  static const empty = AppUser(email: '', id: '');

  @override
  List<Object> get props => [email, id];
}
