import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class AppUser extends Equatable {
  const AppUser({
    @required this.email,
    @required this.id,
    @required this.firstName,
    @required this.lastName,
    @required this.dateOfBirth,
    @required this.gender,
  });

  final String email;
  final String id;
  final String firstName;
  final String lastName;
  final String dateOfBirth;
  final String gender;

  static const empty = AppUser(
    email: '',
    id: '',
    firstName: '',
    lastName: '',
    dateOfBirth: '',
    gender: '',
  );

  @override
  List<Object> get props =>
      [email, id, firstName, lastName, dateOfBirth, gender];
}
