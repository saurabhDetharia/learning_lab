import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../application/provider/learning_lab_app_provider.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/enums/app_enums.dart';
import '../../../../values/learning_lab_theme.dart';
import '../../../widgets/button.dart';

class CategoryItemWidget extends ConsumerWidget {
  const CategoryItemWidget({
    required this.category,
    this.compact = false,
    super.key,
  });

  final Categories category;
  final bool compact;

  Color get _cardColor => switch (category) {
        Categories.alphabets => const Color(0xFFFFE5DE),
        Categories.numbers => const Color(0xFFE0F2FC),
        Categories.shape => const Color(0xFFEAE4FC),
        Categories.colors => const Color(0xFFDDF3E9),
      };

  Color get _accentColor => switch (category) {
        Categories.alphabets => LearningLabTheme.coral,
        Categories.numbers => const Color(0xFF5AAED5),
        Categories.shape => const Color(0xFF9A82D6),
        Categories.colors => LearningLabTheme.teal,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imagePath = Assets.images.values.firstWhere(
      (image) => image.path.split('/').last == '${category.name}.png',
    ).path;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Button(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          isElevated: false,
          onTap: () => ref
              .read(screenNotifier.notifier)
              .navigate(AppScreens.dragDropGame, category),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(LearningLabTheme.cardRadius),
              border: Border.all(
                color: _accentColor.withOpacity(0.2),
                width: 1.5,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x10263451),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: compact ? 10 : 14,
                vertical: compact ? 7 : 9,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.medium,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    category.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: compact ? 17 : 19,
                      fontWeight: FontWeight.w900,
                      color: LearningLabTheme.ink,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
