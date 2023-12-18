import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_management/components/custom_button.dart';
import 'package:library_management/components/custom_text_field.dart';
import 'package:library_management/extensions/build_context_extension.dart';
import 'package:library_management/extensions/widget_extension.dart';
import 'package:library_management/screens/authentication/forgot_password.dart';
import 'package:library_management/screens/authentication/registeration_form.dart';
import 'package:library_management/screens/students/dashboard.dart';
import 'package:library_management/services/bloc/auth/login/login_bloc.dart';
import 'package:library_management/utils/helper_function.dart';

import '../../utils/app_colors.dart';
import '../../utils/validation.dart';

class LoginForm extends StatefulWidget {
  LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  LoginBloc _bloc = LoginBloc();

  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  late TapGestureRecognizer _gestureRecognizer;

  @override
  void initState() {
    _gestureRecognizer = TapGestureRecognizer()..onTap = _handlePress;

    super.initState();
  }

  void _handlePress() {
    // Single tapped.
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (BuildContext context) => RegisterationForm(),
      ),
    );
  }

  @override
  void dispose() {
    _gestureRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Container(
          height: 60,
          child: Center(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey.shade400,
                  fontFamily: "Poppins",
                ),
                children: [
                  TextSpan(
                    text: "Don't have an account? ",
                  ),
                  TextSpan(
                    recognizer: _gestureRecognizer,
                    text: ' Register ',
                    style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold, color: AppColors.blackColor),
                  ),
                ],
              ),
            ),
          ),
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
                  context.sizedBox(height: 53),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
                    child: Text(
                      "Welcome to UOL Library",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.blackColor, fontWeight: FontWeight.normal, fontSize: 37),
                    ),
                  ).center,
                  context.sizedBox(height: 23),
                  context.sizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      "Email",
                      style: TextStyle(color: AppColors.blackColor, fontWeight: FontWeight.normal, fontSize: 17),
                    ),
                  ),
                  CustomTextField(
                    textEditingController: _emailController,
                    validator: Validation.validateEmail,
                    hintText: "Enter your email",
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
                      "Password",
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
                  context.sizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (BuildContext context) => const ForgotPassword(),
                            ),
                          );
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(color: AppColors.red, fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  context.sizedBox(height: 25),
                  BlocConsumer<LoginBloc, LoginState>(
                    bloc: _bloc,
                    listener: (context, state) {
                      if (state is LoginSuccess) {
                        setLoggedStatus(true);
                        context.pushAndRemoveUntil(Dashboard());
                        final snackBar = SnackBar(
                          content: Text("Login Success!"),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      if (state is LoginAdminSuccess) {
                        setLoggedStatus(true);
                        context.pushAndRemoveUntil(Dashboard());
                        final snackBar = SnackBar(
                          content: Text("Login Success!"),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      if (state is LoginFailure) {
                        final snackBar = SnackBar(
                          content: Text(state.message),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    builder: (context, state) {

                        return DynamicGradientButton(
                          isLoading:state is LoginLoading ,
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            fontWeight: FontWeight.bold,
                            height: 60,
                            width: double.infinity,
                            text: 'Login',
                            onPressed: () async {
                              _bloc.add(LoginUser(email: _emailController.text.toLowerCase(), password: _passwordController.text.toLowerCase()));
                            });

                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
