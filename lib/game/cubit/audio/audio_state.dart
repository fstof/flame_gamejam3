part of 'audio_cubit.dart';

class AudioState extends Equatable {
  const AudioState({this.musicOn = true, this.effectsOn = true});
  final bool musicOn;
  final bool effectsOn;

  AudioState copyWith({bool? musicOn, bool? effectsOn}) {
    return AudioState(
      musicOn: musicOn ?? this.musicOn,
      effectsOn: effectsOn ?? this.effectsOn,
    );
  }

  @override
  List<Object> get props => [
        musicOn,
        effectsOn,
      ];
}
