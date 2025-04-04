// music_player.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:summerapp/volume_slider.dart';
import 'SongSelector.dart';

class MusicPlayer extends StatefulWidget {
  FirebaseStorage storage; AudioPlayer audioPlayer;
  final String? audioFileName; // Add audioFileName as a parameter

  MusicPlayer({super.key, required this.storage, this.audioFileName, required this.audioPlayer});

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  String formatDuration(Duration d) {
    String minutes = d.inMinutes.toString();
    String seconds = (d.inSeconds - d.inMinutes * 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  void handleSeek(double value) {
    widget.audioPlayer.seek(Duration(seconds: value.toInt()));
  }

  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  StreamSubscription? positionSubscription;
  StreamSubscription? durationSubscription;

  @override
  void initState() {
    super.initState();
    if (widget.audioFileName != null) {
      extractAudio(widget.audioFileName!);
    }
    positionSubscription = widget.audioPlayer.positionStream.listen((p) {
    if (mounted) {
      setState(() => position = p);
      if (position >= duration) {
        widget.audioPlayer.stop();
        widget.audioPlayer.seek(Duration.zero);
        position = Duration.zero;
      }
    }
    });
    durationSubscription = widget.audioPlayer.durationStream.listen((d) {
      if (mounted && d != null) {
        setState(() => duration = d);
      }
    });

  }

  @override
  void dispose() {
    positionSubscription?.cancel();
    durationSubscription?.cancel();
    super.dispose();
  }

  Future<void> extractAudio(String fileName) async {
    final storageRef = widget.storage.ref().child('audio/$fileName');
    try {
      final url = await storageRef.getDownloadURL();
      await widget.audioPlayer.setUrl(url);
    } catch (e) {
      print("Error setting Url for $fileName: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SongSelector(
          audioPlayer: widget.audioPlayer,
          onSongSelected: (selectedSong) {
            extractAudio(selectedSong);
          },
          storage: widget.storage,
        ),
        Text("${formatDuration(position)}/${formatDuration(duration)}"),
        Slider(
          min: 0.0,
          value: position.inSeconds.toDouble(),
          max: duration.inSeconds.toDouble(),
          onChanged: (double value) {
            widget.audioPlayer.pause();
            handleSeek(value);
          },
        ),
        Ink(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
          ),
          child: IconButton(
            iconSize: 35,
            color: Colors.white,
            icon: (widget.audioPlayer.playing
                ? const Icon(Icons.pause)
                : const Icon(Icons.play_arrow)),
            onPressed: _playMusic,
          ),
        ),
        SizedBox(
          width: 200,
          child: VolumeSlider(
            audioPlayer: widget.audioPlayer,
          )
        ),
      ],
    );
  }

  void _playMusic() async {
    if (!widget.audioPlayer.playing) {
      await widget.audioPlayer.play();
    } else {
      await widget.audioPlayer.pause();
    }
  }
}