import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_lab/values/app_colors.dart';
import 'package:learning_lab/values/constants.dart';

import '../../application/provider/learning_lab_app_provider.dart';

class Button extends ConsumerStatefulWidget {
  final Size? size;
  final Function? onTap;
  final Widget child;
  final bool isElevated;

  const Button({
    required this.onTap,
    required this.child,
    this.size,
    this.isElevated = true,
    super.key,
  });

  @override
  ConsumerState<Button> createState() => _ButtonState();
}

class _ButtonState extends ConsumerState<Button> {
  // The default button size to calculate scale.
  Size get _defaultSize => Size.square(50);

  // Ease access to provided values.
  Size get _size => widget.size ?? _defaultSize;
  Function? get _onTap => widget.onTap;
  Widget get _child => widget.child;
  bool get _isElevated => widget.isElevated;

  // Calculate scale based on the default size,
  // which will be used to scale animated position.
  double get _scale => (_size.shortestSide / _defaultSize.shortestSide);

  // For press event animation.
  double _top = 3;
  double _childScale = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: !_isElevated ? [] : [
          BoxShadow(
            color: AppColors.shadowColorLight,
            offset: Offset.zero,
            blurRadius: 25,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Container(
        height: _size.height + (12 * _scale),
        width: _size.width,
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: _onTap == null
              ? null
              : () async {
                  setState(() {
                    // Start animation.
                    _top = 6 * _scale;
                    _childScale = 0.9;
                  });
                  final settings = ref.watch(localStorageNotifier);
                  if (settings.isSfxEnabled) {
                    final _tapMusicPlayer =
                    ref.watch(tapPlayerControllerProvider.notifier);
                    _tapMusicPlayer.play();
                  }
                  Timer.periodic(AppConstants.shortAnimationDuration,
                      (timer) async {
                    if (timer.tick == 1) {
                      setState(() {
                        // Start animation.
                        _top = 3;
                        _childScale = 1;
                      });
                    } else if (timer.tick == 2) {
                      timer.cancel();
                      await _onTap!();
                    }
                  });
                },
          child: !widget.isElevated
              ? Center(
                  child: AnimatedScale(
                    scale: _childScale,
                    duration: AppConstants.shortAnimationDuration,
                    child: _child,
                  ),
                )
              : Stack(
                  children: [
                    AnimatedPositioned(
                      top: (6 * _scale),
                      duration: AppConstants.shortAnimationDuration,
                      child: Container(
                        height: _size.height,
                        width: _size.width,
                        decoration: BoxDecoration(
                          color: AppColors.buttonShadow,
                          borderRadius: BorderRadius.circular(
                            16,
                          ),
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      top: _top,
                      duration: AppConstants.shortAnimationDuration,
                      child: Container(
                        height: _size.height,
                        width: _size.width,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.buttonPrimaryTop,
                              AppColors.buttonPrimaryBottom,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(
                            16,
                          ),
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      top: (_top / 2) + (6 * _scale),
                      duration: AppConstants.shortAnimationDuration,
                      child: Container(
                        height: _size.height / 2,
                        width: _size.width,
                        decoration: BoxDecoration(
                          color: AppColors.buttonShadowLight,
                          borderRadius: BorderRadius.circular(
                            16,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: AnimatedScale(
                        scale: _childScale,
                        duration: AppConstants.shortAnimationDuration,
                        child: _child,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
