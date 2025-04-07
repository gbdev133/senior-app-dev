import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
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

    for (int i = 0; i < 5; i++) {
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
      ));
    }

    return questions;

  }


  @override
  Widget build(BuildContext context) {
    return GridView.count(
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: [
        Column(
          children: [
            const Text('Guess the Song in \n10 Seconds', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
              ),
              child: const Text('Begin', style: TextStyle(color: Color.fromARGB(222, 255, 255, 255))),
              onPressed: () => {
                if (widget.songList.length >= 4) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Game(questions: genQuestions(), storage: widget.storage))
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
          ],
        ),
        Column(
          children: [
            const Text('Game #2', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
              ),
              onPressed: () => {
              },
              child: const Text('Begin', style: TextStyle(color: Color.fromARGB(222, 255, 255, 255))),

            ),
          ],
        ),
        Column(
          children: [
            const Text('Game #3', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
              ),
              child: const Text('Begin', style: TextStyle(color: Color.fromARGB(222, 255, 255, 255))),
              onPressed: () => {
              },
            ),
          ],
        ),
        Column(
          children: [
            const Text('Game #4', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
              ),
              child: const Text('Begin', style: TextStyle(color: Color.fromARGB(222, 255, 255, 255))),
              onPressed: () => {
              },
            ),
          ],
        ),
      ],
    );
  }
}