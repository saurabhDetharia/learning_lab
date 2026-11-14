import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_lab/utils/extensions/navigation_extension.dart';
import 'package:lottie/lottie.dart';

import '../../../application/provider/learning_lab_app_provider.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/fonts.gen.dart';
import '../../../utils/enums/app_enums.dart';
import '../../../values/app_colors.dart';
import '../../../values/constants.dart';
import '../../widgets/level_complete/provider/level_complete_widget_provider.dart';
import '../button.dart';

class LevelCompleteWidget extends ConsumerStatefulWidget {
  const LevelCompleteWidget({
    required this.category,
    required this.onReplay,
    super.key,
  });

  final Categories category;
  final VoidCallback onReplay;

  @override
  ConsumerState<LevelCompleteWidget> createState() =>
      _LevelCompleteWidgetState();
}

class _LevelCompleteWidgetState extends ConsumerState<LevelCompleteWidget> {
  late double _scale;
  Timer? _timer;
  LottieDecoder? lottieDecoder;

  @override
  void initState() {
    super.initState();
    _animate();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the current scale value from the provider
    _scale = ref.watch(scaleProvider);

    return Container(
      color: AppColors.blackColor.withAlpha(99),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Popper
          Lottie.asset(
            Assets.lottie.success,
            decoder: customDecoder,
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Main content
              _getTitleWidget,

              // Icons
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Replay icon
                  _getReplayIconWidget,

                  // Horizontal space - 12px
                  SizedBox(
                    width: 28,
                  ),

                  // Category icon
                  _getCategoryIconWidget,

                  // Horizontal space - 12px
                  SizedBox(
                    width: 28,
                  ),

                  // Home icon
                  _getHomeIconWidget,
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// This is used to decode the lottie file.
  Future<LottieComposition?> customDecoder(List<int> bytes) {
    return LottieComposition.decodeZip(bytes, filePicker: (files) {
      return files.firstWhere((f) {
        return f.name == 'animations/d839f3f9-f635-4c6f-90f4-f3fb02c89fda.json';
      });
    });
  }

  /// Below is used as Replay icon.
  Widget get _getReplayIconWidget {
    return AnimatedScale(
      scale: _scale,
      duration: AppConstants.shortAnimationDuration,
      child: Button(
        size: Size.square(60),
        onTap: () {
          ref.read(scaleProvider.notifier).state = 0;
          _timer = Timer(
            AppConstants.shortAnimationDuration,
            () {
              context.pop();
              widget.onReplay.call();
            },
          );
        },
        child: Icon(
          Icons.replay_rounded,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }

  /// Below is used as Category icon.
  Widget get _getCategoryIconWidget {
    return AnimatedScale(
      scale: _scale,
      duration: AppConstants.shortAnimationDuration,
      child: Button(
        size: Size.square(60),
        onTap: () {
          ref.read(scaleProvider.notifier).state = 0;
          _timer = Timer(
            AppConstants.shortAnimationDuration,
            () {
              context.pop();
              var _screenNotifier = ref.read(screenNotifier.notifier);
              _screenNotifier.navigate(AppScreens.categories, null);
            },
          );
        },
        child: Icon(
          CupertinoIcons.square_grid_2x2_fill,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }

  /// Below is used as Home icon.
  Widget get _getHomeIconWidget {
    return AnimatedScale(
      scale: _scale,
      duration: AppConstants.shortAnimationDuration,
      child: Button(
        size: Size.square(60),
        onTap: () {
          ref.read(scaleProvider.notifier).state = 0;
          _timer = Timer(
            AppConstants.shortAnimationDuration,
            () {
              context.pop();
              var _screenNotifier = ref.read(screenNotifier.notifier);
              _screenNotifier.navigate(AppScreens.mainMenu, null);
            },
          );
        },
        child: Icon(
          CupertinoIcons.house_fill,
          color: Colors.white,
          size: 32,
        ),
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
            'Congratulations!',
            style: TextStyle(
              fontSize: 30,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 10
                ..color = Colors.white.withAlpha(70),
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
            'Congratulations!',
            style: TextStyle(
              fontSize: 30,
              color: AppColors.borderColor,
              fontWeight: FontWeight.w900,
              fontFamily: FontFamily.nunito,
            ),
          )
        ],
      ),
    );
  }

  void _animate() {
    _timer = Timer(
      AppConstants.shortAnimationDuration,
      () {
        ref.read(scaleProvider.notifier).state = 1.0;
      },
    );
  }
}
