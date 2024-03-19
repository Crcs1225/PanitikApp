import 'package:flutter/material.dart';

import '../helpers/quiz_data.dart';
import '../models/db_model.dart';

class ReviewerScreen extends StatelessWidget {
  const ReviewerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Add your content here
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(139, 69, 19, 1.0),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Philippine Literature Reviewer',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                    BookCard(bookIndex: 0, workId: 1), // For Ibong Adarna
                    BookCard(bookIndex: 1, workId: 2), // For Florante at Laura
                    BookCard(bookIndex: 2, workId: 3), // For El Filibusterismo
                    BookCard(bookIndex: 3, workId: 4), // For Noli Me Tangere
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  final int bookIndex;
  final int workId;

  const BookCard({Key? key, required this.bookIndex, required this.workId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter questions based on the workId
    List<Question> filteredQuestions = questions[bookIndex]
        .where((question) => question.workId == workId)
        .toList();

    // Extract the title of the literary work
    String title = getTitleForWorkId(workId);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ExpansionTile(
        title: Text(title), // Display the title
        children: filteredQuestions.map((question) {
          String correctAnswer = question
              .choices[question.correctAnswerIndex]; // Get the correct answer
          return ListTile(
            title: Text(
              question.question,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Correct Answer: $correctAnswer',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green), // Color correct answer green
            ),
          );
        }).toList(),
      ),
    );
  }

  // Function to get the title based on workId
  String getTitleForWorkId(int workId) {
    switch (workId) {
      case 1:
        return "Ibong Adarna";
      case 2:
        return "Florante at Laura";
      case 3:
        return "El Filibusterismo";
      case 4:
        return "Noli Me Tangere";
      default:
        return "Unknown Work";
    }
  }
}
