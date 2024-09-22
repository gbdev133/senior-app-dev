import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'questions.dart';
import 'quiz.dart';
import 'chat.dart';
import 'game.dart';
import 'gamepage.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'home'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;
  List<Widget> contacts = [];
  List<Question> questions = [
    Question(
      question: "What is Flutter?",
      options: ["A bird", "A framework", "A car", "A language"],
      correctAnswerIndex: 1,
    ),
    Question(
      question: "Who developed Flutter?",
      options: ["Apple", "Google", "Facebook", "Microsoft"],
      correctAnswerIndex: 1,
    )
  ];


  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (currentPageIndex) {
      case 0:
        page = defaultPage();
      case 1:
        page = GamePage(questions: questions);
      case 2:
        page = Chat(contacts: contacts);
      default:
        throw UnimplementedError("no page $currentPageIndex");
    }



    return Scaffold(
        bottomNavigationBar: NavigationBar(
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            indicatorColor: Colors.blue,
            selectedIndex: currentPageIndex,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: const <Widget>[
              NavigationDestination(
                selectedIcon: Icon(Icons.home),
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),

              NavigationDestination(
                icon: Icon(Icons.sports_esports),
                label: "Memory Game",
              ),

              NavigationDestination(
                icon: Icon(Icons.question_answer_sharp),
                label: "Chat",
              ),
            ]
        ),
        body: page,
    );
  }
}

class defaultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Home Page"),
              ],
            )
          ],
        )
    );
  }
}



