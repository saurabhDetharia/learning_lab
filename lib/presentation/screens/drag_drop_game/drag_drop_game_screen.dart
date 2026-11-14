import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learning_lab/utils/extensions/context_extension.dart';

import '../../../application/provider/learning_lab_app_provider.dart';
import '../../../gen/fonts.gen.dart';
import '../../../utils/enums/app_enums.dart';
import '../../../utils/helpers/app_helpers.dart';
import '../../../values/constants.dart';
import '../../../values/learning_lab_theme.dart';
import '../../widgets/button.dart';
import '../categories/provider/categories_screen_provider.dart';

class DragDropGameScreen extends ConsumerStatefulWidget {
  const DragDropGameScreen({super.key});

  @override
  ConsumerState<DragDropGameScreen> createState() => _DragDropGameScreenState();
}

class _DragDropGameScreenState extends ConsumerState<DragDropGameScreen> {
  final Map<Object, Object> _draggableItems = {};
  final Map<Object, Object> _correctTargets = {};
  final Map<Object, bool> itemDropped = {};
  final Map<Object, bool> itemCorrectlyPlaced = {};

  late Categories _category;
  late double _scale;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _category = ref.read(screenNotifier.notifier).args as Categories;
    _initialise();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = ref.watch(scaleProvider);
    return ColoredBox(
      color: LearningLabTheme.cream,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final landscape = constraints.maxWidth > constraints.maxHeight;
            final compact = constraints.maxHeight < 500;
            final horizontalPadding = constraints.maxWidth < 600 ? 14.0 : 28.0;

            return Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                compact ? 8 : 16,
                horizontalPadding,
                compact ? 10 : 18,
              ),
              child: Column(
                children: [
                  _buildHeader(compact),
                  SizedBox(height: compact ? 8 : 16),
                  Expanded(
                    child: landscape
                        ? Row(
                            children: [
                              Expanded(child: _buildPlayArea(
                                title: 'Pick an item',
                                subtitle: 'Drag the right one',
                                children: _buildDraggableItems(compact: true),
                                accent: LearningLabTheme.sky,
                                expand: true,
                              )),
                              SizedBox(width: compact ? 12 : 20),
                              Expanded(child: _buildPlayArea(
                                title: 'Match it here',
                                subtitle: 'Find the matching space',
                                children: _buildTargets(compact: true),
                                accent: LearningLabTheme.mint,
                                expand: true,
                              )),
                            ],
                          )
                        : SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                _buildPlayArea(
                                  title: 'Pick an item',
                                  subtitle: 'Drag the right one',
                                  children: _buildDraggableItems(compact: false),
                                  accent: LearningLabTheme.sky,
                                ),
                                const SizedBox(height: 14),
                                _buildPlayArea(
                                  title: 'Match it here',
                                  subtitle: 'Find the matching space',
                                  children: _buildTargets(compact: false),
                                  accent: LearningLabTheme.mint,
                                ),
                              ],
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

  Widget _buildHeader(bool compact) {
    return Row(
      children: [
        Button(
          size: const Size(46, 46),
          onTap: () => ref
              .read(screenNotifier.notifier)
              .navigate(AppScreens.categories, null),
          child: const Icon(Icons.arrow_back_rounded,
              color: Colors.white, size: 23),
        ),
        const Spacer(),
        Column(
          children: [
            Text(
              _category.title,
              style: LearningLabTheme.textTheme.headlineMedium.copyWith(
                fontSize: compact ? 24 : 30,
              ),
            ),
            if (!compact)
              Text(
                'Let’s learn and play!',
                style: LearningLabTheme.textTheme.bodyLarge.copyWith(
                  color: LearningLabTheme.mutedInk,
                  fontSize: 14,
                ),
              ),
          ],
        ),
        const Spacer(),
        Button(
          size: const Size(46, 46),
          onTap: () => context.showSettingsDialog(isGameScreen: true),
          child: const Icon(Icons.pause_rounded,
              color: Colors.white, size: 23),
        ),
      ],
    );
  }

  Widget _buildPlayArea({
    required String title,
    required String subtitle,
    required List<Widget> children,
    required Color accent,
    bool expand = false,
  }) {
    return Container(
      width: double.infinity,
      height: expand ? double.infinity : null,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.78),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: LearningLabTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 28,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                      style: LearningLabTheme.textTheme.titleLarge.copyWith(
                        fontSize: 18,
                      )),
                    Text(subtitle,
                      style: LearningLabTheme.textTheme.bodyLarge.copyWith(
                        color: LearningLabTheme.mutedInk,
                        fontSize: 12,
                      )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (expand)
            Expanded(
              child: Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  spacing: 14,
                  runSpacing: 14,
                  children: children,
                ),
              ),
            )
          else
            Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: children,
            ),
        ],
      ),
    );
  }

  List<Widget> _buildDraggableItems({required bool compact}) {
    final tileSize = compact ? 88.0 : 104.0;
    return _draggableItems.entries.map((entry) {
      final item = entry.key;
      return AnimatedScale(
        scale: _scale,
        duration: AppConstants.shortAnimationDuration,
        child: Draggable<Object>(
          data: item,
          dragAnchorStrategy: pointerDragAnchorStrategy,
          feedback: Material(
            color: Colors.transparent,
            child: _buildItemVisual(item, tileSize, isFeedback: true),
          ),
          childWhenDragging: Opacity(
            opacity: 0.25,
            child: _buildItemVisual(item, tileSize),
          ),
          child: _buildItemVisual(item, tileSize),
        ),
      );
    }).toList();
  }

  List<Widget> _buildTargets({required bool compact}) {
    final tileWidth = compact ? 124.0 : 148.0;
    final tileHeight = compact ? 112.0 : 132.0;
    return _correctTargets.entries.map((entry) {
      final target = entry.key;
      final dropped = itemDropped[target] ?? false;
      final correct = itemCorrectlyPlaced[target] ?? false;

      return AnimatedScale(
        scale: _scale,
        duration: AppConstants.shortAnimationDuration,
        child: DragTarget<Object>(
          onWillAcceptWithDetails: (_) => !correct,
          onAcceptWithDetails: (details) => onDrop(target, details.data),
          builder: (context, candidateData, rejectedData) {
            final hovering = candidateData.isNotEmpty;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: tileWidth,
              height: tileHeight,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: correct
                    ? const Color(0xFFE1F5E9)
                    : dropped
                        ? const Color(0xFFFFE5DE)
                        : hovering
                            ? const Color(0xFFE3F5F2)
                            : const Color(0xFFF7F5F0),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: correct
                      ? LearningLabTheme.teal
                      : hovering
                          ? LearningLabTheme.teal
                          : const Color(0xFFE8E2D8),
                  width: hovering || correct ? 2.5 : 1.5,
                ),
              ),
              child: correct
                  ? _buildItemContents(target, tileSize - 16)
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              '${entry.value}',
                              textAlign: TextAlign.center,
                              softWrap: true,
                              maxLines: 2,
                              style: TextStyle(
                                fontFamily: FontFamily.nunito,
                                fontSize: compact ? 16 : 19,
                                height: 1.05,
                                fontWeight: FontWeight.w900,
                                color: LearningLabTheme.ink,
                              ),
                            ),
                          ),
                        ),
                        Icon(
                          dropped ? Icons.refresh_rounded : Icons.add_rounded,
                          color: dropped
                              ? LearningLabTheme.coral
                              : LearningLabTheme.mutedInk,
                          size: compact ? 18 : 21,
                        ),
                      ],
                    ),
            );
          },
        ),
      );
    }).toList();
  }

  Widget _buildItemVisual(
    Object item,
    double size, {
    bool isFeedback = false,
  }) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: LearningLabTheme.cardBorder),
        boxShadow: isFeedback
            ? const []
            : const [
                BoxShadow(
                  color: Color(0x14263451),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
      ),
      child: Center(child: _buildItemContents(item, size - 18)),
    );
  }

  Widget _buildItemContents(Object item, double size) {
    if (item is Color) {
      return Container(
        width: size * 0.72,
        height: size * 0.72,
        decoration: BoxDecoration(
          color: item,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black.withOpacity(0.08)),
        ),
      );
    }
    if (item is String && item.endsWith('.svg')) {
      return SvgPicture.asset(item, width: size, height: size);
    }
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        '$item',
        style: TextStyle(
          fontFamily: FontFamily.nunito,
          fontSize: size * 0.72,
          fontWeight: FontWeight.w900,
          color: LearningLabTheme.ink,
        ),
      ),
    );
  }

  void onDrop(Object targetKey, Object item) {
    if (itemCorrectlyPlaced[targetKey] == true) return;

    setState(() {
      itemDropped[targetKey] = true;
      itemCorrectlyPlaced[targetKey] = item == targetKey;
    });

    final isAllMatched = _correctTargets.keys.every(
      (key) => itemCorrectlyPlaced[key] == true,
    );

    if (isAllMatched) {
      final settings = ref.read(localStorageNotifier);
      if (settings.isSfxEnabled) {
        ref.read(successPlayerControllerProvider.notifier).play();
      }
      context.showSuccessDialog(
        category: _category,
        onReplay: () {
          ref.read(scaleProvider.notifier).state = 0;
          _timer = Timer(AppConstants.shortAnimationDuration, () {
            if (!mounted) return;
            _initialise();
            ref.read(scaleProvider.notifier).state = 1;
          });
        },
      );
    }
  }

  void _animate() {
    _timer?.cancel();
    _timer = Timer(AppConstants.shortAnimationDuration, () {
      if (mounted) ref.read(scaleProvider.notifier).state = 1.0;
    });
  }

  void _loadItems() {
    final alphabets = <String, String>{};
    for (var i = 65; i < 91; i++) {
      final char = String.fromCharCode(i);
      alphabets[char] = char;
    }

    final numbers = <String, String>{};
    for (var i = 0; i < 10; i++) {
      numbers['$i'] = '$i';
    }

    final items = switch (_category) {
      Categories.colors => AppConstants.colors,
      Categories.alphabets => alphabets,
      Categories.numbers => numbers,
      Categories.shape => AppConstants.shapes,
    };

    final maxCount = min(6, items.length);
    final minCount = min(2, maxCount);
    final limit = minCount == maxCount
        ? maxCount
        : Random().nextInt(maxCount - minCount + 1) + minCount;
    final selection = items.entries.toList()..shuffle();
    final selected = Map<Object, Object>.fromEntries(selection.take(limit));

    _draggableItems
      ..clear()
      ..addAll(AppHelpers.instance.shuffleMap(selected));
    _correctTargets
      ..clear()
      ..addAll(AppHelpers.instance.shuffleMap(selected));
  }

  void _initialise() {
    _loadItems();
    itemDropped
      ..clear();
    itemCorrectlyPlaced
      ..clear();
    for (final key in _correctTargets.keys) {
      itemDropped[key] = false;
      itemCorrectlyPlaced[key] = false;
    }
    if (mounted) setState(() {});
    _animate();
  }
}
