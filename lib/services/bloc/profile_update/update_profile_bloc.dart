import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:library_management/utils/helper_function.dart';
import 'package:meta/meta.dart';

import '../../../utils/user_session.dart';

part 'update_profile_event.dart';
part 'update_profile_state.dart';

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  UpdateProfileBloc() : super(UpdateProfileInitial()) {
    on<UpdateUserProfile>(_updateProfile);
  }

  FutureOr<void> _updateProfile(UpdateUserProfile event, Emitter<UpdateProfileState> emit) async {
    emit(UpdateProfileLoading());
    try {
      bool connection = await checkConnection();
      if (connection) {
        await updateUserProfile(
          photo: event.photo,
          displayName: event.displayName,
          address: event.address,
          phone: event.phone,
        ).then((value) async {
          User? user = FirebaseAuth.instance.currentUser;
          String uid = user!.uid; // Replace with the user's actual UID
          DocumentSnapshot<Map<String, dynamic>>? userData = await getUserData(uid);

          if (userData != null) {
            // Access user data here
            Map<String, dynamic> data = userData.data()!;
            UserSession.setUserData(data);
          } else {
            // Handle the case where the user does not exist
            print('User not found.');
          }
          emit(UpdateProfileSuccess());
        }).onError((error, stackTrace) {
          emit(UpdateProfileFailure(message: "An error occurred!"));
        });
      } else {
        emit(UpdateProfileFailure(message: "Please connect to internet"));
      }
    } catch (e) {
      emit(UpdateProfileFailure(message: "An error occurred!"));
    }
  }
}
