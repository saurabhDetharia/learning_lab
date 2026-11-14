import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_lab/presentation/widgets/button.dart';
import 'package:learning_lab/utils/extensions/context_extension.dart';
import 'package:learning_lab/values/app_colors.dart';
import 'package:learning_lab/values/constants.dart';

import '../../application/provider/learning_lab_app_provider.dart';
import '../../gen/fonts.gen.dart';
import '../../utils/enums/app_enums.dart';

class MainMenuScreen extends ConsumerStatefulWidget {
  const MainMenuScreen({super.key});

  @override
  ConsumerState<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends ConsumerState<MainMenuScreen> {
  Timer? _timer;

  double _scale = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer(
      AppConstants.shortAnimationDuration,
      () {
        setState(() {
          _scale = 1;
        });
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Title
          _getTitleWidget,

          // Icons
          _getButtonsRowWidget,
        ],
      ),
    );
  }

  /// This represents the title widget - app name.
  Widget get _getTitleWidget {
    return AnimatedScale(
      scale: _scale,
      duration: AppConstants.shortAnimationDuration,
      child: Stack(
        children: [
          Text(
            'LearningLab',
            style: TextStyle(
              fontSize: 64,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 15
                ..color = AppColors.buttonShadow,
              shadows: [
                Shadow(
                  color: AppColors.textShadowColor,
                  blurRadius: 50,
                )
              ],
              fontWeight: FontWeight.w900,
              fontFamily: FontFamily.nunito,
            ),
          ),
          Text(
            'LearningLab',
            style: TextStyle(
              fontSize: 64,
              color: AppColors.textColor,
              fontWeight: FontWeight.w900,
              fontFamily: FontFamily.nunito,
            ),
          )
        ],
      ),
    );
  }

  /// This represents the "Settings" icon.
  Widget get _getSettingsIconWidget {
    return Button(
      onTap: () {
        context.showSettingsDialog();
      },
      size: Size.square(60),
      child: Icon(
        CupertinoIcons.gear_alt_fill,
        color: AppColors.iconColor,
        size: 40,
      ),
    );
  }

  /// This represents the "Play" icon.
  Widget get _getPlayIconWidget {
    return Button(
      onTap: () {
        setState(() {
          _scale = 0;
        });
        _timer = Timer(
          AppConstants.shortAnimationDuration,
          () {
            var _screenNotifier = ref.read(screenNotifier.notifier);
            _screenNotifier.navigate(AppScreens.categories, null);
          },
        );
      },
      size: Size.square(60),
      child: Icon(
        CupertinoIcons.play_arrow_solid,
        color: AppColors.iconColor,
        size: 40,
      ),
    );
  }

  /// This represents the "Credits" icon.
  Widget get _getCreditsIconWidget {
    return Button(
      onTap: () {

      },
      size: Size.square(60),
      child: Icon(
        Icons.format_list_bulleted_rounded,
        color: AppColors.iconColor,
        size: 40,
      ),
    );
  }

  /// This represents the bottom row containing icons.
  Widget get _getButtonsRowWidget {
    return AnimatedScale(
      duration: AppConstants.shortAnimationDuration,
      scale: _scale,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Settings Icon
          _getSettingsIconWidget,

          // Space - 12px
          SizedBox(
            width: 48,
          ),

          // Play Icon
          _getPlayIconWidget,

          // Space - 12px
          SizedBox(
            width: 48,
          ),

          // Credits Icon
          _getCreditsIconWidget,
        ],
      ),
    );
  }
}
