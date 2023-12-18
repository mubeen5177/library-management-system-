import 'package:library_management/models/books_model.dart';

class Students {
  String address;
  String role;
  String displayName;
  String phone;
  String photoUrl;
  String studentId;
  List<Books> issuedBooks;
  String email;

  Students({
    required this.address,
    required this.role,
    required this.displayName,
    required this.phone,
    required this.photoUrl,
    required this.studentId,
    required this.issuedBooks,
    required this.email,
  });

  // Factory constructor to create a Students object from a JSON map
  factory Students.fromJson(Map<String, dynamic> json) {
    List<dynamic> issuedBooksData = json['issuedBooks'] ?? [];
    List<Books> issuedBooks = issuedBooksData.map((bookData) => Books.fromJson(bookData)).toList();

    return Students(
      address: json['address'] ?? '',
      role: json['role'] ?? '',
      displayName: json['displayName'] ?? '',
      phone: json['phone'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      studentId: json['studentId'] ?? '',
      issuedBooks: issuedBooks,
      email: json['email'] ?? '',
    );
  }

  // Convert the Students object to a JSON map
  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> issuedBooksData = issuedBooks.map((book) => book.toJson()).toList();

    return {
      'address': address,
      'role': role,
      'displayName': displayName,
      'phone': phone,
      'photoUrl': photoUrl,
      'studentId': studentId,
      'issuedBooks': issuedBooksData,
      'email': email,
    };
  }
}
