import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:firebase_storage/firebase_storage.dart';



class SongSelector extends StatefulWidget {
  final AudioPlayer audioPlayer;
  final Function(String) onSongSelected; // Callback for when a song is selected
  final FirebaseStorage storage;
  SongSelector({
    required this.audioPlayer, 
    required this.onSongSelected,
    required this.storage,
    Key? key,
  }) : super(key: key);

  @override
  _SongSelectorState createState() => _SongSelectorState();
}

class _SongSelectorState extends State<SongSelector> {
  List<String> _songs = [];
  String _selectedSong = '';
  final String _storagePath = 'audio/';

 @override
  void initState() {
    super.initState();
    _loadSongsFromFirebase();
  }

  Future<void> _loadSongsFromFirebase() async {
    try {
      final ListResult result = await widget.storage // Use the passed instance
          .ref(_storagePath)
          .listAll();

       // Extract the file names from the ListResult
      final List<String> fileNames =
          result.items.map((Reference ref) => ref.name).toList();

      setState(() {
        _songs = fileNames;
        if (_songs.isNotEmpty) {
          _selectedSong = _songs[0]; // Set the initial selected song
          // Optionally, trigger the loading of the first song here if needed
          widget.onSongSelected(_selectedSong);
        }
      });
      for (String s in fileNames) {
        print(s);
      }
    } catch (e) {
      print("Error loading songs from Firebase Storage: $e");
      setState(() {
        _songs = [];
        _selectedSong = ''; // Ensure a default even on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Select a song:'),
        DropdownButton<String>(
          value: _selectedSong.isNotEmpty ? _selectedSong : null,
          hint: const Text('No songs available'),
          onChanged: _songs.isNotEmpty
              ? (String? value) {
                  if (value != null) {
                    setState(() {
                      _selectedSong = value;
                      widget.onSongSelected(_selectedSong);
                    });
                  }
                }
              : null,
          items: _songs.map((song) {
            return DropdownMenuItem<String>(
              value: song,
              child: Text(song),
            );
          }).toList(),
        ),
      ],
    );
  }
}