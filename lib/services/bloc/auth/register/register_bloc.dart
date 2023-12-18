import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:library_management/utils/helper_function.dart';
import 'package:meta/meta.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterStudent>(_registerUser);
  }

  FutureOr<void> _registerUser(RegisterStudent event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());
    try {
      bool connection = await checkConnection();
      if (connection) {
        bool checkUserExists = await doesEmailExist(event.email);
        if (checkUserExists) {
          emit(RegisterFailure(message: "User already exist"));
        } else {
          await registerAndSaveUserData(email: event.email, password: event.password, displayName: event.fullName, stdId: event.stdID, phone: event.phone).then((value) {
            emit(RegisterSuccess());
          }).onError((error, stackTrace) {
            emit(RegisterFailure(message: "An Error occurred!"));
          });
        }
      } else {
        emit(RegisterFailure(message: "Please check internet connection"));
      }
    } catch (e) {
      emit(RegisterFailure(message: "An Error occurred!"));
    }
  }
}
