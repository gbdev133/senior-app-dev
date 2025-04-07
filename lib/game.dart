import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:math';
import 'firebase_options.dart';
import 'questions.dart';
import 'chat.dart';
import 'gamepage.dart';
import 'result.dart';
import 'quiz_player.dart';

class Game extends StatefulWidget {
  final List<Question> questions; final FirebaseStorage storage;
  Game({super.key, required this.questions, required this.storage});
  

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  int currentQuestionIndex = 0;
  int score = 0;
  late Question currentQuestion;
  bool showResult = false;
  String audioFileName = '';
  Key quizPlayerKey = UniqueKey();
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    currentQuestion = widget.questions[currentQuestionIndex];
    audioFileName = currentQuestion.options[currentQuestion.correctAnswerIndex];
  }



  void selectAnswer(int index) {
    setState(() {
      showResult = true;
      if (index == currentQuestion.correctAnswerIndex) {
        score += 1;
      }
    });
  }

  void goToNextQuestion() {
    audioPlayer.dispose();
    audioPlayer = AudioPlayer();
    if (currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        currentQuestion = widget.questions[currentQuestionIndex];
        showResult = false;
        audioFileName = currentQuestion.options[currentQuestion.correctAnswerIndex];
        quizPlayerKey = UniqueKey();
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

    print("showResult: $showResult");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Guess the Song in 10 Seconds"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Text(
              "Question ${currentQuestionIndex + 1}: ${currentQuestion.question}",
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            KeyedSubtree(
              key: quizPlayerKey,
              child: QuizPlayer(storage: widget.storage, audioFileName: audioFileName, audioPlayer: audioPlayer),
            ),
            ...currentQuestion.options.map((option) {
              int index = currentQuestion.options.indexOf(option);
              return ElevatedButton(
                onPressed: showResult ? () => setState(() {}) : () => selectAnswer(index),
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
            const SizedBox(height: 20),
            if (showResult) 
              ElevatedButton(
                onPressed: goToNextQuestion, 
                child: const Text("Next")
              ),
          ],
        ),
      ),
    );
  }
}