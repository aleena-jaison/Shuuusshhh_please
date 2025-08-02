import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class ShushButton extends StatefulWidget {
  const ShushButton({super.key});

  @override
  State<ShushButton> createState() => _ShushButtonState();
}

class _ShushButtonState extends State<ShushButton> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {
          await _audioPlayer.play(AssetSource('shush.mp3'));
        } catch (e) {
          // Handle audio playback error silently or show a snackbar
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Could not play shush sound'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      ),
      child: const Text('SHUSH!', style: TextStyle(fontSize: 24)),
    );
  }
}
