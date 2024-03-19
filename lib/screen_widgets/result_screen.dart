import 'package:flutter/material.dart';

import '../screens/quiz.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int workId;

  const ResultScreen({Key? key, required this.score, required this.workId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double percentage = (score / 10) * 100; // Calculate percentage
    double progress = score / 10; // Calculate progress value

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(width: 1000),
          const Text(
            'Your Score: ',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w500,
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 250,
                width: 250,
                child: CircularProgressIndicator(
                  strokeWidth: 10,
                  value: progress, // Use calculated progress value
                  color: Color.fromRGBO(139, 69, 19, 1.0),
                  backgroundColor: Colors.white,
                ),
              ),
              Column(
                children: [
                  Text(
                    score.toString(),
                    style: const TextStyle(fontSize: 80),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${percentage.toStringAsFixed(0)}%', // Display percentage rounded to nearest whole number
                    style: const TextStyle(fontSize: 25),
                  )
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 175, // Adjust the width as needed
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(139, 69, 19, 1.0),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextButton.icon(
                    onPressed: () {
                      // Handle retake quiz action
                      Navigator.pushReplacement(
                        // Push a new instance of the quiz screen
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuizScreen(workId: workId),
                        ),
                      );
                    },
                    icon: Icon(Icons.refresh, color: Colors.white),
                    label: Text(
                      'Retake',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 175, // Adjust the width as needed
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(139, 69, 19, 1.0),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextButton.icon(
                    onPressed: () {
                      // Handle back to readscreen action
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    label: Text(
                      'Back',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
