part of 'register_bloc.dart';

@immutable
abstract class RegisterEvent {}

class RegisterStudent extends RegisterEvent {
  String stdID;
  String fullName;
  String email;
  String phone;
  String password;
   RegisterStudent({required this.email, required this.fullName, required this.password, required this.phone, required this.stdID});
}
