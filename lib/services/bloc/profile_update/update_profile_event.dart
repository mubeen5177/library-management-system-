part of 'update_profile_bloc.dart';

@immutable
abstract class UpdateProfileEvent {}

class UpdateUserProfile extends UpdateProfileEvent {
  File photo;

  String displayName;

  String phone;
  String address;
  UpdateUserProfile({required this.photo, required this.address, required this.phone, required this.displayName});
}
