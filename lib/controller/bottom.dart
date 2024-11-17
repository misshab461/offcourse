import 'package:flutter/material.dart';

class BottomNotifier extends ChangeNotifier {
  int counter = 0;
  int get index => counter;

  void changeIndex(int count) {
    counter = count;
    notifyListeners();
  }
}
