part of 'update_profile_bloc.dart';

@immutable
abstract class UpdateProfileState {}

class UpdateProfileInitial extends UpdateProfileState {}

class UpdateProfileLoading extends UpdateProfileState {}

class UpdateProfileSuccess extends UpdateProfileState {}

class UpdateProfileFailure extends UpdateProfileState {
  String message;
  UpdateProfileFailure({required this.message});
}
