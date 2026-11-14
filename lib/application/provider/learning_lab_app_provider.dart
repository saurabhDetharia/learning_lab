import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_lab/utils/helpers/app_audio_player.dart';

import '../../utils/enums/app_enums.dart';
import '../../utils/helpers/app_navigation_controller.dart';
import '../../utils/helpers/app_settings.dart';

final backgroundPlayerControllerProvider =
    StateNotifierProvider<AppAudioPlayerController, AudioPlayerState>((ref) {
  return AppAudioPlayerController(AudioPlayer());
});

final tapPlayerControllerProvider =
    StateNotifierProvider<AppAudioPlayerController, AudioPlayerState>((ref) {
  return AppAudioPlayerController(AudioPlayer());
});

final successPlayerControllerProvider =
    StateNotifierProvider<AppAudioPlayerController, AudioPlayerState>((ref) {
  return AppAudioPlayerController(AudioPlayer());
});

final screenNotifier = ChangeNotifierProvider<AppNavigationController>((ref) {
  return AppNavigationController();
});

final localStorageNotifier =
    StateNotifierProvider<AppSettingsProvider, AppSettings>((ref) {
  return AppSettingsProvider(
    AppSettings(),
  );
});
