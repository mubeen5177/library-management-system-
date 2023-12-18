import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:library_management/components/custom_button.dart';
import 'package:library_management/components/custom_text_field.dart';
import 'package:library_management/extensions/build_context_extension.dart';
import 'package:library_management/extensions/widget_extension.dart';
import 'package:library_management/screens/authentication/login_form.dart';
import 'package:library_management/utils/app_colors.dart';
import 'package:library_management/utils/validation.dart';

import '../../utils/helper_function.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late TapGestureRecognizer _gestureRecognizer;
  bool isLoading = false;

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

  TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: InkWell(
                onTap: () {
                  context.pop();
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                )),
            backgroundColor: AppColors.red,
            title: Text("Forgot Password "),
          ),
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    context.sizedBox(height: 40),
                    Text(
                      "Enter your Email address",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 32),
                    ).center,
                    context.sizedBox(height: 40),
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
                      isFocused: true,
                      // Set the focus state of the text field
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
                    DynamicGradientButton(
                        isLoading: isLoading,
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        fontWeight: FontWeight.bold,
                        height: 60,
                        width: double.infinity,
                        text: 'Reset Password',
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          await sendPasswordResetEmail(_emailController.text).then((value) {
                            const snackBar = SnackBar(
                              content: Text("Reset link sent to email!"),
                            );
                            context.pushAndRemoveUntil(LoginForm());
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            setState(() {
                              isLoading = false;
                            });
                          }).onError((error, stackTrace) {
                            const snackBar = SnackBar(
                              content: Text("An error occurred!"),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            setState(() {
                              isLoading = false;
                            });
                          });
                        }),
                    context.sizedBox(height: 20),
                    Divider(
                      color: AppColors.red,
                      endIndent: 30,
                      indent: 30,
                    ),
                    context.sizedBox(height: 10),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey.shade400,
                            fontFamily: "Poppins",
                          ),
                          children: [
                            TextSpan(
                              text: 'Remember password? ',
                            ),
                            TextSpan(
                              recognizer: _gestureRecognizer,
                              text: 'Login ',
                              style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold, color: AppColors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                    context.sizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
