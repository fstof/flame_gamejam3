import 'package:audioplayers/audioplayers.dart';
import 'package:equatable/equatable.dart';
import 'package:flame_audio/bgm.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../scoring/storage/storage.dart';
import '../../audio/audio_controller.dart';

part 'audio_state.dart';

class AudioCubit extends Cubit<AudioState> {
  final Storage _storage;
  final AudioPlayer _sfxPlayer;
  final Bgm _bgm;

  late final AudioController audioController;

  AudioCubit({required AudioCache audioCache, required Storage storage})
      : _storage = storage,
        _sfxPlayer = AudioPlayer()
          ..audioCache = audioCache
          ..setPlayerMode(PlayerMode.lowLatency),
        _bgm = Bgm(audioCache: audioCache),
        super(const AudioState()) {
    audioController = AudioController(
      storage: _storage,
      sfxPlayer: _sfxPlayer,
      bgm: _bgm,
    );
  }

  Future<void> loadState() async {
    if (_storage.musicOn()) {
      // await _bgm.audioPlayer.setVolume(0);
    } else {
      // await _bgm.audioPlayer.setVolume(1);
    }
    if (_storage.effectsOn()) {
      // await _sfxPlayer.setVolume(0);
    } else {
      // await _sfxPlayer.setVolume(1);
    }
    emit(
      state.copyWith(
        musicOn: _storage.musicOn(),
        effectsOn: _storage.effectsOn(),
      ),
    );
  }

  Future<void> toggleMusic() async {
    _storage.setMusicOn(on: !state.musicOn);
    if (state.musicOn) {
      // await _bgm.audioPlayer.setVolume(0);
      audioController.stopMusic();
    } else {
      // await _bgm.audioPlayer.setVolume(1);
      audioController.startMusic();
    }
    if (!isClosed) {
      emit(state.copyWith(musicOn: !state.musicOn));
    }
  }

  Future<void> toggleEffects() async {
    _storage.setEffectsOn(on: !state.effectsOn);
    if (state.effectsOn) {
      // await _sfxPlayer.setVolume(0);
    } else {
      // await _sfxPlayer.setVolume(1);
    }
    if (!isClosed) {
      emit(state.copyWith(effectsOn: !state.effectsOn));
    }
  }

  @override
  Future<void> close() {
    _sfxPlayer.dispose();
    _bgm.dispose();
    return super.close();
  }
}
