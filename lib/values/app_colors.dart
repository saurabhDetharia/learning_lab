import 'package:flutter/material.dart';

class AppColors {
  
  const AppColors._();
  
  static AppColors get _instance => AppColors._();
  
  factory AppColors() {
    return _instance;
  }

  /// Button -->
  static Color get buttonShadow => Color.fromARGB(255, 74, 87, 159);
  static Color get buttonShadowLight => Color.fromARGB(77, 210, 218, 255);
  static Color get buttonPrimaryTop => Color(0xFF96A4FF);
  static Color get buttonPrimaryBottom => Color(0xFF707FF1);

  /// Icon -->
  static Color get iconColor => Color(0xFF20376A);
  static Color get iconColorDisabled => Color(0xFFD9813D);

  /// Text -->
  static Color get textColor => Color(0xFFFFFFFF);
  static Color get textShadowColor => Color(0xFF20376A);
  static Color get textSecondaryColor => Color(0xFF20376A);

  /// Common UI -->
  static Color get shadowColorLight => Color(0x320B083A);
  static Color get borderColor => Color(0xFFCBD5FF);
  static Color get backgroundColor => Color(0xFF0E1C55);
  static Color get blackColor => Color(0xFF000000);

}