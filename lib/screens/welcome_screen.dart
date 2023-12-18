// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:library_management/components/custom_button.dart';
// import 'package:library_management/extensions/build_context_extension.dart';
// import 'package:library_management/screens/authentication/login_form.dart';
// import 'package:library_management/screens/authentication/registeration_form.dart';
// import 'package:library_management/utils/app_colors.dart';
//
// class WelcomeScreen extends StatelessWidget {
//   WelcomeScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 context.sizedBox(height: 75),
//                 Image.asset(
//                   "assets/lin.png",
//                   width: context.width,
//                   height: context.height - 400,
//                 ),
//                 context.sizedBox(height: 80),
//                 DynamicGradientButton(
//                     margin: EdgeInsets.symmetric(horizontal: 15),
//                     fontWeight: FontWeight.bold,
//                     height: 60,
//                     width: double.infinity,
//                     text: 'Login',
//                     onPressed: () async {
//                       Navigator.pushAndRemoveUntil(
//                           context,
//                           CupertinoPageRoute(
//                             builder: (BuildContext context) =>   LoginForm(),
//                           ),
//                           (Route<dynamic> route) => false);
//                     }),
//                 DynamicGradientButton(
//                     borderColor: AppColors.red,
//                     fontWeight: FontWeight.bold,
//                     backgroundColor: Colors.white,
//                     height: 60,
//                     textColor: AppColors.red,
//                     width: double.infinity,
//                     text: 'Register',
//                     onPressed: () {
//                       Navigator.pushAndRemoveUntil(
//                           context,
//                           CupertinoPageRoute(
//                             builder: (BuildContext context) =>   RegisterationForm(),
//                           ),
//                           (Route<dynamic> route) => false);
//                     }),
//                 context.sizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
