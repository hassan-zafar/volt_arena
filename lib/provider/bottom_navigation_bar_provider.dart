import 'package:flutter/material.dart';

class BottomNavigationBarProvider extends ChangeNotifier {
  // ignore: prefer_final_fields
  int _selectedPage = 0;

  void updateSelectedPage(int updatedPage) {
    _selectedPage = updatedPage;
    notifyListeners();
  }

  int get selectedPage => _selectedPage;
}