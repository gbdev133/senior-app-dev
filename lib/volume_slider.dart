import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';

class VolumeSlider extends StatefulWidget {
  final AudioPlayer audioPlayer;
  VolumeSlider({required this.audioPlayer});
  @override
  _VolumeSliderState createState() => _VolumeSliderState();
}

class _VolumeSliderState extends State<VolumeSlider> {
  double _volume = 0.5;
  Timer? _debounceTimer;

  @override
  Widget build(BuildContext context) {
    return Slider(
      activeColor: const Color.fromARGB(255, 0, 30, 119),
      value: _volume,
      onChanged: (value) {
          setState(() {
            _volume = value;
          });
          widget.audioPlayer.setVolume(value);
      },
    );
  }
}