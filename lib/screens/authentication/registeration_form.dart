import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_management/components/custom_button.dart';
import 'package:library_management/components/custom_text_field.dart';
import 'package:library_management/extensions/build_context_extension.dart';
import 'package:library_management/extensions/widget_extension.dart';
import 'package:library_management/screens/authentication/login_form.dart';
import 'package:library_management/screens/students/dashboard.dart';
import 'package:library_management/services/bloc/auth/register/register_bloc.dart';
import 'package:library_management/utils/app_colors.dart';
import 'package:library_management/utils/helper_function.dart';
import 'package:library_management/utils/validation.dart';

class RegisterationForm extends StatefulWidget {
  RegisterationForm({Key? key}) : super(key: key);

  @override
  State<RegisterationForm> createState() => _RegisterationFormState();
}

class _RegisterationFormState extends State<RegisterationForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController(text: '+92');
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
        builder: (BuildContext context) => LoginForm(),
      ),
    );
  }

  @override
  void dispose() {
    _gestureRecognizer.dispose();
    super.dispose();
  }

  RegisterBloc _registerBloc = RegisterBloc();
  @override
  Widget build(BuildContext context) {
    final randomId = generateRandomId();
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
                    text: 'Already have an account! ',
                  ),
                  TextSpan(
                    recognizer: _gestureRecognizer,
                    text: 'Login ',
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
                      "Register Your Self",
                      style: TextStyle(color: AppColors.blackColor, fontWeight: FontWeight.normal, fontSize: 37),
                    ),
                  ).center,
                  context.sizedBox(height: 23),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      "Student ID",
                      style: TextStyle(color: AppColors.blackColor, fontWeight: FontWeight.normal, fontSize: 17),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.5,
                        )),
                    alignment: Alignment.centerLeft,
                    child: Text(randomId.toString()),
                  ),
                  context.sizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      "Full Name",
                      style: TextStyle(color: AppColors.blackColor, fontWeight: FontWeight.normal, fontSize: 17),
                    ),
                  ),
                  CustomTextField(
                    maxLength: 20,
                    textEditingController: _nameController,
                    validator: Validation.validateString,
                    hintText: "Enter your Name",
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
                      "Phone number",
                      style: TextStyle(color: AppColors.blackColor, fontWeight: FontWeight.normal, fontSize: 17),
                    ),
                  ),
                  CustomTextField(
                    maxLength: 13,

                    textEditingController: _phoneController,
                    // inputFormatters: [PakistaniPhoneNumberFormatter()],
                    validator: Validation.isValidPakistanPhoneNumber,
                    hintText: "+923000000000",
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
                  context.sizedBox(height: 25),
                  BlocConsumer<RegisterBloc, RegisterState>(
                    bloc: _registerBloc,
                    listener: (context, state) {
                      if (state is RegisterSuccess) {
                        setLoggedStatus(true);
                        context.pushAndRemoveUntil(Dashboard());
                        final snackBar = SnackBar(
                          content: Text('User Registered Successfully!'),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      if (state is RegisterFailure) {
                        final snackBar = SnackBar(
                          content: Text(state.message),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    builder: (context, state) {
                      return DynamicGradientButton(
                          isLoading: state is RegisterLoading,
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          fontWeight: FontWeight.bold,
                          height: 60,
                          width: double.infinity,
                          text: 'Register',
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _registerBloc.add(
                                  RegisterStudent(email: _emailController.text, fullName: _nameController.text, password: _passwordController.text, phone: _phoneController.text, stdID: randomId));
                            }
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
