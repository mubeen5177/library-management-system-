import 'package:flutter/material.dart';

class AppColors {
  static const Color lightBlue = Color(0xffC3D8EE);
  static const Color lightPurple = Color(0xffE6E0E9);

  static const Color red = Colors.red;
  static const Color midRed = Colors.redAccent;

  static const Color disable = Color.fromARGB(255, 225, 221, 221);

  static Color hintColor = const Color(0xff3C3C43).withOpacity(0.4);
  static Color opacWhiteColor = Colors.white.withOpacity(0.5);
  static Color blackColor = const Color(0xff000000);

  static const Gradient gradientColor = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.topRight,
    stops: const [0, 1],
    colors: [Colors.red, Colors.redAccent],
  );

  static Gradient gradientColorWithOpacity = LinearGradient(
    colors: [
      red.withOpacity(0.9), // Update opacity here
      midRed.withOpacity(0.9),
    ],
    begin: Alignment(-0.30, -0.60),
    end: Alignment(3.4, -1),
  );
}
