import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_lab/presentation/screens/categories/widget/category_item_widget.dart';
import 'package:learning_lab/utils/extensions/context_extension.dart';

import '../../../application/provider/learning_lab_app_provider.dart';
import '../../../utils/enums/app_enums.dart';
import '../../../values/learning_lab_theme.dart';
import '../../widgets/button.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ColoredBox(
      color: LearningLabTheme.cream,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isLandscape = constraints.maxWidth > constraints.maxHeight;
            final compact = isLandscape ||
                constraints.maxHeight < 500 ||
                constraints.maxWidth < 680;
            final horizontalPadding = constraints.maxWidth < 600 ? 16.0 : 32.0;

            return Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                compact ? 10 : 18,
                horizontalPadding,
                compact ? 12 : 22,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Button(
                        size: const Size(48, 48),
                        isElevated: true,
                        onTap: () => ref
                            .read(screenNotifier.notifier)
                            .navigate(AppScreens.mainMenu, null),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'LearningLab',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                          color: LearningLabTheme.ink,
                        ),
                      ),
                      const Spacer(),
                      Button(
                        size: const Size(48, 48),
                        isElevated: true,
                        onTap: () => context.showSettingsDialog(),
                        child: const Icon(
                          CupertinoIcons.gear_alt_fill,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: compact ? 8 : 14),
                  Text(
                    'What shall we learn today?',
                    textAlign: TextAlign.center,
                    style: (compact
                            ? LearningLabTheme.textTheme.headlineMedium
                            : LearningLabTheme.textTheme.headlineLarge)
                        .copyWith(
                      fontSize: compact ? 27 : 36,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Pick a fun activity to get started!',
                    textAlign: TextAlign.center,
                    style: LearningLabTheme.textTheme.bodyLarge.copyWith(
                      color: LearningLabTheme.mutedInk,
                      fontSize: compact ? 15 : 17,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1040),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: Categories.values.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isLandscape
                                ? 4
                                : constraints.maxWidth >= 560
                                    ? 2
                                    : 1,
                            crossAxisSpacing: compact ? 12 : 20,
                            mainAxisSpacing: compact ? 8 : 16,
                            childAspectRatio: isLandscape ? 1.3 : 1.2,
                          ),
                          itemBuilder: (context, index) => CategoryItemWidget(
                            category: Categories.values[index],
                            compact: compact,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
