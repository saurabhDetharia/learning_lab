import 'package:flutter/material.dart';

extension NavigationExtension on BuildContext {
  // To add new widget to the navigation stack.
  Future<T?> push<T>(
    Widget child,
  ) async {
    return await Navigator.push<T>(
      this,
      MaterialPageRoute(
        builder: (builderCtx) {
          return child;
        },
      ),
    );
  }

  // To replace the current widget with the new widget.
  Future<T?> pushReplacement<T, T0>(
    Widget child,
  ) async {
    return await Navigator.pushReplacement<T, T0>(
      this,
      MaterialPageRoute(
        builder: (builderCtx) {
          return child;
        },
      ),
    );
  }

  // To remove the widget around the context from the navigation stack.
  Future<void> pop<T>({
    Widget? child,
  }) async {
    return Navigator.pop(
      this,
      T,
    );
  }
}
