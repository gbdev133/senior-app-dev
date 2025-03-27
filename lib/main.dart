import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'music_player.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as Path;
import 'firebase_options.dart';
import 'questions.dart';
import 'chat.dart';
import 'gamepage.dart';


Future<void> main() async {
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
  List<Question> questions = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _questionsCollection;

  @override
  void initState() {
    super.initState();
     _questionsCollection = _firestore.collection('questions');
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
        final QuerySnapshot snapshot = await _questionsCollection.get(GetOptions(source: Source.server));
        for (var doc in snapshot.docs) {
            final data = doc.data() as Map<String, dynamic>;
            print('Document ID: ${doc.id}');
            print('Document Data: $data');
            

            final questionValue = data['question'];
            final options = List<String>.from(data['options']);
            final correctAnswerIndex = data['correctAnswerIndex'];
            print(options.runtimeType);
            print(correctAnswerIndex.runtimeType);

            if (questionValue == null) {
                print('Warning: Question value is null in document ${doc.id}');
            } else if (questionValue is String) {
                print('Question value is a String: $questionValue');
                questions.add(Question(
                    question: questionValue,
                    options: options,
                    correctAnswerIndex: correctAnswerIndex,
                ));
            } else {
                print('Warning: Question value is not a String in document ${doc.id}, it is a ${questionValue.runtimeType}');
            }
        }
        print('Loaded ${questions.length} questions.');
    } catch (e) {
        print('Error loading questions: $e');
    }
  }




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
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(),
            ),
            MusicPlayer(key: key, audioFileName: 's1.mp3'),
            
          ],
        ),
      ),
    );
  }
}



