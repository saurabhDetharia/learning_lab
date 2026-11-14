import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_lab/utils/helpers/app_local_storage.dart';

class AppSettings {
  bool isMusicEnabled = true;
  bool isSfxEnabled = true;
}

class AppSettingsProvider extends StateNotifier<AppSettings> {
  late AppLocalStorage appLocalStorage;

  AppSettingsProvider(super.state) {
    appLocalStorage = AppLocalStorage();
    state.isSfxEnabled = appLocalStorage.getValue<bool>('isSfxEnabled') as bool;
    state.isMusicEnabled =
        appLocalStorage.getValue<bool>('isMusicEnabled') as bool;
  }

  changeMusicVol(bool isEnabled) {
    state = AppSettings()
      ..isMusicEnabled = isEnabled
      ..isSfxEnabled = state.isSfxEnabled;
    appLocalStorage.setValue<bool>('isMusicEnabled', isEnabled);
  }

  changeSfxVol(bool isEnabled) {
    state = AppSettings()
      ..isMusicEnabled = state.isMusicEnabled
      ..isSfxEnabled = isEnabled;
    appLocalStorage.setValue<bool>('isSfxEnabled', isEnabled);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
