import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class AppUser extends Equatable {
  const AppUser({
    @required this.email,
    this.id,
    @required this.firstName,
    @required this.lastName,
    @required this.dateOfBirth,
    @required this.gender,
  });

  @HiveField(0)
  final String email;

  final String id;

  @HiveField(1)
  final String firstName;

  @HiveField(2)
  final String lastName;

  @HiveField(3)
  final String dateOfBirth;

  @HiveField(4)
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
