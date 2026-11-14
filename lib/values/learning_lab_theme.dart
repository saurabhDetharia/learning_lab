import 'package:flutter/material.dart';

/// Shared visual language for the LearningLab preschool experience.
abstract final class LearningLabTheme {
  static const cream = Color(0xFFFFF9EF);
  static const ink = Color(0xFF263451);
  static const mutedInk = Color(0xFF71809A);
  static const teal = Color(0xFF36B8A5);
  static const tealDark = Color(0xFF218F83);
  static const coral = Color(0xFFFF8B78);
  static const yellow = Color(0xFFFFD166);
  static const sky = Color(0xFF9ADCF2);
  static const lavender = Color(0xFFC9B8F4);
  static const mint = Color(0xFFBCE9D5);
  static const cardBorder = Color(0xFFF0E8DC);

  static const pagePadding = 28.0;
  static const cardRadius = 28.0;
  static const controlRadius = 22.0;

  static TextTheme textTheme = const TextTheme(
    headlineLarge: TextStyle(
      fontFamily: 'Nunito',
      fontSize: 42,
      fontWeight: FontWeight.w900,
      color: ink,
      height: 1.05,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Nunito',
      fontSize: 30,
      fontWeight: FontWeight.w900,
      color: ink,
    ),
    titleLarge: TextStyle(
      fontFamily: 'Nunito',
      fontSize: 22,
      fontWeight: FontWeight.w800,
      color: ink,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Nunito',
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: ink,
    ),
  );
}
