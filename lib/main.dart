import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'music_player.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:math';
import 'firebase_options.dart';
import 'questions.dart';
import 'chat.dart';
import 'gamepage.dart';

final FirebaseStorage storage = FirebaseStorage.instance;
final AudioPlayer audioPlayer = AudioPlayer();
List<String> songList = [];

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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  late CollectionReference _questionsCollection;
  late MusicPlayer musicPlayer;

  @override
  void initState() {
    super.initState();
     _questionsCollection = _firestore.collection('questions');
  }


  void stopAudio() {
    if (audioPlayer.playing) {
      audioPlayer.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (currentPageIndex) {
      case 0:
        page = defaultPage(audioPlayer: audioPlayer, onStopAudio: stopAudio);
      case 1:
        page = GamePage(songList: songList, storage: storage);
      case 2:
        page = Chat(contacts: contacts);
      default:
        throw UnimplementedError("no page $currentPageIndex");
    }



    return Scaffold(
        bottomNavigationBar: NavigationBar(
            onDestinationSelected: (int index) {
              setState(() {
                if (currentPageIndex == 0 && index != 0) {
                  audioPlayer.stop();
                  
                }
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
                label: 'Music',
              ),

              NavigationDestination(
                icon: Icon(Icons.sports_esports),
                label: "Memory Games",
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


class defaultPage extends StatefulWidget {
  AudioPlayer audioPlayer;
  final Function onStopAudio;
  defaultPage({super.key, required this.audioPlayer, required this.onStopAudio});

  @override
  State<defaultPage> createState() => defaultPageState();
}

class defaultPageState extends State<defaultPage> {
  List<String> _availableSongs = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSongList();
  }

  Future<void> _loadSongList() async {
    try {
      final ListResult result = await storage.ref('audio').listAll();
      final List<String> songNames =
          result.items.map((Reference ref) => ref.name).toList();
      if (mounted) {
        setState(() {
          _availableSongs = songNames;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Error loading songs: $e';
          _isLoading = false;
        });
      }
    }
  }

  void _toggleSongInList(String songName) {
    setState(() {
      if (songList.contains(songName)) {
        songList.remove(songName);
        print('Removed $songName from songList: $songList');
      } else {
        songList.add(songName);
        print('Added $songName to songList: $songList');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select the songs for the game below:"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(child: Text(_error!))
                      : RawScrollbar(
                          thickness: 6.0,
                          thumbColor: Colors.lightBlue,
                          child: ListView.builder(
                            primary: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: _availableSongs.length,
                            itemBuilder: (context, index) {
                              final songName = _availableSongs[index];
                              return ListTile(
                                title: Text(songName),
                                trailing: songList.contains(songName) ? const Icon(Icons.check) : null,
                                onTap: () {
                                  _toggleSongInList(songName);
                                  // You might want to trigger the MusicPlayer to play the last selected song
                                  // or have a separate "Play" button based on the songList.
                                },
                              );
                            },
                          ),
                        ),
            ),
            MusicPlayer(
                key: UniqueKey(),
                storage: storage,
                audioPlayer: audioPlayer,
            ),
          ],
        ),
      ),
    );
  }
}



