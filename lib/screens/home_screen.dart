import 'package:flutter/material.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '/providers/class_provider.dart';
import '/widgets/shush_button.dart';
import 'leaderboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  /// _HomeScreenState is a state class for the HomeScreen widget in a Flutter application. It manages
  /// the state of the HomeScreen widget, including handling the noise readings, updating the silence
  /// score, and building the UI components like the header, score display, noise information, and
  /// buttons. The class listens to noise readings using the NoiseMeter package, updates the silence
  /// score based on the noise level, and displays the score along with status indicators. It also
  /// provides functionality for navigating to the leaderboard screen and updating the score in the
  /// ClassProvider using the Provider package.
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NoiseReading? _latestReading;
  double _silenceScore = 100.0;
  bool _hasPermission = false;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _requestMicrophonePermission();
  }

  Future<void> _requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    setState(() {
      _hasPermission = status == PermissionStatus.granted;
    });

    if (_hasPermission) {
      _startListening();
    } else {
      _showPermissionDialog();
    }
  }

  void _startListening() {
    if (_hasPermission && !_isListening) {
      setState(() {
        _isListening = true;
      });

      NoiseMeter().noise.listen((noiseReading) {
        if (mounted) {
          setState(() {
            _latestReading = noiseReading;
            _updateSilenceScore();
          });
        }
      });
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Microphone Permission Required'),
          content: const Text(
            'This app needs microphone access to monitor noise levels. Please grant permission in the app settings.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: const Text('Settings'),
            ),
          ],
        );
      },
    );
  }

  void _updateSilenceScore() {
    if (_latestReading?.meanDecibel != null &&
        _latestReading!.meanDecibel > 50) {
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      _buildScoreDisplay(),
                      const SizedBox(height: 30),
                      _buildNoiseInfo(),
                      const SizedBox(height: 40),
                      Expanded(child: Center(child: const ShushButton())),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () {},
            ),
          ),
          const Spacer(),
          const Column(
            children: [
              Text(
                'Silence Monitor',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Keep it quiet!',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.leaderboard, color: Colors.white),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LeaderboardScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreDisplay() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF667eea).withValues(alpha: 0.8),
                  const Color(0xFF764ba2).withValues(alpha: 0.8),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF667eea).withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _hasPermission ? _silenceScore.toStringAsFixed(1) : '--',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'SCORE',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: _getScoreColor().withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(
              _getScoreStatus(),
              style: TextStyle(
                color: _getScoreColor(),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoiseInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: !_hasPermission
          ? Column(
              children: [
                const Icon(Icons.mic_off, color: Colors.red, size: 48),
                const SizedBox(height: 10),
                const Text(
                  'Microphone Permission Required',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Please enable microphone access to monitor noise levels.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _requestMicrophonePermission,
                  child: const Text('Grant Permission'),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem(
                  'Current Level',
                  _latestReading?.meanDecibel.toStringAsFixed(1) ?? '--',
                  'dB',
                  Icons.volume_up,
                ),
                Container(width: 1, height: 40, color: Colors.grey[300]),
                _buildInfoItem(
                  'Status',
                  _latestReading?.meanDecibel != null &&
                          _latestReading!.meanDecibel > 50
                      ? 'Noisy'
                      : 'Quiet',
                  '',
                  _latestReading?.meanDecibel != null &&
                          _latestReading!.meanDecibel > 50
                      ? Icons.volume_up
                      : Icons.volume_off,
                ),
              ],
            ),
    );
  }

  Widget _buildInfoItem(
    String label,
    String value,
    String unit,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF667eea), size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: const TextStyle(
                  color: Color(0xFF2D3748),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (unit.isNotEmpty)
                TextSpan(
                  text: ' $unit',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getScoreColor() {
    if (!_hasPermission) return Colors.grey;
    if (_silenceScore >= 80) return Colors.green;
    if (_silenceScore >= 60) return Colors.orange;
    return Colors.red;
  }

  String _getScoreStatus() {
    if (!_hasPermission) return 'PERMISSION REQUIRED';
    if (_silenceScore >= 80) return 'EXCELLENT';
    if (_silenceScore >= 60) return 'GOOD';
    if (_silenceScore >= 40) return 'FAIR';
    return 'NEEDS IMPROVEMENT';
  }
}
