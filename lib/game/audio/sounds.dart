import 'package:flame_gamejam3/game/assets.dart';

List<String> soundNamesForType(SoundType type) {
  switch (type) {
    case SoundType.click:
      return const [
        sfxClick1,
        sfxClick2,
        sfxClick3,
      ];
    case SoundType.drive:
      return const [
        sfxDrive,
      ];
    case SoundType.jump:
      return const [
        sfxJump1,
        sfxJump2,
        sfxJump3,
      ];
    case SoundType.win:
      return const [
        sfxWin1,
        sfxWin2,
        sfxWin3,
      ];
    case SoundType.freeze:
      return const [
        sfxFreeze1,
        sfxFreeze2,
        sfxFreeze3,
      ];
    case SoundType.burn:
      return const [
        sfxBurn1,
        sfxBurn3,
        sfxBurn3,
      ];
    case SoundType.die:
      return const [
        sfxDie1,
        sfxDie2,
        sfxDie3,
      ];
  }
}

enum SoundType {
  click,
  drive,
  jump,
  win,
  freeze,
  burn,
  die,
}
