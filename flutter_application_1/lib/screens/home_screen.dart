import 'package:flutter/material.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:provider/provider.dart';
import '../providers/class_provider.dart';
import '../widgets/shush_button.dart';
import 'leaderboard_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NoiseReading? _latestReading;
  double _silenceScore = 100.0;

  @override
  void initState() {
    super.initState();
    NoiseMeter().noiseStream.listen((noiseReading) {
      setState(() {
        _latestReading = noiseReading;
        _updateSilenceScore();
      });
    });
  }

  void _updateSilenceScore() {
    if (_latestReading?.meanDecibel != null && _latestReading!.meanDecibel > 50) {
      _silenceScore -= 0.5;
    } else if (_silenceScore < 100) {
      _silenceScore += 0.1;
    }
    Provider.of<ClassProvider>(
      context,
      listen: false,
    ).updateScore('My Class', _silenceScore);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Silence Score'),
        actions: [
          IconButton(
            icon: Icon(Icons.leaderboard),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => LeaderboardScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${_silenceScore.toStringAsFixed(1)}',
              style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            ShushButton(),
          ],
        ),
      ),
    );
  }
}
