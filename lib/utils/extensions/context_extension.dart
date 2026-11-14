import 'package:flutter/material.dart';

import '../../presentation/widgets/level_complete/level_complete_widget.dart';
import '../../presentation/widgets/settings_widget.dart';
import '../enums/app_enums.dart';

extension ContextExtension on BuildContext {

  /// This will be shown to view/edit game settings.
  /// If the user is in the game screen, then
  /// [isGameScreen] is true, which is used to show
  /// the home screen and categories icons.
  /// For other screens, this will not shown.
  void showSettingsDialog({
    bool isGameScreen = false,
  }) {
    showDialog(
      context: this,
      builder: (builderCtx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          child: SettingsWidget(
            isGameScreen: isGameScreen,
          ),
        );
      },
    );
  }

  /// This will be shown when the game is completed.
  void showSuccessDialog({
    required Categories category,
    required VoidCallback onReplay,
  }) {
    showDialog(
      context: this,
      barrierDismissible: true,
      useSafeArea: false,
      builder: (builderCtx) {
        return LevelCompleteWidget(
          category: category,
          onReplay: onReplay,
        );
      },
    );
  }
}
