import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_lab/utils/extensions/navigation_extension.dart';

import '../../application/provider/learning_lab_app_provider.dart';
import '../../gen/fonts.gen.dart';
import '../../utils/enums/app_enums.dart';
import '../../values/app_colors.dart';
import '../../values/constants.dart';
import '../screens/categories/provider/categories_screen_provider.dart';
import 'button.dart';
import 'dialog_background_painter.dart';

class SettingsWidget extends ConsumerStatefulWidget {
  const SettingsWidget({
    required this.isGameScreen,
    super.key,
  });

  final bool isGameScreen;

  @override
  ConsumerState<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends ConsumerState<SettingsWidget> {
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final appSettingsProvider = ref.watch(localStorageNotifier);

    return CustomPaint(
      painter: DialogBackgroundPainter(),
      child: Container(
        width: 225,
        margin: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 24,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 8
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
                  'Settings',
                  style: TextStyle(
                    fontSize: 24,
                    color: AppColors.textColor,
                    fontWeight: FontWeight.w900,
                    fontFamily: FontFamily.nunito,
                  ),
                )
              ],
            ),
            Spacer(),
            ListTile(
              title: Text(
                'Music',
                style: TextStyle(
                  fontSize: 24,
                  color: AppColors.textSecondaryColor,
                  fontWeight: FontWeight.w900,
                  fontFamily: FontFamily.nunito,
                ),
              ),
              trailing: Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  final settings = ref.watch(localStorageNotifier);
                  return IconButton(
                    onPressed: () {
                      appSettingsProvider.isMusicEnabled
                          ? ref
                              .read(backgroundPlayerControllerProvider.notifier)
                              .stop()
                          : ref
                              .read(backgroundPlayerControllerProvider.notifier)
                              .play();
                      ref
                          .read(localStorageNotifier.notifier).changeMusicVol(
                        !settings.isMusicEnabled,
                      );
                    },
                    icon: Icon(
                      settings.isMusicEnabled
                          ? Icons.music_note_rounded
                          : Icons.music_off_rounded,
                      color: AppColors.iconColor,
                    ),
                  );
                },
              ),
            ),
            ListTile(
              title: Text(
                'Sound',
                style: TextStyle(
                  fontSize: 24,
                  color: AppColors.textSecondaryColor,
                  fontWeight: FontWeight.w900,
                  fontFamily: FontFamily.nunito,
                ),
              ),
              trailing: Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  final settings = ref.watch(localStorageNotifier);
                  return IconButton(
                    onPressed: () {
                      appSettingsProvider.isSfxEnabled
                          ? ref
                              .read(tapPlayerControllerProvider.notifier)
                              .stop()
                          : ref
                              .read(tapPlayerControllerProvider.notifier)
                              .play();
                      ref
                          .read(localStorageNotifier.notifier).changeSfxVol(
                        !appSettingsProvider.isSfxEnabled,
                      );
                    },
                    icon: Icon(
                      settings.isSfxEnabled
                          ? Icons.volume_up_rounded
                          : Icons.volume_off_rounded,
                      color: AppColors.iconColor,
                    ),
                  );
                },
              ),
            ),
            Spacer(),

            // Close icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Button(
                  size: Size(50, 50),
                  onTap: () {
                    context.pop();
                  },
                  child: Icon(
                    Icons.close,
                  ),
                ),
                if (widget.isGameScreen) ...[
                  SizedBox(
                    width: 12,
                  ),
                  Button(
                    size: Size(50, 50),
                    onTap: () {
                      ref.read(scaleProvider.notifier).state = 0;
                      _timer = Timer(
                        AppConstants.shortAnimationDuration,
                        () {
                          context.pop();
                          var _screenNotifier =
                              ref.read(screenNotifier.notifier);
                          _screenNotifier.navigate(AppScreens.categories, null);
                        },
                      );
                    },
                    child: Icon(
                      CupertinoIcons.square_grid_2x2_fill,
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Button(
                    size: Size(50, 50),
                    onTap: () {
                      ref.read(scaleProvider.notifier).state = 0;
                      _timer = Timer(
                        AppConstants.shortAnimationDuration,
                        () {
                          context.pop();
                          var _screenNotifier =
                              ref.read(screenNotifier.notifier);
                          _screenNotifier.navigate(AppScreens.mainMenu, null);
                        },
                      );
                    },
                    child: Icon(
                      CupertinoIcons.house_fill,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
