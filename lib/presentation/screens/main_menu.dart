import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_lab/utils/extensions/context_extension.dart';
import 'package:learning_lab/presentation/widgets/button.dart';

import '../../application/provider/learning_lab_app_provider.dart';
import '../../utils/enums/app_enums.dart';
import '../../values/learning_lab_theme.dart';

class MainMenuScreen extends ConsumerWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(builder: (context, constraints) {
      final compact = constraints.maxHeight < 420 || constraints.maxWidth < 720;
      return ColoredBox(
        color: LearningLabTheme.cream,
        child: Stack(children: [
          const Positioned(top: -55, right: -35,
            child: _Blob(size: 190, color: Color(0xFFFFE8B8))),
          const Positioned(bottom: -85, left: -50,
            child: _Blob(size: 220, color: Color(0xFFDDF3ED))),
          SafeArea(child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: constraints.maxWidth < 700 ? 20 : 48,
              vertical: compact ? 10 : 24,
            ),
            child: Column(children: [
              Align(alignment: Alignment.topRight, child: Material(
                color: Colors.white, shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => context.showSettingsDialog(),
                  child: const SizedBox(width: 56, height: 56,
                    child: Icon(CupertinoIcons.gear_alt_fill,
                      color: LearningLabTheme.ink, size: 26)),
                ),
              )),
              Expanded(child: compact
                ? _CompactHome(onPlay: () => _start(ref))
                : _WideHome(onPlay: () => _start(ref))),
            ]),
          )),
        ]),
      );
    });
  }

  void _start(WidgetRef ref) {
    ref.read(screenNotifier.notifier).navigate(AppScreens.categories, null);
  }
}

class _WideHome extends StatelessWidget {
  const _WideHome({required this.onPlay});
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) => Row(children: [
    Expanded(flex: 11, child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('PLAY • LEARN • GROW', style: TextStyle(
          fontFamily: 'Nunito', fontSize: 13, letterSpacing: 2,
          fontWeight: FontWeight.w900, color: LearningLabTheme.tealDark)),
        const SizedBox(height: 12),
        Text('Hello, little learner!', style: LearningLabTheme.textTheme.headlineLarge),
        const SizedBox(height: 10),
        Text('Let’s explore something wonderful today.',
          style: LearningLabTheme.textTheme.bodyLarge.copyWith(
            color: LearningLabTheme.mutedInk)),
        const SizedBox(height: 28),
        Button(
          size: const Size(230, 68),
          onTap: onPlay,
          borderRadius: BorderRadius.circular(24),
          child: const Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.play_arrow_rounded, color: Colors.white, size: 32),
            SizedBox(width: 8),
            Text('Let’s play!', style: TextStyle(fontFamily: 'Nunito',
              fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
          ]),
        ),
      ],
    )),
    const Expanded(flex: 9, child: Center(child: _Mascot())),
  ]);
}

class _CompactHome extends StatelessWidget {
  const _CompactHome({required this.onPlay});
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Expanded(child: Center(child: _Mascot())),
      Text('Hello, little learner!', textAlign: TextAlign.center,
        style: LearningLabTheme.textTheme.headlineMedium),
      const SizedBox(height: 8),
      Text('Let’s explore something wonderful today.',
        textAlign: TextAlign.center,
        style: LearningLabTheme.textTheme.bodyLarge.copyWith(
          color: LearningLabTheme.mutedInk)),
      const SizedBox(height: 18),
      _PlayButton(onTap: onPlay),
      const SizedBox(height: 8),
    ],
  );
}

class _Mascot extends StatelessWidget {
  const _Mascot();

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, c) {
    final size = c.maxHeight.clamp(145.0, 300.0);
    return SizedBox(width: size * 1.2, height: size, child: Stack(
      alignment: Alignment.center, children: [
        Container(width: size * .9, height: size * .9,
          decoration: const BoxDecoration(
            color: Color(0xFFFFE8B8), shape: BoxShape.circle)),
        Positioned(top: size * .03, left: size * .05,
          child: const _Bubble(text: 'A', color: LearningLabTheme.coral)),
        Positioned(top: size * .18, right: 0,
          child: const _Bubble(text: '★', color: LearningLabTheme.teal)),
        Positioned(bottom: size * .05, left: size * .08,
          child: const _Bubble(text: '1', color: LearningLabTheme.lavender)),
        Text('🦊', style: TextStyle(fontSize: size * .55)),
      ],
    ));
  });
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.text, required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: 52, height: 52, alignment: Alignment.center,
    decoration: BoxDecoration(color: color,
      borderRadius: BorderRadius.circular(18),
      boxShadow: const [BoxShadow(color: Color(0x22000000),
        blurRadius: 8, offset: Offset(0, 4))]),
    child: Text(text, style: const TextStyle(fontFamily: 'Nunito',
      fontSize: 27, fontWeight: FontWeight.w900, color: Colors.white)),
  );
}

class _Blob extends StatelessWidget {
  const _Blob({required this.size, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(width: size, height: size,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle));
}
