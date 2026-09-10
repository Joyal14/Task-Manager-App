import 'package:flutter/material.dart';
import 'package:flutter_base/network/service/navigation_locator.dart';
import 'package:flutter_base/network/service/navigation_service.dart';
import 'package:flutter_base/screens/home/view/home_screen.dart';


class LoginProvider with ChangeNotifier {

  final NavigationService _navigationService = locator<NavigationService>();
  bool isLoggedIn = false;

  bool get isUserLoggedIn {
    return isLoggedIn;
  }

  set isUserLoggedIn(val) {
    if (val == "" || val == null){
      isLoggedIn = false;
    } else {
      isLoggedIn = val;
    }
    //notifyListeners();
  }

  void onSignUpClicked() {
    isUserLoggedIn = true;
    _navigationService.pushReplacementAndNavigateTo(HomeScreen.routeName);
  }
}