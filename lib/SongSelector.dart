// SongSelector.dart

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SongSelector extends StatefulWidget {
  final AudioPlayer audioPlayer;
  final Function(String) onSongSelected;
  final FirebaseStorage storage;

  SongSelector({
    required this.audioPlayer,
    required this.onSongSelected,
    required this.storage,
  });

  @override
  _SongSelectorState createState() => _SongSelectorState();
}

class _SongSelectorState extends State<SongSelector> {
  List<String> _availableSongs = [];
  bool _isLoading = true;
  String? _error;
  String? curSong;

  @override
  void initState() {
    super.initState();
    _loadSongList();
  }

  Future<void> _loadSongList() async {
    try {
      final ListResult result = await widget.storage.ref('audio').listAll();
      final List<String> songNames = result.items.map((Reference ref) => ref.name).toList();
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_isLoading) 
          const CircularProgressIndicator()
        else if (_error != null)
          Text(_error!)
        else
          Column(
            children: [
              Text('Play Music:'),
              DropdownButton<String>(
                value: curSong,
                items: _availableSongs.map((String songName) {
                  return DropdownMenuItem<String>(
                    value: songName,
                    child: Text(songName),
                  );
                }).toList(),
                onChanged: (String? selectedSong) {
                  if (selectedSong != null) {
                    widget.onSongSelected(selectedSong);
                    if (mounted) {
                      setState(() {
                        curSong = selectedSong;
                      });
                    }
                  }
                },
                hint: const Text('Select a song'),
              ),
            ],
          ),
      ],
    );
  }
}