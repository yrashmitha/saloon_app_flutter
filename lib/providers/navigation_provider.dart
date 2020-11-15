import 'package:flutter/material.dart';

class NavigationProvider with ChangeNotifier {
  int _pageIndex = 0;
  int get page => _pageIndex;

  changePage(int i) {
    _pageIndex = i;
    print('page index called $i');
    notifyListeners();
  }
}