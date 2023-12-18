import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_management/components/custom_text_field.dart';
import 'package:library_management/extensions/build_context_extension.dart';
import 'package:library_management/utils/app_colors.dart';
import 'package:library_management/utils/helper_function.dart';
import 'package:library_management/utils/validation.dart';

import '../../../components/custom_button.dart';

class AuthorScreen extends StatefulWidget {
  @override
  _AuthorScreenState createState() => _AuthorScreenState();
}

class _AuthorScreenState extends State<AuthorScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _authorController = TextEditingController();

  List<String> _authors = [];

  @override
  void initState() {
    super.initState();

    _getAuthors();
  }

  void _getAuthors() async {
    final snapshot = await _firestore.collection('authors').get();

    setState(() {
      _authors = snapshot.docs.map((doc) => doc['authorName'].toString()).toList();
    });
  }

  void _addAuthors() {
    showModalBottomSheet(
      context: context,
      builder: (context) => AddCategoryBottomSheet(onAddCategory: (authorname) async {
        final authorName = authorname;

        if (authorName.isEmpty) {
          return;
        }

        bool isExist = await doesExist(value: _authorController.text.trim(), key: "authorName", collection: "authors");

        if (isExist) {
          const snackBar = SnackBar(
            content: Text("Author Already exists!"),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          await _firestore.collection('authors').add({'authorName': authorName.trim()}).then((value) {
            const snackBar = SnackBar(
              content: Text("Author Added Successfully!"),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }).onError((error, stackTrace) {});

          setState(() {
            _authors.add(authorName);
            _authorController.clear();
          });
        }
      }),
    );
  }

  _editCategory(String currentAuthor) {
    showModalBottomSheet(
      context: context,
      builder: (context) => AddCategoryBottomSheet(onAddCategory: (authorname) async {
        final authorName = authorname;

        if (authorName.isEmpty) {
          return;
        }

        await updateAuthorName(newAuthorName: authorName, currentAuthorName: currentAuthor).then((value) {
          print("Author list is ${_authors}");

          int index = _authors.indexOf(currentAuthor.trim());

          print("index is $index");
          if (index >= 0 && index < _authors.length) {
            setState(() {
              _authors[index] = authorName;
            });
          } else {
            // Handle the case where the index is out of bounds
            print('Index is out of bounds.');
          }
        }) /*.onError((error, stackTrace) {
          const snackBar = SnackBar(
            content: Text("An error occurred!"),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        })*/
            ;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: InkWell(
        onTap: _addAuthors,
        child: CircleAvatar(
          radius: 30,
          backgroundColor: AppColors.red,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Author'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _authors.length,
              itemBuilder: (context, index) {
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            _editCategory(_authors[index]);
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await deleteRecordsFromCollectionWhere(collectionPath: "authors", value: _authors[index],key: "authorName");
                            setState(() {
                              _authors.removeWhere((element) => element == _authors[index]);
                            });
                          },
                          icon: Icon(
                            Icons.delete,
                            color: AppColors.red,
                          ),
                        ),
                      ],
                    ),
                    title: Text(_authors[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AddCategoryBottomSheet extends StatefulWidget {
  final Function(String) onAddCategory;

  const AddCategoryBottomSheet({Key? key, required this.onAddCategory}) : super(key: key);

  @override
  _AddCategoryBottomSheetState createState() => _AddCategoryBottomSheetState();
}

class _AddCategoryBottomSheetState extends State<AddCategoryBottomSheet> {
  final _categoryController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CustomTextField(
            textEditingController: _categoryController,
            validator: Validation.validateString,
            obscureText: false,
            hintText: 'Enter category name',
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
          Expanded(child: SizedBox()),
          DynamicGradientButton(
            isLoading: loading,
            margin: EdgeInsets.symmetric(horizontal: 15),
            fontWeight: FontWeight.bold,
            height: 60,
            width: double.infinity,
            text: 'Add Category',
            onPressed: () {
              widget.onAddCategory(_categoryController.text);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
