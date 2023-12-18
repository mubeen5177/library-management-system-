import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_management/components/custom_text_field.dart';
import 'package:library_management/extensions/build_context_extension.dart';
import 'package:library_management/utils/app_colors.dart';
import 'package:library_management/utils/helper_function.dart';
import 'package:library_management/utils/validation.dart';

import '../../../components/custom_button.dart';
import '../../../models/books_model.dart';

class BooksScreen extends StatefulWidget {
  @override
  _BooksScreenState createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _bookController = TextEditingController();

  List<Books> _books = [];

  @override
  void initState() {
    super.initState();

    _getBooks();
  }

  void _getBooks() async {
    final snapshot = await _firestore.collection('books').get();

    setState(() {
      _books = snapshot.docs
          .map((doc) => Books(imageUrl: doc['imageUrl'], authorName: doc['bookAuthor'], bookName: doc['bookName'], categoryName: doc['bookCategory']))
          .toList();
    });
  }

  void _addBooks() {
    showModalBottomSheet(
      context: context,
      builder: (context) => AddBookBottomSheet(onAddBook: (bookname) async {
        final bookName = bookname;

        if (bookName.isEmpty) {
          return;
        }

        bool isExist = await doesExist(value: _bookController.text.trim(), key: "bookName", collection: "books");

        if (isExist) {
          const snackBar = SnackBar(
            content: Text("Book Already exists!"),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          File img = File(bookName[0].imageUrl);

          String imageLink = await uploadImageAndGetDownloadUrl(img) ?? "";
          await _firestore.collection('books').add({
            'imageUrl': imageLink,
            'bookName': bookName[0].bookName?.trim(),
            'bookCategory': bookname[0].categoryName?.trim(),
            'bookAuthor': bookname[0].authorName?.trim(),
          }).then((value) {
            const snackBar = SnackBar(
              content: Text("Book Added Successfully!"),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }).onError((error, stackTrace) {});

          setState(() {
            print("book list is $_books");
            _books.add(Books(
                imageUrl: bookName[0].imageUrl,
                authorName: bookName[0].authorName,
                bookName: bookName[0].bookName,
                categoryName: bookName[0].categoryName));
            _bookController.clear();
          });
        }
      }),
    );
  }

  _editBook({required String currentBook, required int ind}) {
    showModalBottomSheet(
      context: context,
      builder: (context) => AddBookBottomSheet(onAddBook: (bookname) async {
        final bookName = bookname;

        if (bookName.isEmpty) {
          return;
        }

        await updateBookName(
                    imageUrl: bookName[0].imageUrl,
                    newBookName: bookName[0].bookName!,
                    currentBookName: currentBook,
                    categoryName: bookName[0].categoryName!,
                    authorName: bookName[0].authorName!)
                .then((value) {
          print("book list is ${_books}");

          int index = ind;

          print("index is $index");
          if (index >= 0 && index < _books.length) {
            setState(() {
              _books[index] = bookName[0];
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
        onTap: _addBooks,
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
        title: const Text('Books'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _books.length,
              itemBuilder: (context, index) {

               late File imag;
                if( _books[0].imageUrl.contains("https") || _books[0].imageUrl.contains("http")){

                }else{
                  imag= File(_books[0].imageUrl);
                }
                print("${_books[index].imageUrl}");
                return Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade100,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
                                    height: 90,
                                    width: 90,
                                    child:

                                    _books[0].imageUrl.contains("https") || _books[0].imageUrl.contains("http")
                                        ?
                                    
                                    Image.network(
                                      // "https://tse1.mm.bing.net/th?id=OIP.3l2nfzcHhMemSZooiH3B3AHaFj&pid=Api&rs=1&c=1&qlt=95&w=157&h=117",
                                      _books[0].imageUrl
                                    ): Image.file(imag),
                                  ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      _books[index].bookName.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Category: ${_books[index].categoryName} Author: ${_books[index].authorName}",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    int ind = _books.indexOf(_books[index]);
                                    _editBook(currentBook: _books[index].bookName.toString(), ind: ind);
                                  },
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await deleteRecordsFromCollectionWhere(
                                        collectionPath: "books", value: _books[index].bookName.toString(), key: "bookName");
                                    setState(() {
                                      _books.removeWhere((element) => element == _books[index]);
                                    });
                                  },
                                  icon: const Icon(Icons.delete, color: AppColors.red),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ) ??
                    Container(
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
                        leading: Image.network(
                          _books[index].imageUrl, // Assuming you have an imageUrl field in your _books object
                          width: 50, // Set your desired width
                          height: 50, // Set your desired height
                          fit: BoxFit.cover, // This is to ensure the image covers the space well
                        ),
                        isThreeLine: true,
                        subtitle: Text("Category: ${_books[index].categoryName} Author: ${_books[index].authorName}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                int ind = _books.indexOf(_books[index]);
                                _editBook(currentBook: _books[index].bookName.toString(), ind: ind);
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blue,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                await deleteRecordsFromCollectionWhere(
                                    collectionPath: "books", value: _books[index].bookName.toString(), key: "bookName");
                                setState(() {
                                  _books.removeWhere((element) => element == _books[index]);
                                });
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: AppColors.red,
                              ),
                            ),
                          ],
                        ),
                        title: Text(_books[index].bookName.toString()),
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

class AddBookBottomSheet extends StatefulWidget {
  final Function(List<Books>) onAddBook;

  const AddBookBottomSheet({Key? key, required this.onAddBook}) : super(key: key);

  @override
  _AddBookBottomSheetState createState() => _AddBookBottomSheetState();
}

class _AddBookBottomSheetState extends State<AddBookBottomSheet> {
  final _bookController = TextEditingController();
  bool loading = false;
  String author = '';
  String category = '';
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            context.sizedBox(height: 5),
            const Text(
              "Please Enter Book name",
              style: TextStyle(fontSize: 19),
            ),
            context.sizedBox(height: 5),
            CustomTextField(
              textEditingController: _bookController,
              validator: Validation.validateString,
              obscureText: false,
              hintText: 'Enter Book name',
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
            context.sizedBox(height: 5),
            const Text(
              "Please select Category",
              style: TextStyle(fontSize: 19),
            ),
            context.sizedBox(height: 5),
            DropDownButtonFromFirebaseCollection(
              keyValue: "categoryName",
              collectionPath: 'categories',
              onChanged: (value) {
                print('The selected collection item is: $value');
                setState(() {
                  category = value!;
                });
              },
            ),
            context.sizedBox(height: 5),
            const Text(
              "Please select Author",
              style: TextStyle(fontSize: 19),
            ),
            context.sizedBox(height: 5),
            DropDownButtonFromFirebaseCollection(
              keyValue: "authorName",
              collectionPath: 'authors',
              onChanged: (value) {
                print('The selected collection item is: $value');
                setState(() {
                  author = value!;
                });
              },
            ),
            Row(
              children: [
                Text("Please Select photo"),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
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
                    child: Text("Choose file"))
              ],
            ),
            if (imageFile != null)
              Image.file(
                imageFile!,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            SizedBox(
              height: 10,
            ),
            DynamicGradientButton(
              isLoading: loading,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              fontWeight: FontWeight.bold,
              height: 60,
              width: double.infinity,
              text: 'Add Book',
              onPressed: () {
                widget.onAddBook([Books(imageUrl: imageFile!.path, authorName: author, bookName: _bookController.text, categoryName: category)]);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DropDownButtonFromFirebaseCollection extends StatefulWidget {
  final String collectionPath;
  final String keyValue;

  final ValueChanged<String?> onChanged;

  const DropDownButtonFromFirebaseCollection({
    Key? key,
    required this.collectionPath,
    required this.keyValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<DropDownButtonFromFirebaseCollection> createState() => _DropDownButtonFromFirebaseCollectionState();
}

class _DropDownButtonFromFirebaseCollectionState extends State<DropDownButtonFromFirebaseCollection> {
  List<String> _collectionItems = [];
  String? _selectedCollectionItem;

  @override
  void initState() {
    super.initState();

    _getCollections();
  }

  Future<void> _getCollections() async {
    final collectionSnapshot = await FirebaseFirestore.instance.collection(widget.collectionPath).get();

    setState(() {
      _collectionItems = collectionSnapshot.docs.map((doc) => doc[widget.keyValue].toString()).toList();
      _selectedCollectionItem = _collectionItems.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
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
      child: DropdownButton<String>(
        value: _selectedCollectionItem,
        items: _collectionItems.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: (value) {
          setState(() {
            _selectedCollectionItem = value;
          });

          widget.onChanged(value);
        },
      ),
    );
  }
}

// class Books {
//   String bookName;
//   String categoryName;
//   String authorName;
//   Books({required this.authorName, required this.bookName, required this.categoryName});
// }
