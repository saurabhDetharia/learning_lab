import 'package:flutter/material.dart';

import '../gen/assets.gen.dart';

class AppConstants {
  AppConstants._();

  static AppConstants get _instance => AppConstants._();

  factory AppConstants() {
    return _instance;
  }

  // Default animation duration.
  static final Duration animationDuration = Duration(
    milliseconds: 900,
  );

  // Short animation duration.
  static final Duration shortAnimationDuration = Duration(
    milliseconds: 200,
  );

  static final Map<Color, String> colors = {
    Color(0xFF2196F3): 'Blue',
    Color(0xFFF44336): 'Red',
    Color(0xFFFFEB3B): 'Yellow',
    Color(0xFF4CAF50): 'Green',
    Color(0xFFFF9800): 'Orange',
    Color(0xFF000000): 'Black',
    Color(0xFFFFFFFF): 'White',
    Color(0xFF9C27B0): 'Purple',
    Color(0xFFE91E63): 'Pink',
    Color(0xFF8BC34A): 'Light Green',
    Color(0xFF3F51B5): 'Indigo',
  };

  static final Map<String, String> shapes = {
    Assets.vectors.ellipse: 'Circle',
    Assets.vectors.triangle: 'Triangle',
    Assets.vectors.rectangle: 'Square',
    Assets.vectors.pentagon: 'Pentagon',
    Assets.vectors.hexagon: 'Hexagon',
    Assets.vectors.septagon: 'Septagon',
    Assets.vectors.octagon: 'Octagon',
    Assets.vectors.nonagon: 'Nonagon',
    Assets.vectors.decagon: 'Decagon',
  };
}
