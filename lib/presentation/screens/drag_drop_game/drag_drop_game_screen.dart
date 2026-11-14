import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learning_lab/utils/extensions/context_extension.dart';
import 'package:learning_lab/utils/helpers/app_helpers.dart';

import '../../../application/provider/learning_lab_app_provider.dart';
import '../../../gen/fonts.gen.dart';
import '../../../utils/enums/app_enums.dart';
import '../../../values/app_colors.dart';
import '../../../values/constants.dart';
import '../../widgets/button.dart';
import '../categories/provider/categories_screen_provider.dart';

class DragDropGameScreen extends ConsumerStatefulWidget {
  const DragDropGameScreen({
    super.key,
  });

  @override
  ConsumerState<DragDropGameScreen> createState() => _DragDropGameScreenState();
}

class _DragDropGameScreenState extends ConsumerState<DragDropGameScreen> {
  // List of draggable items with their respective colors
  final Map _draggableItems = {};

  // List of corresponding correct target colors for each item
  final Map _correctTargets = {};

  // Select category to show the title,
  // and to load items.
  late Categories _category;

  // For scale animation
  late double _scale;
  Timer? _timer;

  // Map to track the item drop status
  Map itemDropped = {};
  Map itemCorrectlyPlaced = {};

  @override
  void initState() {
    super.initState();

    // Get the categories and load items accordingly.
    var _screenNotifier = ref.read(screenNotifier.notifier);
    _category = (_screenNotifier.args as Categories);

    _initialise();
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Title
          _getTitleRowWidget,

          SizedBox(height: 10),

          // Multiple draggable items
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: _draggableItems.entries.map((color) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedScale(
                  scale: _scale,
                  duration: AppConstants.shortAnimationDuration,
                  child: Draggable(
                    data: color.key,
                    // Passing the color as data
                    child: color.key.toString().endsWith('.svg')
                        ? SvgPicture.asset(
                            color.key,
                            width: 100,
                            height: 100,
                          )
                        : Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: color.key.runtimeType == Color
                                  ? color.key
                                  : AppColors.backgroundColor,
                              borderRadius: BorderRadius.circular(
                                12,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                color.key.runtimeType == Color
                                    ? 'Drag'
                                    : '${color.key}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: FontFamily.nunito,
                                ),
                              ),
                            ),
                          ),
                    feedback: Material(
                      color: Colors.transparent,
                      child: color.key.toString().endsWith('.svg')
                          ? SvgPicture.asset(
                              color.key,
                              width: 100,
                              height: 100,
                              colorFilter: ColorFilter.mode(
                                AppColors.backgroundColor
                                    .withAlpha(30),
                                BlendMode.srcIn,
                              ),
                            )
                          : Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  12,
                                ),
                                color: color.key.runtimeType == Color
                                    ? color.key
                                    : AppColors.backgroundColor.withAlpha(30),
                              ),
                              child: Center(
                                child: Text(
                                  color.key.runtimeType == Color
                                      ? 'Drag'
                                      : '${color.key}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: FontFamily.nunito,
                                  ),
                                ),
                              ),
                            ),
                    ),
                    childWhenDragging: color.key.toString().endsWith('.svg')
                        ? SvgPicture.asset(
                            color.key,
                            width: 100,
                            height: 100,
                            colorFilter: ColorFilter.mode(
                              AppColors.backgroundColor
                                  .withAlpha(30),
                              BlendMode.srcIn,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(
                              12,
                            ),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 40,
                                sigmaY: 40,
                              ),
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    12,
                                  ),
                                  color: color.key.runtimeType == Color
                                      ? color.key
                                      : AppColors.backgroundColor.withAlpha(30),
                                ),
                                child: Center(
                                  child: Text(
                                    color.key.runtimeType == Color
                                        ? 'Drag'
                                        : '${color.key}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: FontFamily.nunito,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 10),

          // Multiple drop targets
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: _correctTargets.entries.map((color) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedScale(
                  scale: _scale,
                  duration: AppConstants.shortAnimationDuration,
                  child: DragTarget(
                    onAcceptWithDetails: (receivedColor) {
                      final settings = ref.read(localStorageNotifier);
                      if (settings.isSfxEnabled) {
                        ref.read(tapPlayerControllerProvider.notifier).play();
                      }
                      onDrop(color.key, receivedColor.data);
                    },
                    builder: (context, candidateData, rejectedData) {
                      return color.key.toString().endsWith('.svg') &&
                              (itemDropped[color.key] ?? false)
                          ? SvgPicture.asset(
                              color.key,
                              width: 100,
                              height: 100,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(
                                12,
                              ),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 40,
                                  sigmaY: 40,
                                ),
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: (itemDropped[color.key] ?? false)
                                        ? ((itemCorrectlyPlaced[color.key] ??
                                                false)
                                            ? color.key.runtimeType == Color
                                                ? color.key
                                                : AppColors.backgroundColor
                                            : AppColors.backgroundColor
                                                .withAlpha(30))
                                        : AppColors.backgroundColor
                                            .withAlpha(30),
                                    borderRadius: BorderRadius.circular(
                                      12,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${color.value}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontFamily: FontFamily.nunito,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                    },
                  ),
                ),
              );
            }).toList(),
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
          context.showSettingsDialog(
            isGameScreen: true,
          );
        },
        child: Icon(
          Icons.pause,
          color: AppColors.iconColor,
          size: 20,
        ),
      ),
    );
  }

  /// This represents the "Settings" icon.
  Widget get _getSettingsIconWidget {
    return SizedBox(
      height: 20,
      width: 20,
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
            '${_category.title}',
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
            '${_category.title}',
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

  // A target is complete only when the matching item is dropped onto it.
  void onDrop(dynamic targetKey, dynamic item) {
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
            _initialise();
            ref.read(scaleProvider.notifier).state = 1;
          });
        },
      );
    }
  }

  void _loadItems() {
    final alphabets = <String, String>{};
    for (var i = 65; i < 91; i++) {
      String char = String.fromCharCode(i);
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
    final limit = min(
      maxCount,
      Random().nextInt(min(5, items.length - 1)) + 2,
    );
    final shuffledSelection = items.entries.toList()..shuffle();
    final limitedItems = Map.fromEntries(shuffledSelection.take(limit));

    // Shuffle draggable and target items.
    final shuffledDraggableItems = AppHelpers.instance.shuffleMap(limitedItems);
    final shuffledTargetItems = AppHelpers.instance.shuffleMap(limitedItems);

    // Add items to list.
    _draggableItems
      ..clear()
      ..addAll(shuffledDraggableItems);
    _correctTargets
      ..clear()
      ..addAll(shuffledTargetItems);
    setState(() {});
  }

  /// This will be called to initialise/re-initialise the game.
  void _initialise() {
    // To load drag items based on selected category.
    _loadItems();

    // Show scale animation.
    _animate();

    // Reset target state for every new round.
    itemDropped.clear();
    itemCorrectlyPlaced.clear();
    for (var color in _correctTargets.keys) {
      itemDropped[color] = false;
      itemCorrectlyPlaced[color] = false;
    }
  }
}
