import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:math';
import 'game.dart';
import 'questions.dart';

class GamePage extends StatefulWidget {
  final List<String> songList; final FirebaseStorage storage;
  GamePage({super.key, required this.songList, required this.storage});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {

  Future<String> extractAudio(String fileName) async {
    final storageRef = widget.storage.ref().child('audio/$fileName');
    String url = '';
    try {
      url = await storageRef.getDownloadURL();
    } catch (e) {
      print("Error setting Url for $fileName: $e");
    }
    return url;
  }

  List<Question> genQuestions() {
    List<String> tmp = List.from(widget.songList);
    List<Question> questions = [];

    for (int i = 0; i < 2; i++) {
      String correctAnswer = tmp[Random().nextInt(tmp.length)];
      tmp.remove(correctAnswer);
      List<String> options = [];

      for (int j = 0; j < 3; j++) {
        String incorrectAnswer = tmp[Random().nextInt(tmp.length)];
        options.add(incorrectAnswer);
        tmp.remove(incorrectAnswer);
      }
      options.add(correctAnswer);
      options.shuffle();
      int correctAnswerIndex = 0;
      for (int j = 0; j < 4; j++) {
        if (options[j] == correctAnswer) {
          correctAnswerIndex = j;
        }
        tmp.add(options[j]);
      }
      print('Correct answer index: $correctAnswerIndex');
      print('Options: $options');
      print('----');
      questions.add(Question(
        correctAnswerIndex: correctAnswerIndex, 
        question: 'What is the name of this song?', 
        options: options,
        songURL: extractAudio(correctAnswer).toString()
      ));
    }

    return questions;

  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
        ),
        child: const Text('Begin'),
        onPressed: () => {
          if (widget.songList.length >= 4) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => Game(questions: genQuestions()))
            )
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Not enough songs to play!"),
                duration: Duration(seconds: 3),
              )
            )
          }
        },
      ),
    );
  }
}