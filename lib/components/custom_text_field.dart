import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:library_management/utils/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final bool isFocused;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  bool? enabled;
  int? maxLength;
  final bool obscureText;
  List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final TextEditingController? textEditingController;

  CustomTextField({
    this.isFocused = false,
    this.maxLength,
    this.obscureText = false,
    this.hintText,
    this.enabled=true,
    this.inputFormatters,
    this.textEditingController,
    this.validator,
    this.onChanged,
    this.onTap,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: TextFormField(
        enabled: widget.enabled,
        maxLength: widget.maxLength,
        inputFormatters: widget.inputFormatters,
        controller: widget.textEditingController,
        obscureText: widget.obscureText ? _obscureText : false,
        validator: widget.validator,
        decoration: InputDecoration(
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
          contentPadding: EdgeInsets.all(16.0),
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.red,
              width: 1.5,
            ),
          ),
          focusedErrorBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.red,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: AppColors.red,
              width: 1.5,
            ),
          ),
        ),
        onChanged: widget.onChanged,
        onTap: widget.onTap,
      ),
    );
  }
}
