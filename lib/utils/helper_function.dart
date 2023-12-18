import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:library_management/models/books_model.dart';
import 'package:library_management/utils/user_session.dart';

import '../screens/admin/add_books/add_books.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;
List<Books> books = [];
String generateRandomId() {
  final Random random = Random();
  const String charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
  final int length = 10;

  String randomId = '';

  for (int i = 0; i < length; i++) {
    final int randomIndex = random.nextInt(charset.length);
    randomId += charset[randomIndex];
  }

  return randomId;
}

Future<void> saveUserData(
    {required String uid,
    required String email,
    required String password,
    required String displayName,
    required String stdId,
    required String phone}) async {
  try {
    await _firestore.collection('users').doc(uid).set({
      'displayName': displayName,
      'email': email,
      'studentId': stdId,
      'password': password,
      'phone': phone,
      "photoUrl": "",
      "role": "student",
      "address": "",
      "booksIssued": []
    });
  } catch (e) {
    print("Error saving user data: $e");
  }
}

Future<User?> registerUser(
    {required String email, required String password, required String displayName, required String stdId, required String phone}) async {
  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  } catch (e) {
    print("Error registering user: $e");
    return null;
  }
}

Future<bool> checkConnection() async {
  bool connectivityCheck = false;
  try {
    final result = await InternetAddress.lookup('google.com').timeout(const Duration(seconds: 20));
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
      connectivityCheck = true;
    }
  } on SocketException catch (_) {
    print('not connected');
    connectivityCheck = false;
  }

  return connectivityCheck;
}

Future<void> registerAndSaveUserData(
    {required String email, required String password, required String displayName, required String stdId, required String phone}) async {
  try {
    User? user = await registerUser(email: email, password: password, displayName: displayName, stdId: stdId, phone: phone);

    if (user != null) {
      await saveUserData(uid: user.uid, displayName: displayName, email: email, phone: phone, password: password, stdId: stdId);
      print("User registered and data saved successfully.");
    } else {
      print("User registration failed.");
    }
  } catch (e) {
    print("Error: $e");
  }
}

void setLoggedStatus(bool status) async {
  await UserSession.setLoggedIn(status);
}

Future<bool> doesEmailExist(String email) async {
  try {
    final QuerySnapshot query = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).get();

    return query.docs.isNotEmpty; // Email exists if there are matching documents
  } catch (e) {
    // Handle errors or exceptions, such as Firestore connection issues, if needed
    print('Error checking email existence: $e');
    return false; // Return false in case of an error
  }
}

Future<User?> signInWithEmailAndPassword(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;

    if (user != null) {
      return user;
    }

    return null;
  } catch (e) {
    print('Error signing in: $e');
    return null;
  }
}

Future<void> changePassword(String newPassword) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await user.updatePassword(newPassword);
      await updateField(fieldName: "password", newValue: newPassword, collection: "users");
      print('Password changed successfully');
    } else {
      print('No user is currently signed in.');
    }
  } catch (e) {
    print('Error changing password: $e');
  }
}

Future<void> signOutUser() async {
  try {
    await FirebaseAuth.instance.signOut();
    setLoggedStatus(false);
    print('User signed out successfully');
  } catch (e) {
    print('Error signing out: $e');
  }
}

Future<void> updateField({required String fieldName, required dynamic newValue, required String collection}) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Reference to the Firestore document
      DocumentReference documentReference = FirebaseFirestore.instance.collection(collection).doc(user.uid);

      // Update the specific field
      await documentReference.update({
        fieldName: newValue,
      });

      print('Field "$fieldName" updated successfully.');
    }
  } catch (e) {
    print('Error updating field: $e');
  }
}

// Function to send a password reset email
Future<void> sendPasswordResetEmail(String email) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: email,
    );
    print('Password reset email sent successfully');
  } catch (e) {
    print('Error sending password reset email: $e');
  }
}

Future<DocumentSnapshot<Map<String, dynamic>>?> getUserData(String uid) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();

    // Check if the document exists
    if (userSnapshot.exists) {
      return userSnapshot;
    } else {
      // Handle the case where the user does not exist
      return null;
    }
  } catch (e) {
    // Handle errors or exceptions, such as Firestore connection issues
    print('Error retrieving user data: $e');
    return null;
  }
}

Future<void> updateUserProfile({required File photo, required String displayName, required String phone, required String address}) async {
  // Get the current user's UID.
  final uid = FirebaseAuth.instance.currentUser!.uid;

  // Get the user's profile document.
  final userProfileDoc = FirebaseFirestore.instance.collection('users').doc(uid);
  String photoUrl = await uploadImageToFirebase(photo);
  // Update the custom profile field.
  await userProfileDoc.update({'displayName': displayName, 'phone': phone, "photoUrl": photoUrl, "role": "student", "address": address});
}

Future<String> uploadImageToFirebase(File imageFile) async {
  // Create a reference to the image file.
  final imageRef = FirebaseStorage.instance.ref('images/${imageFile.path}');

  // Upload the image file to Firebase Storage.
  final taskSnapshot = await imageRef.putFile(imageFile);

  // Get the download URL for the uploaded image.
  final downloadUrl = await taskSnapshot.ref.getDownloadURL();

  return downloadUrl;
}

