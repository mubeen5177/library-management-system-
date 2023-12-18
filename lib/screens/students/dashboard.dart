import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:library_management/extensions/build_context_extension.dart';
import 'package:library_management/extensions/widget_extension.dart';
import 'package:library_management/models/student_model.dart';
import 'package:library_management/screens/admin/add_author/add_author.dart';
import 'package:library_management/screens/admin/search_students/search_students.dart';
import 'package:library_management/screens/authentication/login_form.dart';
import 'package:library_management/screens/students/profile/profile.dart';
import 'package:library_management/screens/students/settings/settings.dart';
import 'package:library_management/screens/students/view_issued_books/view_issued_books.dart';
import 'package:library_management/utils/app_colors.dart';
import 'package:library_management/utils/user_session.dart';

import '../../utils/helper_function.dart';
import '../admin/add_books/add_books.dart';
import '../admin/add_category/add_category.dart';
import 'view_available_books/view_available_books.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String role = '';
  bool loading = true;
  String imageUrl = '';
  String name = '';
  String email = '';
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2));
    getUser();
    super.initState();
  }

  getUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    String uid = user!.uid; // Replace with the user's actual UID
    DocumentSnapshot<Map<String, dynamic>>? userData = await getUserData(uid);

    if (userData != null) {
      // userDetails= userData;
      // print("userDetails are ${userDetails[role]}");
      print(userData['role']);
      name = userData['displayName'];
      email = userData['email'];
      imageUrl = userData['photoUrl'];
      setState(() {
        loading = false;
        role = userData['role'];
      });
      // Access user data here
      Map<String, dynamic> data = userData.data()!;

      UserSession.setUserData(data);
    } else {
      // Handle the case where the user does not exist
      print('User not found.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.red,
              ),
              accountName: Text(name),
              accountEmail: Text(email),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(imageUrl.isNotEmpty
                    ? imageUrl
                    : "https://images.pexels.com/photos/15261263/pexels-photo-15261263/free-photo-of-woman-looking-from-behind-tree.jpeg?auto=compress&cs=tinysrgb&w=800&lazy=load"),
              ),
            ),
            role == 'student' ? StudentTiles() : AdminTiles(),
            // Add more list tiles here
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: AppColors.red,
        title: Text("Dashboard"),
      ),
      body: loading
          ? CircularProgressIndicator(
              color: Colors.red,
            ).center
          : SingleChildScrollView(
              child: Column(
                children: [
                  context.sizedBox(height: 50),
                  role == 'student' ? StudentDashboard() : AdminDashboard(),
                ],
              ),
            ),
    );
  }

  Widget AdminTiles() {
    return Column(
      children: [
        ListTile(
          leading: Image.asset(
            "assets/menu.png",
            height: 20,
            width: 20,
          ),
          title: Text('Total Categories'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            context.push(CategoryScreen());
          },
        ),
        ListTile(
          leading: Image.asset(
            "assets/writer.png",
            height: 20,
            width: 20,
          ),
          title: Text('Total Authors'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            context.push(AuthorScreen());
          },
        ),
        ListTile(
          leading: Image.asset(
            "assets/add_book.png",
            height: 20,
            width: 20,
          ),
          title: Text('Total Books'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            context.push(BooksScreen());
          },
        ),
        ListTile(
          leading: Image.asset(
            "assets/search.png",
            height: 20,
            width: 20,
          ),
          title: Text('Search Students'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            context.push(StudentSearchList());
          },
        ),
        ListTile(
          leading: Image.asset(
            "assets/logout.png",
            height: 20,
            width: 20,
          ),
          title: Text('Logout'),
          onTap: () async {
            await signOutUser().then((value) {
              context.pushAndRemoveUntil(LoginForm());
            }).onError((error, stackTrace) {
              const snackBar = SnackBar(
                content: Text("An error occurred!"),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            });
          },
        ),
      ],
    );
  }

  Widget StudentTiles() {
    return Column(
      children: [
        ListTile(
          leading: Image.asset(
            "assets/books.png",
            height: 20,
            width: 20,
          ),
          title: Text('View Available Books'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            context.push(ViewAvailableBooks());
          },
        ),
        ListTile(
          leading: Image.asset(
            "assets/issued.png",
            height: 20,
            width: 20,
          ),
          title: Text('View Issued Books'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            context.push(ViewIssuedBooks());
          },
        ),
        ListTile(
          leading: Image.asset(
            "assets/edit.png",
            height: 20,
            width: 20,
          ),
          title: Text('My Profile'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            context.push(ProfileScreen());
          },
        ),
        ListTile(
          leading: Image.asset(
            "assets/settings.png",
            height: 20,
            width: 20,
          ),
          title: Text('Settings'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            context.push(SettingsScreen());
          },
        ),
      ],
    );
  }
}

class StudentDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      // alignment: WrapAlignment.center,
      // spacing: 10.0,
      // runSpacing: 6.5,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GridTile(
              child: InkWell(
                onTap: () {
                  context.push(ViewAvailableBooks());
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 230,
                  width: 150,
                  margin: EdgeInsets.all(12),
                  padding: EdgeInsets.all(12),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'View Available Books',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 24),
                      ),
                      context.sizedBox(height: 10),
                      Image.asset(
                        "assets/books.png",
                        height: 60,
                        width: 60,
                      )
                    ],
                  ),
                ),
              ),
            ),
            GridTile(
              child: InkWell(
                onTap: () {
                  context.push(ViewIssuedBooks());
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 230,
                  width: 150,
                  margin: EdgeInsets.all(12),
                  padding: EdgeInsets.all(12),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'View Issued Books',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 24),
                      ),
                      context.sizedBox(height: 10),
                      Image.asset(
                        "assets/issued.png",
                        height: 60,
                        width: 60,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GridTile(
              child: InkWell(
                onTap: () {
                  context.push(ProfileScreen());
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 230,
                  width: 150,
                  margin: EdgeInsets.all(12),
                  padding: EdgeInsets.all(12),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'My Profile',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 24),
                      ),
                      context.sizedBox(height: 10),
                      Image.asset(
                        "assets/edit.png",
                        height: 60,
                        width: 60,
                      )
                    ],
                  ),
                ),
              ),
            ),
            GridTile(
              child: InkWell(
                onTap: () {
                  context.push(SettingsScreen());
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 230,
                  width: 150,
                  margin: EdgeInsets.all(12),
                  padding: EdgeInsets.all(12),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Settings',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 24),
                      ),
                      context.sizedBox(height: 10),
                      Image.asset(
                        "assets/settings.png",
                        height: 60,
                        width: 60,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      // alignment: WrapAlignment.center,
      // spacing: 10.0,
      // runSpacing: 6.5,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GridTile(
              child: InkWell(
                onTap: () {
                  context.push(CategoryScreen());
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 230,
                  width: 150,
                  margin: EdgeInsets.all(12),
                  padding: EdgeInsets.all(12),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Total Categories',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.black, fontSize: 24),
                      ),
                      context.sizedBox(height: 10),
                      Image.asset(
                        "assets/menu.png",
                        height: 50,
                        width: 50,
                      )
                    ],
                  ),
                ),
              ),
            ),
            GridTile(
              child: InkWell(
                onTap: () {
                  context.push(AuthorScreen());
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 230,
                  width: 150,
                  margin: EdgeInsets.all(12),
                  padding: EdgeInsets.all(12),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Total Authors',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 24),
                      ),
                      context.sizedBox(height: 10),
                      Image.asset(
                        "assets/writer.png",
                        height: 60,
                        width: 60,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GridTile(
              child: InkWell(
                onTap: () {
                  context.push(BooksScreen());
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 230,
                  width: 150,
                  margin: EdgeInsets.all(12),
                  padding: EdgeInsets.all(12),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Total Books',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 24),
                      ),
                      context.sizedBox(height: 10),
                      Image.asset(
                        "assets/add_book.png",
                        height: 60,
                        width: 60,
                      )
                    ],
                  ),
                ),
              ),
            ),
            GridTile(
              child: InkWell(
                onTap: () {
                  context.push(StudentSearchList());
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 230,
                  width: 150,
                  margin: EdgeInsets.all(12),
                  padding: EdgeInsets.all(12),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Search Students',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 24),
                      ),
                      context.sizedBox(height: 10),
                      Image.asset(
                        "assets/search.png",
                        height: 60,
                        width: 60,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GridTile(
              child: InkWell(
                onTap: () async {
                  await signOutUser().then((value) {
                    context.pushAndRemoveUntil(LoginForm());
                  }).onError((error, stackTrace) {
                    const snackBar = SnackBar(
                      content: Text("An error occurred!"),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 235,
                  width: 175,
                  margin: EdgeInsets.all(12),
                  padding: EdgeInsets.all(12),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Logout',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 24),
                      ),
                      context.sizedBox(height: 10),
                      Image.asset(
                        "assets/logout.png",
                        height: 60,
                        width: 60,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
