import 'package:flutter/material.dart';
import 'package:library_management/extensions/build_context_extension.dart';
import 'package:library_management/extensions/widget_extension.dart';
import 'package:library_management/utils/app_colors.dart';
import 'package:library_management/utils/helper_function.dart';

class StudentDetails extends StatefulWidget {
  String stdId;
  StudentDetails({super.key, required this.stdId});

  @override
  State<StudentDetails> createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  bool loading = true;
  @override
  void initState() {
    getStudentsDetails();
    super.initState();
  }

  List<Map<String, dynamic>> data = [];
  getStudentsDetails() async {
    data = await getDataByField("users", "studentId", widget.stdId);
    setState(() {
      loading = false;
    });
    print("data is $data");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Student Details"),
        backgroundColor: AppColors.red,
      ),
      body: loading
          ? const CircularProgressIndicator(
              color: AppColors.red,
            ).center
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                context.sizedBox(height: 20),
                CircleAvatar(
                  radius: 70.0,
                  backgroundImage: NetworkImage(data[0]["photoUrl"] ?? 'https://nextluxury.com/wp-content/uploads/funny-profile-pictures-2.jpg'), // Replace with your image asset
                ).center,
                ListTile(
                  title: Text("Full Name"),
                  subtitle: Text(data[0]["displayName"].toString()),
                ),
                ListTile(
                  title: Text("Email"),
                  subtitle: Text(data[0]["email"].toString()),
                ),
                ListTile(
                  title: Text("Address"),
                  subtitle: Text(data[0]["address"].toString()),
                ),
                ListTile(
                  title: Text("Phone Number"),
                  subtitle: Text(data[0]["phone"].toString()),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                  child: Text(
                    "Books issued",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: data[0]["booksIssued"].length,
                    itemBuilder: (context, index) {
                      var booksIssued = data[0]["booksIssued"][index];
                      return Container(
                          margin: const EdgeInsets.all(12),
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
                            title: Text(booksIssued['bookName'].toString()),
                            isThreeLine: true,
                            subtitle: Text("Category: ${booksIssued['categoryName']}  Author: ${booksIssued['authorName']}"),
                          ));
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
