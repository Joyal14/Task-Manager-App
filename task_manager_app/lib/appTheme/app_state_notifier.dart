import 'package:flutter/material.dart';
 
class AppStateNotifier extends ChangeNotifier {
  
  bool isDarkMode = false;

  bool get appMode {
    return isDarkMode;
  }

  set appMode(val) {
    if (val == "" || val == null){
      isDarkMode = false;
      notifyListeners();
    } else {
      isDarkMode = val;
      notifyListeners();
    }
  }

}