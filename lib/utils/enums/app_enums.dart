import 'package:flutter/material.dart';

import '../../presentation/screens/categories/categories_screen.dart';
import '../../presentation/screens/drag_drop_game/drag_drop_game_screen.dart';
import '../../presentation/screens/main_menu.dart';

enum AppScreens {
  mainMenu(MainMenuScreen()),
  categories(CategoriesScreen()),
  dragDropGame(DragDropGameScreen()),
  ;

  const AppScreens(
    this.child,
  );

  final Widget child;
}

// Enum to represent the state of the audio player
enum AudioPlayerState {
  playing,
  paused,
  stopped,
  loading,
  error,
}

enum Categories {
  alphabets('Alphabets'),
  numbers('Numbers'),
  shape('Shapes'),
  colors('Colors'),
  ;

  const Categories(this.title);

  final String title;
}
