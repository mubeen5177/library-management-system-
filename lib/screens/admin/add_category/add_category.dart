import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_management/components/custom_text_field.dart';
import 'package:library_management/utils/app_colors.dart';
import 'package:library_management/utils/helper_function.dart';
import 'package:library_management/utils/validation.dart';

import '../../../components/custom_button.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _categoryController = TextEditingController();

  List<String> _categories = [];

  @override
  void initState() {
    super.initState();

    _getCategories();

  }

  void _getCategories() async {
    final snapshot = await _firestore.collection('categories').get();

    setState(() {
      _categories = snapshot.docs.map((doc) => doc['categoryName'].toString()).toList();
    });
  }

  void _addCategory() {
    showModalBottomSheet(
      context: context,
      builder: (context) => AddCategoryBottomSheet(onAddCategory: (categoryname) async {
        final categoryName = categoryname;

        if (categoryName.isEmpty) {
          return;
        }

        bool isExist = await doesExist(value: _categoryController.text.trim(), key: "categoryName", collection: "categories");

        if (isExist) {
          const snackBar = SnackBar(
            content: Text("Category Already exists!"),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          await _firestore.collection('categories').add({'categoryName': categoryName.trim()}).then((value) {
            const snackBar = SnackBar(
              content: Text("Category Added Successfully!"),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }).onError((error, stackTrace) {});

          setState(() {
            _categories.add(categoryName);
            _categoryController.clear();
          });
        }
      }),
    );
  }

  _editCategory(String currentCategory) {
    showModalBottomSheet(
      context: context,
      builder: (context) => AddCategoryBottomSheet(onAddCategory: (categoryname) async {
        final categoryName = categoryname;

        if (categoryName.isEmpty) {
          return;
        }

        await updateCategoryName(newCategoryName: categoryName, currentCategoryName: currentCategory).then((value) {
          print("category list is ${_categories}");

          int index = _categories.indexOf(currentCategory.trim());

          print("index is $index");
          if (index >= 0 && index < _categories.length) {
            setState(() {
              _categories[index] = categoryName;
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
        onTap: _addCategory,
        child: const CircleAvatar(
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
        title: const Text('Categories'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _categories.length,
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
                            _editCategory(_categories[index]);
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await deleteRecordsFromCollectionWhere(key:'categoryName',collectionPath: "categories", value: _categories[index]);
                            setState(() {
                              _categories.removeWhere((element) => element == _categories[index]);
                            });
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: AppColors.red,
                          ),
                        ),
                      ],
                    ),
                    title: Text(_categories[index]),
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
          const Expanded(child: SizedBox()),
          DynamicGradientButton(
            isLoading: loading,
            margin: const EdgeInsets.symmetric(horizontal: 15),
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
