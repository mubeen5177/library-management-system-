part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginAdminSuccess extends LoginState {}

class LoginFailure extends LoginState {
  String message;
  LoginFailure({required this.message});
}
