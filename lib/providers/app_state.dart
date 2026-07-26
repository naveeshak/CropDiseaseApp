import 'package:flutter/material.dart';
import '../models/detection_record.dart';

class AppState extends ChangeNotifier {
  String languageCode = 'en'; // 'en' or 'si'

  final List<DetectionRecord> history = [];

  void setLanguage(String code) {
    languageCode = code;
    notifyListeners();
  }

  void addToHistory(DetectionRecord record) {
    history.insert(0, record);
    notifyListeners();
  }

  void deleteHistoryItem(int index) {
    history.removeAt(index);
    notifyListeners();
  }

  void clearHistory() {
    history.clear();
    notifyListeners();
  }
}