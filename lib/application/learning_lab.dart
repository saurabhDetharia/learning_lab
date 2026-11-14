import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_lab/utils/helpers/app_local_storage.dart';

import '../gen/assets.gen.dart';
import '../presentation/screens/splash_screen.dart';
import '../utils/helpers/app_helpers.dart';
import 'provider/learning_lab_app_provider.dart';

class LearningLab extends ConsumerStatefulWidget {
  const LearningLab({super.key});

  @override
  ConsumerState<LearningLab> createState() => _LearningLabState();
}

class _LearningLabState extends ConsumerState<LearningLab> {

  // To manage the audio.
  late final _backgroundMusicPlayer;
  late final _tapMusicPlayer;
  late final _successMusicPlayer;

  @override
  void initState() {
    super.initState();

    // Sets landscape mode
    AppHelpers.instance.setLandscapeMode();

    // Sets status bar
    AppHelpers.instance.setTransparentStatusBar();

    // Sets audio player for background music and start playing.
    _setupMusic();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learning Lab',
      debugShowCheckedModeBanner: false,

      // Localisation
      supportedLocales: const [
        Locale('en'), // English
      ],

      // Screens
      home: const SplashScreen(),
    );
  }

  /// This will be used to setup the background music.
  Future<void> _setupMusic() async {

    // Initialise local storage.
    await AppLocalStorage().init();

    _backgroundMusicPlayer = ref.read(backgroundPlayerControllerProvider.notifier);
    _tapMusicPlayer = ref.read(tapPlayerControllerProvider.notifier);
    _successMusicPlayer = ref.read(successPlayerControllerProvider.notifier);
    final appSettingsProvider = ref.read(localStorageNotifier);

    // Initialise background music.
    _backgroundMusicPlayer.initialise(
      Assets.audio.background,
      releaseMode: ReleaseMode.loop,
      volume: 0.5,
    );

    // Initialise music for tap events.
    _tapMusicPlayer.initialise(
      Assets.audio.tap,
      volume: 1.0,
    );

    // Initialise music for game completed.
    _successMusicPlayer.initialise(
      Assets.audio.levelCompleted,
      volume: 1.0,
    );

    if (appSettingsProvider.isMusicEnabled) {
      // Play the background music.
      await _backgroundMusicPlayer.play();
    }
  }

  @override
  Future<void> dispose() async {
    await _backgroundMusicPlayer.dispose();
    await _tapMusicPlayer.dispose();
    super.dispose();
  }
}
