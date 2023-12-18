import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:library_management/components/custom_button.dart';
import 'package:library_management/extensions/build_context_extension.dart';
import 'package:library_management/extensions/string_to_date.dart';
import 'package:library_management/screens/admin/add_books/add_books.dart';
import 'package:library_management/utils/helper_function.dart';
import 'package:library_management/utils/validation.dart';

import '../../../components/custom_text_field.dart';
import '../../../models/books_model.dart';

class ViewAvailableBooks extends StatefulWidget {
  const ViewAvailableBooks({super.key});

  @override
  State<ViewAvailableBooks> createState() => _ViewAvailableBooksState();
}

class _ViewAvailableBooksState extends State<ViewAvailableBooks> {
  final _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();

    _getBooks();
  }

  void _getBooks() async {
    final snapshot = await _firestore.collection('books').get();

    setState(() {
      books = snapshot.docs
          .map((doc) => Books(imageUrl: doc['imageUrl'], authorName: doc['bookAuthor'], bookName: doc['bookName'], categoryName: doc['bookCategory']))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Available Books'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                return BookItem(
                  book: books[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BookItem extends StatefulWidget {
  Books book;
  BookItem({super.key, required this.book});

  @override
  State<BookItem> createState() => _BookItemState();
}

class _BookItemState extends State<BookItem> {
  bool exist = false;
  _checkExistance(Books book) async {
    exist = await doesObjectExistInIssuedBooks(book);
    setState(() {});
    print("exists? $exist");
  }

  @override
  void initState() {
    _checkExistance(widget.book);
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(8),
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
      child: Row(
        children: [
          // Image widget for book image
          Image.network(
            widget.book.imageUrl, // Replace with your book image URL
            height: 90,
            width: 90,
          ),
          Expanded(
            child: ListTile(
              isThreeLine: true,
              subtitle: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'Category: ',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '${widget.book.categoryName}',
                    ),
                    const TextSpan(
                      text: '\nAuthor: ',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '${widget.book.authorName}',
                    ),
                  ],
                ),
              ),
              trailing: ElevatedButton(
                onPressed: exist
                    ? null
                    : () {
                        _issueBooks(widget.book);
                      },
                child: exist ? Text("Issued") : Text("Issue book"),
              ),
              title: Text(widget.book.bookName.toString()),
            ),
          ),
        ],
      ),
    );
  }

  void _issueBooks(Books book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => AddBookBottomSheet(
            book: book,
            onissueBook: (bookname) async {
              setState(() {
                // books.removeWhere((element) => element == bookname);
                exist = true;
              });
            }),
      ),
    );
  }
}

class AddBookBottomSheet extends StatefulWidget {
  final Function(Books) onissueBook;
  Books book;

  AddBookBottomSheet({Key? key, required this.onissueBook, required this.book}) : super(key: key);

  @override
  _AddBookBottomSheetState createState() => _AddBookBottomSheetState();
}

class _AddBookBottomSheetState extends State<AddBookBottomSheet> {
  // final _bookReturnDate = TextEditingController();
  // final _bookIssueDate = TextEditingController();
  DateTime? _bookReturnDate;
  DateTime? _bookIssueDate;
  final _formKey = GlobalKey<FormState>();
  List<DateTime?> _dates = [];
  bool isNext = false;

  @override
  Widget build(BuildContext context) {
    print("book is ${widget.book.bookName} ");
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                "Please Select Dates",
                style: TextStyle(fontSize: 19),
              ),
              context.sizedBox(height: 5),

              CalendarDatePicker2(
                config: CalendarDatePicker2Config(
                    dayTextStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.bold),
                    selectedDayHighlightColor: Colors.black,
                    dayBorderRadius: BorderRadius.circular(14),
                    firstDayOfWeek: 0,
                    weekdayLabels: [
                      "Mo",
                      "Tu",
                      "We",
                      "Th",
                      "Fr",
                      "Sa",
                      "Su",
                    ],
                    calendarType: CalendarDatePicker2Type.range,
                    weekdayLabelTextStyle:
                        Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                    // disableYearPicker: true,
                    nextMonthIcon: Container(
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(13),
                        shape: BoxShape.rectangle,
                        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.1), spreadRadius: 3.4)],
                      ),
                      child: Center(
                          child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 13,
                      )),
                    ),
                    lastMonthIcon: Container(
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(13),
                        shape: BoxShape.rectangle,
                        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.1), spreadRadius: 3.4)],
                      ),
                      child: const Center(
                          child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                        size: 13,
                      )),
                    )),
                onValueChanged: (dates) {
                  _dates = dates;
                  _bookIssueDate = _dates[0];
                  if (_dates.length == 2) {
                    _bookReturnDate = _dates[1];
                  }
                  print("dates are ${_dates}");
                }, value: [],

              ),

              // CustomTextField(
              //   textEditingController: _bookIssueDate,
              //   validator: Validation.isDateValid,
              //   obscureText: false,
              //   hintText: 'DD/MM/YYYY',
              //   isFocused: true, // Set the focus state of the text field
              //   onChanged: (value) {
              //     // Handle text changes here
              //     print('Text changed: $value');
              //   },
              //   onTap: () {
              //     // Handle tap event here
              //     print('Text field tapped');
              //   },
              // ),
              context.sizedBox(height: 5),

              // context.sizedBox(height: 5),
              // CustomTextField(
              //   textEditingController: _bookReturnDate,
              //   validator: Validation.isDateValid,
              //   obscureText: false,
              //   hintText: 'DD/MM/YYYY',
              //   isFocused: true, // Set the focus state of the text field
              //   onChanged: (value) {
              //     // Handle text changes here
              //     print('Text changed: $value');
              //   },
              //   onTap: () {
              //     // Handle tap event here
              //     print('Text field tapped');
              //   },
              // ),
              // context.sizedBox(height: 5),
              const Expanded(child: SizedBox()),
              DynamicGradientButton(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                fontWeight: FontWeight.bold,
                height: 60,
                width: double.infinity,
                text: 'Issue Book',
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (_bookIssueDate != null && _bookReturnDate != null) {
                      await issueBook(book: widget.book, startDate: _bookIssueDate!, endDate: _bookReturnDate!);

                      widget.onissueBook(widget.book);
                      Navigator.pop(context);
                    } else {
                      final snackBar = SnackBar(
                        content: Text("Please Provide both dates"),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
