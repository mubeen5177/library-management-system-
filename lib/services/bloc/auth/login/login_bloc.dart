import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../../../utils/helper_function.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginUser>(_loginUser);
  }

  FutureOr<void> _loginUser(LoginUser event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      bool connection = await checkConnection();
      if (connection) {
        User? user = await signInWithEmailAndPassword(event.email, event.password);

        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
        if (userDoc.exists) {
          String role = userDoc['role'];
          if (role == 'student') {
            emit(LoginSuccess());
          } else {
            emit(LoginAdminSuccess());
          }
        }
      } else {
        emit(LoginFailure(message: "Please connect to internet!"));
      }
    } catch (e) {
      emit(LoginFailure(message: "An error occurred!"));
    }
  }
}
