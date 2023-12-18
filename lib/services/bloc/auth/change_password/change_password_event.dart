part of 'change_password_bloc.dart';

@immutable
abstract class ChangePasswordEvent {}

class ChangeUserPassword extends ChangePasswordEvent {
  String password;
  ChangeUserPassword({required this.password});
}
