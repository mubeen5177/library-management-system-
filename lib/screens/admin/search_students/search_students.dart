import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_management/components/custom_text_field.dart';
import 'package:library_management/extensions/build_context_extension.dart';
import 'package:library_management/screens/admin/search_students/student_details.dart';
import 'package:library_management/utils/validation.dart';

import '../../../utils/app_colors.dart';

class StudentSearchList extends StatefulWidget {
  @override
  _StudentSearchListState createState() => _StudentSearchListState();
}

class _StudentSearchListState extends State<StudentSearchList> {
  final _studentIdController = TextEditingController();
  Stream<QuerySnapshot>? _studentQuery;

  @override
  void initState() {
    super.initState();

    _studentIdController.addListener(() {
      setState(() {
        _studentQuery = FirebaseFirestore.instance.collection('users').where('studentId', isEqualTo: _studentIdController.text).snapshots();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.red,
        title: Text('Student Search List'),
      ),
      body: Column(
        children: [
          context.sizedBox(height: 20),
          CustomTextField(
            textEditingController: _studentIdController,
            validator: Validation.validateString,
            obscureText: false,
            hintText: 'Enter student ID to search',
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
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _studentQuery,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final students = snapshot.data!.docs;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                    child: ListView.builder(
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];

                        return Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade100,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5), // Shadow color
                                spreadRadius: 5, // Spread radius
                                blurRadius: 7, // Blur radius
                                offset: const Offset(0, 3), // Offset
                              ),
                            ],
                          ),
                          child: ListTile(
                            onTap: () {
                              context.push(StudentDetails(
                                stdId: student['studentId'],
                              ));
                            },
                            trailing: Text(student['studentId']),
                            title: Text(student['displayName']),
                            subtitle: Text(student['email']),
                          ),
                        );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