Future<void> addCategory({
  required String uid,
  required String displayName,
}) async {
  try {
    await _firestore.collection('categories').doc(uid).set({
      'categoryName': displayName,
    });
  } catch (e) {
    print("Error saving user data: $e");
  }
}

Future<bool> doesExist({required String value, required String key, required String collection}) async {
  try {
    final QuerySnapshot query = await FirebaseFirestore.instance.collection(collection).where(key, isEqualTo: value).get();

    return query.docs.isNotEmpty; // Email exists if there are matching documents
  } catch (e) {
    // Handle errors or exceptions, such as Firestore connection issues, if needed
    print('Error checking $value existence: $e');
    return false; // Return false in case of an error
  }
}

Future<void> deleteRecordsFromCollectionWhere({required String collectionPath, required String value, required String key}) async {
  // Get a reference to the collection.
  final collectionReference = FirebaseFirestore.instance.collection(collectionPath);

  // Query the collection for all documents where the name is "Mubeen".
  final querySnapshot = await collectionReference.where(key, isEqualTo: value).get();

  // Iterate over the results of the query and delete each document.
  for (final documentSnapshot in querySnapshot.docs) {
    await documentSnapshot.reference.delete();
  }
}

Future<void> updateCategoryName({required String currentCategoryName, required String newCategoryName}) async {
  // Get the categoryId using the currentCategoryName
  String? categoryId = await getCategoryIdByCategoryName(currentCategoryName);

  if (categoryId != null) {
    try {
      // Reference to the document in the "categories" collection
      DocumentReference categoryRef = FirebaseFirestore.instance.collection('categories').doc(categoryId);

      // Update the "categoryName" field
      await categoryRef.update({
        'categoryName': newCategoryName,
      });

      print('Category name updated successfully.');
    } catch (e) {
      print('Error updating category name: $e');
    }
  } else {
    print('Category not found with name: $currentCategoryName');
  }
}

Future<void> updateAuthorName({required String currentAuthorName, required String newAuthorName}) async {
  // Get the categoryId using the currentCategoryName
  String? authorId = await getAuthorIdByAuthorName(currentAuthorName);

  if (authorId != null) {
    try {
      // Reference to the document in the "categories" collection
      DocumentReference categoryRef = FirebaseFirestore.instance.collection('authors').doc(authorId);

      // Update the "categoryName" field
      await categoryRef.update({
        'authorName': newAuthorName,
      });

      print('Category name updated successfully.');
    } catch (e) {
      print('Error updating category name: $e');
    }
  } else {
    print('Category not found with name: $currentAuthorName');
  }
}

Future<void> updateBookName(
    {required String currentBookName,
    required String newBookName,
    required String authorName,
    required String categoryName,
    required String imageUrl}) async {
  // Get the categoryId using the currentCategoryName
  String? bookId = await getBookIdByBookName(currentBookName);

  if (bookId != null) {
    try {
      // Reference to the document in the "categories" collection
      DocumentReference categoryRef = FirebaseFirestore.instance.collection('books').doc(bookId);

      // Update the "categoryName" field
      await categoryRef.update({'imageUrl': imageUrl, 'bookName': newBookName, 'bookCategory': categoryName, 'bookAuthor': authorName});

      print('Book name updated successfully.');
    } catch (e) {
      print('Error updating Book name: $e');
    }
  } else {
    print('Book not found with name: $currentBookName');
  }
}

Future<String?> getAuthorIdByAuthorName(String authorName) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('authors').where('authorName', isEqualTo: authorName).get();

    if (querySnapshot.docs.isNotEmpty) {
      // Return the categoryId of the first matching document
      return querySnapshot.docs.first.id;
    } else {
      // Handle the case where no matching document is found
      print('Category not found with name: $authorName');
      return null;
    }
  } catch (e) {
    print('Error getting categoryId: $e');
    return null;
  }
}

Future<String?> getCategoryIdByCategoryName(String categoryName) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('categories').where('categoryName', isEqualTo: categoryName).get();

    if (querySnapshot.docs.isNotEmpty) {
      // Return the categoryId of the first matching document
      return querySnapshot.docs.first.id;
    } else {
      // Handle the case where no matching document is found
      print('Category not found with name: $categoryName');
      return null;
    }
  } catch (e) {
    print('Error getting categoryId: $e');
    return null;
  }
}

Future<String?> getBookIdByBookName(String bookName) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('books').where('bookName', isEqualTo: bookName).get();

    if (querySnapshot.docs.isNotEmpty) {
      // Return the categoryId of the first matching document
      return querySnapshot.docs.first.id;
    } else {
      // Handle the case where no matching document is found
      print('Book not found with name: $bookName');
      return null;
    }
  } catch (e) {
    print('Error getting  bookId: $e');
    return null;
  }
}

