import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/provider/learning_lab_app_provider.dart';
import '../../values/learning_lab_theme.dart';

/// A reusable, animated button for the LearningLab interface.
///
/// Elevated buttons use the shared preschool theme. Set [isElevated] to false
/// for icon-only or otherwise unframed actions while keeping the press scale.
class Button extends ConsumerStatefulWidget {
  const Button({
    required this.onTap,
    required this.child,
    this.size,
    this.isElevated = true,
    this.backgroundColor,
    this.borderRadius,
    super.key,
  });

  final Size? size;
  final VoidCallback? onTap;
  final Widget child;
  final bool isElevated;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  @override
  ConsumerState<Button> createState() => _ButtonState();
}

class _ButtonState extends ConsumerState<Button> {
  bool _isPressed = false;

  Size get _size => widget.size ?? const Size.square(50);
  BorderRadius get _radius =>
      widget.borderRadius ?? BorderRadius.circular(LearningLabTheme.controlRadius);

  void _setPressed(bool value) {
    if (_isPressed != value) {
      setState(() => _isPressed = value);
    }
  }

  void _handleTap() {
    final settings = ref.read(localStorageNotifier);
    if (settings.isSfxEnabled) {
      ref.read(tapPlayerControllerProvider.notifier).play();
    }
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    final height = _size.height;
    final width = _size.width;

    if (!widget.isElevated) {
      return SizedBox(
        width: width,
        height: height,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: enabled ? (_) => _setPressed(true) : null,
          onTapCancel: () => _setPressed(false),
          onTap: enabled
              ? () {
                  _setPressed(false);
                  _handleTap();
                }
              : null,
          child: AnimatedScale(
            scale: _isPressed ? 0.94 : 1,
            duration: const Duration(milliseconds: 110),
            curve: Curves.easeOut,
            child: Center(child: widget.child),
          ),
        ),
      );
    }

    final background = widget.backgroundColor ?? LearningLabTheme.teal;
    final offset = _isPressed ? 2.0 : 7.0;

    return SizedBox(
      width: width,
      height: height + 9,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: enabled ? (_) => _setPressed(true) : null,
        onTapCancel: () => _setPressed(false),
        onTap: enabled
            ? () {
                _setPressed(false);
                _handleTap();
              }
            : null,
        child: Stack(
          children: [
            Positioned(
              top: 7,
              left: 0,
              right: 0,
              height: height,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: LearningLabTheme.tealDark,
                  borderRadius: _radius,
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 110),
              curve: Curves.easeOut,
              top: offset - 5,
              left: 0,
              right: 0,
              height: height,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 110),
                curve: Curves.easeOut,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: _radius,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A263451),
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: AnimatedScale(
                  scale: _isPressed ? 0.97 : 1,
                  duration: const Duration(milliseconds: 110),
                  child: widget.child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
