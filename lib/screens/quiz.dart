import 'package:flutter/material.dart';
import '../helpers/quiz_data.dart';
import '../models/db_model.dart';
import '../screen_widgets/answer_card.dart';
import '../screen_widgets/next_button.dart';
import '../screen_widgets/result_screen.dart';

class QuizScreen extends StatefulWidget {
  final int workId;

  const QuizScreen({required this.workId, Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int? selectedAnswerIndex;
  int questionIndex = 0;
  int score = 0;
  late List<Question> _questionsForWorkId; // Store shuffled questions

  @override
  void initState() {
    super.initState();
    _questionsForWorkId = _shuffleQuestions();
  }

  List<Question> _shuffleQuestions() {
    List<Question> filteredQuestions = questions
        .firstWhere((list) => list.first.workId == widget.workId,
            orElse: () => [])
        .toList();
    filteredQuestions.shuffle();
    return filteredQuestions.take(10).toList();
  }

  void pickAnswer(int value) {
    if (selectedAnswerIndex == null) {
      final question = _questionsForWorkId[questionIndex];
      selectedAnswerIndex = value;
      if (selectedAnswerIndex == question.correctAnswerIndex) {
        score++;
      }
      setState(() {});
    }
  }

  void goToNextQuestion() {
    if (questionIndex < _questionsForWorkId.length - 1) {
      questionIndex++;
      selectedAnswerIndex = null; // Reset selectedAnswerIndex
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_questionsForWorkId.isEmpty) {
      // Handle case where there are no questions for the specified workId
      return Scaffold(
        appBar: AppBar(
          title: const Text(''),
        ),
        body: Center(
          child: Text('No questions available for this workId.'),
        ),
      );
    }

    final question = _questionsForWorkId[questionIndex];
    bool isLastQuestion = questionIndex == _questionsForWorkId.length - 1;
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              question.question,
              style: const TextStyle(
                fontSize: 21,
              ),
              textAlign: TextAlign.center,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: question.choices.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: selectedAnswerIndex == null
                      ? () => pickAnswer(index)
                      : null,
                  child: AnswerCard(
                    currentIndex: index,
                    question: question.choices[index],
                    isSelected: selectedAnswerIndex == index,
                    selectedAnswerIndex: selectedAnswerIndex,
                    correctAnswerIndex: question.correctAnswerIndex,
                  ),
                );
              },
            ),
            // Next Button
            isLastQuestion
                ? RectangularButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) =>
                              ResultScreen(score: score, workId: widget.workId),
                        ),
                      );
                    },
                    label: 'Finish',
                  )
                : RectangularButton(
                    onPressed:
                        selectedAnswerIndex != null ? goToNextQuestion : null,
                    label: 'Next',
                  ),
          ],
        ),
      ),
    );
  }
}
