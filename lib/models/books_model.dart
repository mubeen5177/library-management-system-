import 'package:cloud_firestore/cloud_firestore.dart';

class Books {
  String? bookName;
  String? categoryName;
  String? authorName;
  DateTime? startDate;
  DateTime? endDate;
  String imageUrl;

  Books({required this.authorName, required this.bookName, required this.categoryName, this.endDate, this.startDate,required this.imageUrl});

  // Create a factory constructor for JSON serialization/deserialization
  factory Books.fromJson(Map<String, dynamic> json) {
    return Books(
      bookName: json['bookName'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      categoryName: json['categoryName'] ?? '',
      authorName: json['authorName'] ?? '',
      startDate: (json['startDate'] as Timestamp).toDate() ?? DateTime.now(),
      endDate: (json['endDate'] as Timestamp).toDate() ?? DateTime.now(),

      // Map other properties from JSON here
    );
  }

  // Create a method to convert the book object to JSON
  Map<String, dynamic> toJson() {
    return {
      'bookName': bookName,
      'authorName': authorName,
      'categoryName': categoryName,
      'imageUrl':imageUrl,
      'startDate': startDate,
      'endDate': endDate,
      // Add other properties to the JSON map here
    };
  }
}
