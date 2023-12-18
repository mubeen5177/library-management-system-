import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:library_management/screens/authentication/login_form.dart';
import 'package:library_management/screens/students/dashboard.dart';
import 'package:library_management/screens/welcome_screen.dart';
import 'package:library_management/utils/app_colors.dart';
import 'package:library_management/utils/user_session.dart';

import 'screens/authentication/registeration_form.dart';
import 'screens/students/profile/profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool logged = await UserSession.isLoggedIn();
  await Firebase.initializeApp();
  runApp(MyApp(
    loggedIn: logged,
  ));
}

class MyApp extends StatelessWidget {
  final bool loggedIn;

  const MyApp({super.key, required this.loggedIn});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',

      theme: customTheme,
      home: loggedIn ? Dashboard() : LoginForm(),
    );
  }
}

ThemeData customTheme = ThemeData(
  fontFamily: 'Montserrat-Regular',
  primaryColor: AppColors.red,
  secondaryHeaderColor: Colors.white,
  // Add more theme properties as needed
);
