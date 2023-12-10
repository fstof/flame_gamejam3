import 'dart:collection';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flame_audio/bgm.dart';

import '../../scoring/storage/storage.dart';
import '../assets.dart';
import 'sounds.dart';

class AudioController {
  final Storage _storage;
  final AudioPlayer _sfxPlayer;
  final Bgm _bgm;

  final Queue<String> _playlist;
  final Random _random = Random();

  AudioController({
    required Storage storage,
    required AudioPlayer sfxPlayer,
    required Bgm bgm,
  })  : _storage = storage,
        _sfxPlayer = sfxPlayer,
        _bgm = bgm,
        _playlist = Queue.of([bgmPath]);

  void dispose() {
    stopAllSound();
    _bgm.dispose();
    _sfxPlayer.dispose();
  }

  void playSfx(SoundType type) {
    final soundsOn = _storage.effectsOn();
    if (!soundsOn) return;

    final options = soundNamesForType(type);
    final filename = options[_random.nextInt(options.length)];

    print('playing $filename at volume ${_sfxPlayer.volume}');
    _sfxPlayer.play(AssetSource(filename));
    // print('playing $sfxJump2 at volume ${_sfxPlayer.volume}');
    // _sfxPlayer.play(AssetSource(sfxJump2));
  }

  void stopSfx() {
    _sfxPlayer.stop();
  }

  void startMusic() {
    if (_storage.musicOn()) {
      _bgm.play(_playlist.first);
    }
  }

  void stopMusic() {
    _bgm.pause();
  }

  void stopAllSound() {
    _bgm.pause();
    _sfxPlayer.stop();
  }
}
