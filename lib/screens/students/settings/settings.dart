import 'package:flutter/material.dart';
import 'package:library_management/components/custom_button.dart';
import 'package:library_management/extensions/build_context_extension.dart';
import 'package:library_management/screens/authentication/login_form.dart';
import 'package:library_management/utils/app_colors.dart';

import '../../../utils/helper_function.dart';
import '../../authentication/change_password.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.red,
        title: Text("Settings"),
      ),
      body: ListView(
        children: [
          context.sizedBox(height: 20),
          _buildRow(
              title: "Change Password",
              onTap: () {
                context.push(NewPassword());
              }),
          _buildRow(
              title: "Log out",
              onTap: () async {
                await signOutUser().then((value) {
                  context.pushAndRemoveUntil(LoginForm());
                }).onError((error, stackTrace) {
                  const snackBar = SnackBar(
                    content: Text("An error occurred!"),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                });
              }),
          _buildRow(title: "Delete Account", toggleInitialVal: false, onChanged: (e) {}),
          context.sizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildRow({String? title, bool? toggleInitialVal, Function(bool)? onChanged, void Function()? onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 0.0, bottom: 15, left: 20, right: 20),
        height: 37,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title ?? "",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: AppColors.blackColor),
            ),
          ],
        ),
      ),
    );
  }
}
