import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/class_provider.dart';

class LeaderboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final classProvider = Provider.of<ClassProvider>(context);
    final classes = classProvider.classes;

    return Scaffold(
      appBar: AppBar(title: Text('Leaderboard')),
      body: ListView.builder(
        itemCount: classes.length,
        itemBuilder: (context, index) {
          final classData = classes[index];
          return ListTile(
            leading: index == 0
                ? Icon(Icons.emoji_events, color: Colors.amber)
                : Text('${index + 1}'),
            title: Text(classData.name),
            trailing: Text(classData.score.toStringAsFixed(1)),
          );
        },
      ),
    );
  }
}
