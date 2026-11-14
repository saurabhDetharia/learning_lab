import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_lab/application/provider/learning_lab_app_provider.dart';
import 'package:learning_lab/presentation/screens/categories/provider/categories_screen_provider.dart';
import 'package:learning_lab/presentation/widgets/shadow_widget.dart';
import 'package:learning_lab/utils/enums/app_enums.dart';
import 'package:learning_lab/values/constants.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../gen/fonts.gen.dart';
import '../../../../values/app_colors.dart';
import '../../../widgets/button.dart';

class CategoryItemWidget extends ConsumerWidget {
  const CategoryItemWidget({
    required this.category,
    super.key,
  });

  final Categories category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the current scale value from the provider
    final _scale = ref.watch(scaleProvider);

    return AnimatedScale(
      duration: AppConstants.shortAnimationDuration,
      scale: _scale,
      child: Column(
        children: [
          Button(
            size: Size.square(180),
            isElevated: false,
            onTap: () {
              ref.read(scaleProvider.notifier).state = 0;
              Timer(
                AppConstants.shortAnimationDuration,
                () {
                  ref.read(screenNotifier.notifier).navigate(
                        AppScreens.dragDropGame,
                        category,
                      );
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ShadowWidget(
                color: AppColors.buttonShadow,
                sigma: 4,
                offset: const Offset(5, 5),
                child: Image.asset(
                  Assets.images.values.firstWhere((images) {
                    return images.path.split('/').last ==
                        '${category.name}.png';
                  }).path,
                ),
              ),
            ),
          ),
          _getTitleWidget(_scale),
        ],
      ),
    );
  }

  /// This represents the title widget - app name.
  Widget _getTitleWidget(double scale) {
    return AnimatedScale(
      scale: scale,
      duration: AppConstants.shortAnimationDuration,
      child: Stack(
        children: [
          Text(
            category.title,
            style: TextStyle(
              fontSize: 24,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 5
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
            category.title,
            style: TextStyle(
              fontSize: 24,
              color: AppColors.textColor,
              fontWeight: FontWeight.w900,
              fontFamily: FontFamily.nunito,
            ),
          )
        ],
      ),
    );
  }
}
