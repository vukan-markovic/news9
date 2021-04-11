import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class AppUser extends Equatable {
  const AppUser({
    @required this.email,
    @required this.id,
    @required this.emailVerified,
  });

  final String email;
  final String id;
  final bool emailVerified;

  static const empty = AppUser(email: '', id: '', emailVerified: false);

  @override
  List<Object> get props => [email, id, emailVerified];
}
