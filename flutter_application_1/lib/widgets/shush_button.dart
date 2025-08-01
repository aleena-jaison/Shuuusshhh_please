import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class ShushButton extends StatelessWidget {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _audioPlayer.play(AssetSource('Female Shushing - QuickSounds.com.mp3'));
      },
      child: Text('SHUSH!', style: TextStyle(fontSize: 24)),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      ),
    );
  }
}
