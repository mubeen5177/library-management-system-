import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_management/components/custom_button.dart';
import 'package:library_management/components/custom_text_field.dart';
import 'package:library_management/extensions/build_context_extension.dart';
import 'package:library_management/services/bloc/profile_update/update_profile_bloc.dart';
import 'package:library_management/utils/app_colors.dart';
import 'package:library_management/utils/user_session.dart';
import 'package:library_management/utils/validation.dart';

import '../../../utils/helper_function.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _emailController = TextEditingController(text: "abc@xyz.com");

  TextEditingController _phoneController = TextEditingController(text: "+92");
  TextEditingController _addressController = TextEditingController(text: "");
  TextEditingController _fullnameController = TextEditingController(text: "");
  TextEditingController _studentidController = TextEditingController(text: "");
  final _formKey = GlobalKey<FormState>();
  var data;
  File? imageFile;

  String imageUrl = '';
  @override
  void initState() {
    updateDataToUI();
    super.initState();
  }

  Map<String, dynamic> userData = {};
  UpdateProfileBloc _updateProfileBloc = UpdateProfileBloc();
  updateDataToUI() async {
    data = await UserSession.getUserData();
    userData = jsonDecode(data);
    if (userData != null) {
      setState(() {
        _studentidController.text = userData['studentId'].toString();
        _addressController.text = userData['address'].toString();
        _phoneController.text = userData['phone'].toString();
        _fullnameController.text = userData['displayName'].toString();
        _emailController.text = userData['email'].toString();
        print("image is ${userData['photoUrl']}");
        imageUrl = userData['photoUrl'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocConsumer<UpdateProfileBloc, UpdateProfileState>(
          bloc: _updateProfileBloc,
          listener: (context, state) {
            if (state is UpdateProfileSuccess) {
              const snackBar = SnackBar(
                content: Text("Profile Updated!"),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
            if (state is UpdateProfileFailure) {
              final snackBar = SnackBar(
                content: Text(state.message),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          builder: (context, state) {
            return DynamicGradientButton(
                isLoading: state is UpdateProfileLoading,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                fontWeight: FontWeight.bold,
                height: 60,
                width: double.infinity,
                text: 'Update Profile',
                onPressed: () async {
                  _updateProfileBloc.add(UpdateUserProfile(photo: imageFile!, address: _addressController.text, phone: _phoneController.text, displayName: _fullnameController.text));
                });
          },
        ),
      ),
      appBar: AppBar(
        backgroundColor: AppColors.red,
        title: const Text("Profile Sceeen "),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                context.sizedBox(height: 30),
                ProfileAvatar(),
                context.sizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    "SAP ID",
                    style: TextStyle(color: AppColors.blackColor, fontWeight: FontWeight.normal, fontSize: 17),
                  ),
                ),
                CustomTextField(
                  enabled: false,
                  textEditingController: _studentidController,
                  validator: Validation.validateEmail,
                  hintText: "Enter your student id",
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
                  enabled: false,
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
                    "Phone Number",
                    style: TextStyle(color: AppColors.blackColor, fontWeight: FontWeight.normal, fontSize: 17),
                  ),
                ),
                CustomTextField(
                  enabled: true,
                  maxLength: 13,
                  textEditingController: _phoneController,
                  // inputFormatters: [PakistaniPhoneNumberFormatter()],
                  validator: Validation.isValidPakistanPhoneNumber,
                  hintText: "+920000000000",
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
                    "Full Name",
                    style: TextStyle(color: AppColors.blackColor, fontWeight: FontWeight.normal, fontSize: 17),
                  ),
                ),
                CustomTextField(
                  maxLength: 20,
                  enabled: true,
                  textEditingController: _fullnameController,
                  validator: Validation.validateString,
                  hintText: "Enter your name",
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
                    "Address",
                    style: TextStyle(color: AppColors.blackColor, fontWeight: FontWeight.normal, fontSize: 17),
                  ),
                ),
                CustomTextField(
                  enabled: true,
                  textEditingController: _addressController,
                  validator: Validation.isValidStreetAddress,
                  hintText: "Enter your address",
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget ProfileAvatar() {
    return Center(
      child: Stack(
        children: [
          // Circular Avatar Image
          imageFile == null
              ? CircleAvatar(
                  radius: 70.0,
                  backgroundImage: NetworkImage(imageUrl), // Replace with your image asset
                )
              : CircleAvatar(radius: 70.0, backgroundImage: FileImage(imageFile!)),
          // Edit Button
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    type: FileType.custom,
                    allowedExtensions: ['jpg', 'png', 'jpeg'],
                  );
                  if (result != null) {
                    print("extension is ${result.files.single.extension}");
                    if (result.files.single.extension == 'mp4') {
                      const snackBar = SnackBar(
                        content: Text("Please upload an image file"),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      File file = File(result.files.single.path!);

                      print("file is $file");
                      setState(() {
                        imageFile = file;
                      });
                    }
                  } else {
                    // User canceled the picker
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
