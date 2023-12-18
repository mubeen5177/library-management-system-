import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:library_management/utils/helper_function.dart';

import '../../../models/books_model.dart';

class ViewIssuedBooks extends StatefulWidget {
  const ViewIssuedBooks({super.key});

  @override
  State<ViewIssuedBooks> createState() => _ViewIssuedBooksState();
}

class _ViewIssuedBooksState extends State<ViewIssuedBooks> {
  List<Books> _books = [];
  @override
  void initState() {
    super.initState();

    _getBooks();
  }

  void _getBooks() async {
    _books = await getBooksIssuedByUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Issued Books'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _books.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(8),
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
                    isThreeLine: true,
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Category: ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: '${_books[index].categoryName}',
                                style: TextStyle(),
                              ),
                              TextSpan(
                                text: '\nAuthor: ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: '${_books[index].authorName}',
                                style: TextStyle(),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Return Date: ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: '${_books[index].endDate.toString().split(" ")[0]}',
                                style: TextStyle(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    trailing: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await removeFromList(_books[index]);
                            setState(() {
                              _books.removeWhere((element) => element == _books[index]);
                            });
                          },
                          child: Text("Return book"),
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
