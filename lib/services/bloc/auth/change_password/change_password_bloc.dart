import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../utils/helper_function.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc() : super(NewPasswordInitial()) {
    on<ChangeUserPassword>(_changeuserPassword);
  }

  FutureOr<void> _changeuserPassword(ChangeUserPassword event, Emitter<ChangePasswordState> emit) async {
    emit(NewPasswordLoading());
    try {
      bool connection = await checkConnection();
      if (connection) {
        await changePassword(event.password).then((value) {
          emit(NewPasswordSuccess());
        }).onError((error, stackTrace) {
          emit(NewPasswordFailure(message: "An error Occurred!"));
        });
      } else {
        emit(NewPasswordFailure(message: "Please connect to internet!"));
      }
    } catch (e) {
      emit(NewPasswordFailure(message: "An error Occurred!"));
    }
  }
}
