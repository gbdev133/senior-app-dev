import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'SongSelector.dart';

class MusicPlayer extends StatefulWidget {
  String audioFileName;
  MusicPlayer({super.key, required this.audioFileName});
  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final storage = FirebaseStorage.instance;
  final AudioPlayer _audioPlayer = AudioPlayer();

  String formatDuration(Duration d) {
    String minutes = d.inMinutes.toString();
    String seconds = (d.inSeconds - d.inMinutes * 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  void handleSeek(double value) {
    _audioPlayer.seek(Duration(seconds: value.toInt()));
  }

  Duration position = Duration.zero;
  Duration duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    extractAudio(widget.audioFileName); // Load initial audio
    _audioPlayer.positionStream.listen((p) {
      setState(() => position = p);
      if (p >= duration) {
        _audioPlayer.stop();
        position = Duration.zero;
      }
    });
    _audioPlayer.durationStream.listen((d) {
      setState(() => duration = d!);
    });
  }

  Future<void> extractAudio(String fileName) async {
    final storageRef = storage.ref().child('audio/$fileName');
    try {
      final url = await storageRef.getDownloadURL(); //Get download URL
      await _audioPlayer.setUrl(url);
    } catch (e) {
      print("Error setting Url for $fileName: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SongSelector(
          audioPlayer: _audioPlayer,
          onSongSelected: (selectedSong) {
            extractAudio(selectedSong);
          },
          storage: storage,
        ),
        Text(formatDuration(position)),
        Slider(
          min: 0.0,
          value: position.inSeconds.toDouble(),
          max: duration.inSeconds.toDouble(),
          onChanged: (double value) {
            _audioPlayer.pause();
            handleSeek(value);
          },
        ),
        Text(formatDuration(duration)),
        Ink(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
          ),
          child: IconButton(
            iconSize: 35,
            color: Colors.white,
            icon: (_audioPlayer.playing
                ? const Icon(Icons.pause)
                : const Icon(Icons.play_arrow)),
            onPressed: _playMusic,
          ),
        ),
        SizedBox(
          width: 200, // or any other width you want
          child: Slider(
            value: _audioPlayer.volume,
            max: 1,
            min: 0.0,
            onChanged: (value) {
              setState(() {
                _audioPlayer.setVolume(value);
              });
            },
          ),
        ),
      ],
    );
  }

  void _playMusic() async {
    if (!_audioPlayer.playing) {
      await _audioPlayer.play();
    } else {
      await _audioPlayer.pause();
    }
  }

}


