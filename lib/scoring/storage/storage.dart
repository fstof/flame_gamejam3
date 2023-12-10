import 'package:hive_flutter/hive_flutter.dart';

class Storage {
  static Storage? _i;

  late Box<int> _scoresBox;
  late Box<bool> _settingsBox;

  Storage._();

  static Storage get instance => _i ??= Storage._();

  Future<void> initialise() async {
    await Hive.initFlutter();
    _scoresBox = await Hive.openBox('scoresBox');
    _settingsBox = await Hive.openBox('settingsBox');
  }

  void saveEnding(int level, int ending) {
    _scoresBox.put(level, ending);
  }

  int endingForLevel(int level) {
    return _scoresBox.get(level) ?? 0;
  }

  bool musicOn() {
    return _settingsBox.get('musicOn') ?? true;
  }

  void setMusicOn({required bool on}) {
    _settingsBox.put('musicOn', on);
  }

  bool effectsOn() {
    return _settingsBox.get('effectsOn') ?? true;
  }

  void setEffectsOn({required bool on}) {
    _settingsBox.put('effectsOn', on);
  }
}
