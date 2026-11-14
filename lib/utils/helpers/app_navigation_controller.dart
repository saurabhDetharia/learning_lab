import 'package:flutter/material.dart';
import 'package:learning_lab/utils/enums/app_enums.dart';

class AppNavigationController extends ChangeNotifier {
  dynamic args;
  AppScreens screen = AppScreens.mainMenu;

  navigate(
    AppScreens newScreen,
    dynamic arguments,
  ) {
    screen = newScreen;
    args = arguments;
    notifyListeners();
  }
}
