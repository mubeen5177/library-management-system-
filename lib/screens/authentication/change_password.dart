import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_management/components/custom_button.dart';
import 'package:library_management/extensions/build_context_extension.dart';
import 'package:library_management/screens/authentication/login_form.dart';
import 'package:library_management/utils/helper_function.dart';

import '../../components/custom_text_field.dart';
import '../../services/bloc/auth/change_password/change_password_bloc.dart';
import '../../utils/app_colors.dart';
import '../../utils/validation.dart';

class NewPassword extends StatefulWidget {
  NewPassword({
    Key? key,
  }) : super(key: key);

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();
  ChangePasswordBloc _newPassword = ChangePasswordBloc();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.red,
          title: Text("Change Password"),
          automaticallyImplyLeading: true,
        ),
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  context.sizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      "New Password",
                      style: TextStyle(color: AppColors.blackColor, fontWeight: FontWeight.normal, fontSize: 17),
                    ),
                  ),
                  CustomTextField(
                    textEditingController: _passwordController,
                    validator: Validation.validatePassword,
                    obscureText: true,
                    hintText: "Enter your password",
                    isFocused: true, // Set the focus state of the text field
                    onChanged: (value) {
                      // Handle text changes here
                      print('Text changed: $value');
                    },
                    onTap: () {
                      // Handle tap event here
                      print('Text field tapped');
                    },
                  ),
                  context.sizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      "Confirm Password",
                      style: TextStyle(color: AppColors.blackColor, fontWeight: FontWeight.normal, fontSize: 17),
                    ),
                  ),
                  CustomTextField(
                    textEditingController: _passwordConfirmController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password is required!';
                      }
                      return Validation.validateConfirmationPassword(_passwordController.text, value);
                    },
                    obscureText: true,
                    hintText: "Re-enter your password",
                    isFocused: true, // Set the focus state of the text field
                    onChanged: (value) {
                      // Handle text changes here
                      print('Text changed: $value');
                    },
                    onTap: () {
                      // Handle tap event here
                      print('Text field tapped');
                    },
                  ),
                  context.sizedBox(height: 15),
                  BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
                    bloc: _newPassword,
                    listener: (context, state) {
                      if (state is NewPasswordSuccess) {
                        setLoggedStatus(false);
                        context.pushAndRemoveUntil(LoginForm());
                        const snackBar = SnackBar(
                          content: Text("Password changed!"),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      if (state is NewPasswordFailure) {
                        final snackBar = SnackBar(
                          content: Text(state.message),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    builder: (context, state) {
                      return DynamicGradientButton(
                        isLoading: state is NewPasswordLoading,
                        fontWeight: FontWeight.bold,
                        height: 60,
                        width: double.infinity,
                        text: 'Change Password',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _newPassword.add(ChangeUserPassword(password: _passwordController.text));
                          }
                        },
                      );
                    },
                  ),
                  context.sizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
