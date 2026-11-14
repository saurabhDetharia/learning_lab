import 'package:flutter/services.dart';

class AppHelpers {
  AppHelpers._();

  static final AppHelpers instance = AppHelpers._();

  /// Below used to set landscape orientation.
  void setLandscapeMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  /// Below used to set status bar transparent.
  void setTransparentStatusBar() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.leanBack,
    );
  }

  /// Below used to shuffle items of the Map.
  Map<K, V> shuffleMap<K, V>(Map<K, V> originalMap) {
    // Convert map entries to a list
    List<MapEntry<K, V>> entries = originalMap.entries.toList();

    // Shuffle the list of entries
    entries.shuffle();

    // Create a new map from the shuffled entries
    return Map.fromEntries(entries);
  }
}
