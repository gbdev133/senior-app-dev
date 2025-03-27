import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'game.dart';
import 'questions.dart';

class GamePage extends StatefulWidget {
  final List<Question> questions;
  GamePage({super.key, required this.questions});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
        ),
        child: const Text('Begin'),
        onPressed: () => {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Game(questions: widget.questions))
          )
        },
      ),
    );
  }
}