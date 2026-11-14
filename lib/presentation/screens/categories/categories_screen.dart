import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_lab/presentation/screens/categories/widget/category_item_widget.dart';
import 'package:learning_lab/utils/extensions/context_extension.dart';
import 'package:learning_lab/values/app_colors.dart';

import '../../../application/provider/learning_lab_app_provider.dart';
import '../../../gen/fonts.gen.dart';
import '../../../utils/enums/app_enums.dart';
import '../../../values/constants.dart';
import '../../widgets/button.dart';
import 'provider/categories_screen_provider.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  late double _scale;
  Timer? _timer;

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

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title Row
          _getTitleRowWidget,

          // Categories list
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (itemBuilderCtx, index) {
                final category = Categories.values[index];
                return CategoryItemWidget(category: category);
              },
              separatorBuilder: (separatorBuilderCtx, index) {
                return SizedBox(
                  width: 10,
                );
              },
              itemCount: Categories.values.length,
            ),
          ),

          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  /// Title row
  Widget get _getTitleRowWidget {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Back icon
        _getBackIconWidget,

        // Title,
        _getTitleWidget,

        // Settings icon
        _getSettingsIconWidget,
      ],
    );
  }

  /// This represents the "Back" icon.
  Widget get _getBackIconWidget {
    return AnimatedScale(
      scale: _scale,
      duration: AppConstants.shortAnimationDuration,
      child: Button(
        onTap: () {
          ref.read(scaleProvider.notifier).state = 0;
          _timer = Timer(
            AppConstants.shortAnimationDuration,
            () {
              var _screenNotifier = ref.read(screenNotifier.notifier);
              _screenNotifier.navigate(AppScreens.mainMenu, null);
            },
          );
        },
        child: Icon(
          Icons.arrow_back,
          color: AppColors.iconColor,
          size: 20,
        ),
      ),
    );
  }

  /// This represents the "Settings" icon.
  Widget get _getSettingsIconWidget {
    return AnimatedScale(
      scale: _scale,
      duration: AppConstants.shortAnimationDuration,
      child: Button(
        onTap: () {
          context.showSettingsDialog();
        },
        child: Icon(
          CupertinoIcons.bars,
          color: AppColors.iconColor,
          size: 20,
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
            'LearningLab',
            style: TextStyle(
              fontSize: 30,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 10
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
              fontSize: 30,
              color: AppColors.textColor,
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
