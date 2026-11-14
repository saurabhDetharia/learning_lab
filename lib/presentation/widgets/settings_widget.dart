import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_lab/utils/extensions/navigation_extension.dart';

import '../../application/provider/learning_lab_app_provider.dart';
import '../../utils/enums/app_enums.dart';
import '../../values/learning_lab_theme.dart';
import '../screens/categories/provider/categories_screen_provider.dart';
import 'button.dart';

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
    final settings = ref.watch(localStorageNotifier);
    final isCompact = MediaQuery.sizeOf(context).height < 420;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 390),
      child: Container(
        padding: EdgeInsets.all(isCompact ? 18 : 24),
        decoration: BoxDecoration(
          color: LearningLabTheme.cream,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: LearningLabTheme.cardBorder, width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26263451),
              blurRadius: 28,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: const BoxDecoration(
                color: Color(0xFFFFE8B8),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.gear_alt_fill,
                color: LearningLabTheme.ink,
                size: 28,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Settings',
              style: LearningLabTheme.textTheme.headlineMedium!.copyWith(
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Make your learning time just right.',
              textAlign: TextAlign.center,
              style: LearningLabTheme.textTheme.bodyLarge!.copyWith(
                color: LearningLabTheme.mutedInk,
                fontSize: 14,
              ),
            ),
            SizedBox(height: isCompact ? 16 : 22),
            _SettingsRow(
              icon: settings.isMusicEnabled
                  ? Icons.music_note_rounded
                  : Icons.music_off_rounded,
              title: 'Background music',
              subtitle: 'Gentle music while you play',
              value: settings.isMusicEnabled,
              onChanged: (value) {
                if (value) {
                  ref.read(backgroundPlayerControllerProvider.notifier).play();
                } else {
                  ref.read(backgroundPlayerControllerProvider.notifier).stop();
                }
                ref.read(localStorageNotifier.notifier).changeMusicVol(value);
              },
            ),
            const SizedBox(height: 10),
            _SettingsRow(
              icon: settings.isSfxEnabled
                  ? Icons.volume_up_rounded
                  : Icons.volume_off_rounded,
              title: 'Sound effects',
              subtitle: 'Sounds for taps and matches',
              value: settings.isSfxEnabled,
              onChanged: (value) {
                if (value) {
                  ref.read(tapPlayerControllerProvider.notifier).play();
                } else {
                  ref.read(tapPlayerControllerProvider.notifier).stop();
                }
                ref.read(localStorageNotifier.notifier).changeSfxVol(value);
              },
            ),
            SizedBox(height: isCompact ? 18 : 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ActionButton(
                  icon: Icons.close_rounded,
                  tooltip: 'Close settings',
                  onTap: () => context.pop(),
                ),
                if (widget.isGameScreen) ...[
                  const SizedBox(width: 12),
                  _ActionButton(
                    icon: CupertinoIcons.square_grid_2x2_fill,
                    tooltip: 'Choose another activity',
                    onTap: () => _navigateTo(AppScreens.categories),
                  ),
                  const SizedBox(width: 12),
                  _ActionButton(
                    icon: CupertinoIcons.house_fill,
                    tooltip: 'Go to home',
                    onTap: () => _navigateTo(AppScreens.mainMenu),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateTo(AppScreens screen) {
    ref.read(scaleProvider.notifier).state = 0;
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 120), () {
      if (!mounted) return;
      context.pop();
      ref.read(screenNotifier.notifier).navigate(screen, null);
    });
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: LearningLabTheme.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFE3F5F2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: LearningLabTheme.tealDark, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: LearningLabTheme.textTheme.titleLarge!.copyWith(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: LearningLabTheme.textTheme.bodyLarge!.copyWith(
                    color: LearningLabTheme.mutedInk,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeColor: LearningLabTheme.teal,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Button(
        size: const Size(48, 48),
        onTap: onTap,
        child: Icon(icon, color: Colors.white, size: 21),
      ),
    );
  }
}
