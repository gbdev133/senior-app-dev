import 'package:flutter/material.dart';
import 'questions.dart';
import 'result.dart';
import 'dart:async';

class Game extends StatefulWidget {
  final List<Question> questions;
  Game({super.key, required this.questions});
  

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  int currentQuestionIndex = 0;
  int score = 0;
  int secondsRemaining = 10;
  late Question currentQuestion;
  bool showResult = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    currentQuestion = widget.questions[currentQuestionIndex];
    startTimer();
  }

  void startTimer() {
  secondsRemaining = 10;
  showResult = false;
  updateTimer();  // Directly call updateTimer without delay
}

void updateTimer() {
  if (secondsRemaining >= 0) {
    _timer = Timer(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          secondsRemaining--;
        });
        updateTimer();  // Recursive call to update the timer after each second
      }
    });
  } else {
    goToNextQuestion();
  }
}


  void selectAnswer(int index) {
    _timer?.cancel();
    setState(() {
      showResult = true;
      if (index == currentQuestion.correctAnswerIndex) {
        score += 1;
      }

      Future.delayed(Duration(seconds: 2), goToNextQuestion);
    });
  }

  void goToNextQuestion() {
    if (currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        currentQuestion = widget.questions[currentQuestionIndex];
        startTimer();
      });
    } else {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(score: score),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Time: $secondsRemaining",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              currentQuestion.question,
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ...currentQuestion.options.map((option) {
              int index = currentQuestion.options.indexOf(option);
              return ElevatedButton(
                onPressed: showResult ? null : () => selectAnswer(index),
                style: ElevatedButton.styleFrom(
                  backgroundColor: showResult
                      ? index == currentQuestion.correctAnswerIndex
                          ? Colors.green
                          : Colors.red
                      : Colors.blue,
                ),
                child: Text(option),
              );
            }),
          ],
        ),
      ),
    );
  }
}