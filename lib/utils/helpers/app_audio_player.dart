import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../enums/app_enums.dart';

class AppAudioPlayerController extends StateNotifier<AudioPlayerState> {

  AppAudioPlayerController(this._player) : super(AudioPlayerState.stopped) {
    // Listen for changes in the audio player state
    _player.onPlayerStateChanged.listen((PlayerState playerState) {
      if (playerState == PlayerState.playing) {
        state = AudioPlayerState.playing;
      } else if (playerState == PlayerState.paused) {
        state = AudioPlayerState.paused;
      } else if (playerState == PlayerState.stopped) {
        state = AudioPlayerState.stopped;
      } else {
        state = AudioPlayerState.loading;
      }
      this.state = state; // Notify the listeners with the new state
    });
  }

  late AudioPlayer _player;

  /// To initial audio player
  void initialise(
    String audioPath, {
    ReleaseMode releaseMode = ReleaseMode.stop,
    double volume = 1,
  }) {
    /**
     * This will set the audio file and release mode
     * to keep the source after playback has completed.
     */
    _player
      ..setSourceAsset(
        audioPath.replaceFirst('assets/', ''),
      )
      ..setVolume(volume)
      ..setReleaseMode(releaseMode);
  }

  /// To start the audio player
  Future<void> play() async {
    await _player.stop();
    await _player.resume();
  }

  /// To stop the audio player
  Future<void> stop() async {
    await _player.stop();
  }

  /// To dispose the audio player and
  /// release the source.
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