Future<List<Map<String, dynamic>>> getDataByField(String collectionName, String fieldName, String value) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(collectionName).where(fieldName, isEqualTo: value).get();

    List<Map<String, dynamic>> matchingData = [];

    if (querySnapshot.docs.isNotEmpty) {
      // Loop through the documents that match the query
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        matchingData.add(data);
      }
    }

    return matchingData;
  } catch (e) {
    print('Error getting data: $e');
    return [];
  }
}

Future<void> issueBook({required Books book, required DateTime startDate, required DateTime endDate}) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  try {
    // Fetch the user's document
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();

    // Check if the user exists
    if (userSnapshot.exists) {
      // Deserialize the user's data
      Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;

      // Deserialize the list of issued books
      List<dynamic> issuedBooksData = userData['booksIssued'] ?? [];
      List<Books> issuedBooks = issuedBooksData
          .map((bookData) => Books(
                imageUrl: bookData['imageUrl'] ?? '',
                bookName: bookData['bookName'] ?? '',
                categoryName: bookData['categoryName'] ?? '',
                authorName: bookData['authorName'] ?? '',
                endDate: (bookData['endDate'] as Timestamp).toDate() ?? DateTime.now(),
                startDate: (bookData['startDate'] as Timestamp).toDate() ?? DateTime.now(),
              ))
          .toList();

      // Add the new book to the list of issued books
      issuedBooks.add(book);
      // Serialize the updated list of issued books
      List<Map<String, dynamic>> issuedBooksDataUpdated = issuedBooks
          .map((issuedBook) => {
                'bookName': issuedBook.bookName,
                'authorName': issuedBook.authorName,
                'categoryName': issuedBook.categoryName,
                'startDate': startDate,
                'endDate': endDate,
              })
          .toList();
      // Update the user's document with the updated list of issued books
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'booksIssued': issuedBooksDataUpdated,
      });

      print('Book added to user\'s list of issued books.');
    } else {
      print('User not found.');
    }
  } catch (e) {
    print('Error adding book to user\'s list: $e');
  }
}

Future<bool> doesObjectExistInIssuedBooks(Books objectToCheck) async {
  try {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userSnapshot.exists) {
      // Deserialize the user's data
      Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;

      // Deserialize the list of issuedBooks
      List<dynamic> issuedBooksData = userData['booksIssued'] ?? [];
      List<Books> issuedBooks = issuedBooksData.map((bookData) => Books.fromJson(bookData)).toList();

      // Check if the object exists in the list
      bool doesExist = issuedBooks.any((book) => book.bookName == objectToCheck.bookName);
      return doesExist;
    } else {
      return false; // User document does not exist
    }
  } catch (e) {
    print('Error checking object in issuedBooks: $e');
    return false; // Error occurred
  }
}

Future<List<Books>> getBooksIssuedByUser() async {
  try {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userSnapshot.exists) {
      final userData = userSnapshot.data() as Map<String, dynamic>;
      final issuedBooksData = userData['booksIssued'] as List<dynamic>;

      List<Books> issuedBooks = issuedBooksData.map((bookData) => Books.fromJson(bookData)).toList();

      return issuedBooks;
    } else {
      return []; // User document does not exist
    }
  } catch (e) {
    print('Error fetching booksIssued: $e');
    return []; // Error occurred
  }
}

Future<void> removeFromList(Books book) async {
  try {
    // Get the user's document
    final userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference userRef = _firestore.collection('users').doc(userId);
    DocumentSnapshot userSnapshot = await userRef.get();

    if (userSnapshot.exists) {
      // Retrieve the current 'booksIssued' field
      dynamic booksIssuedData = userSnapshot.data() ?? {}['booksIssued'];

      // Check if 'booksIssuedData' is a list or initialize it as an empty list
      List<dynamic> booksIssued = (booksIssuedData is List<dynamic>) ? booksIssuedData : [];

      // Check if the book exists in the list
      booksIssued.removeWhere((element) => element == book.bookName);
      // if (booksIssued.contains(book)) {
      print("success");
      // // Remove the book from the list
      //   booksIssued.remove(book);

      // Update the user's document with the modified list
      await userRef.update({'booksIssued': booksIssued});

      // Book removed successfully
      // } else {
      //   // Book not found in the list
      // }
    } else {
      // User document not found
    }
  } catch (e) {
    print('Error removing book: $e');
    // Handle the error
  }
}

Future<String?> uploadImageAndGetDownloadUrl(File imageFile) async {
  try {
    // Create a unique file name for the image
    String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';

    // Upload the image to Firebase Storage
    TaskSnapshot uploadTask = await FirebaseStorage.instance.ref(fileName).putFile(imageFile);

    // When complete, fetch the download URL
    String downloadUrl = await uploadTask.ref.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    print(e);
    return null; // Return null if any error occurs
  }
}

class PakistaniPhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    if (newText.isEmpty || newText.length < 4) {
      return newValue;
    }

    if (!newText.startsWith('+92')) {
      newText = '+92' + newText.substring(newText.length - 10);
    }

    return newValue.copyWith(text: newText, selection: newValue.selection);
  }
}
