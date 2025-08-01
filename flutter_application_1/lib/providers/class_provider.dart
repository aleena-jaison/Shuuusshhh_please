import 'package:flutter/material.dart';
import '../models/class_model.dart';

class ClassProvider with ChangeNotifier {
  List<ClassModel> _classes = [
    ClassModel(name: 'My Class', score: 100.0),
    ClassModel(name: 'Class B', score: 95.5),
    ClassModel(name: 'Class C', score: 92.3),
  ];

  List<ClassModel> get classes => _classes;

  void updateScore(String className, double newScore) {
    final classIndex = _classes.indexWhere((c) => c.name == className);
    if (classIndex != -1) {
      _classes[classIndex].score = newScore;
      _classes.sort((a, b) => b.score.compareTo(a.score));
      notifyListeners();
    }
  }
}
