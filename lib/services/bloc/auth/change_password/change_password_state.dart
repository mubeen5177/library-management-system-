part of 'change_password_bloc.dart';

@immutable
abstract class ChangePasswordState {}

class NewPasswordInitial extends ChangePasswordState {}
class NewPasswordLoading extends ChangePasswordState {}
class NewPasswordSuccess extends ChangePasswordState {}
class NewPasswordFailure extends ChangePasswordState {
  String message;
  NewPasswordFailure({required this.message});
}
