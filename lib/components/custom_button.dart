import 'package:flutter/material.dart';
import 'package:library_management/extensions/widget_extension.dart';
import 'package:library_management/utils/app_colors.dart';

class DynamicGradientButton extends StatelessWidget {
  final String text;
  double? width;
  double height;
  final bool isLoading;
  FontWeight? fontWeight;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color textColor;
  final Color? loaderColor;
  final Color? borderColor;
  final EdgeInsetsGeometry? margin;

  DynamicGradientButton({
    Key? key,
    required this.text,
    this.backgroundColor,
    this.loaderColor,
    this.isLoading = false,
    this.margin,
    this.borderColor,
    this.fontWeight,
    this.width,
    required this.height,
    required this.onPressed,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.all(15),
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor,
        gradient: backgroundColor == null ? AppColors.gradientColor : null,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: isLoading
          ? CircularProgressIndicator(
        color: loaderColor ?? Colors.white,
      ).center
          : ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          side: BorderSide(
            color: borderColor ?? Colors.transparent,
          ),
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          primary: Colors.transparent,
          onPrimary: Colors.transparent,
          elevation: 0,
        ),
        child: Container(
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 16.0,
              fontWeight: fontWeight ?? FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
