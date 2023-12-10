import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flame/cache.dart';
import 'package:flame_gamejam3/game/assets.dart';
import 'package:flutter/widgets.dart';

part 'preload_state.dart';

class PreloadCubit extends Cubit<PreloadState> {
  PreloadCubit(this.images, this.audio) : super(const PreloadState.initial());

  final Images images;
  final AudioCache audio;

  /// Load items sequentially allows display of what is being loaded
  Future<void> loadSequentially() async {
    final phases = [
      PreloadPhase(
        'audio',
        () => audio.loadAll([
          bgmPath,
          sfxDrive,
          sfxBurn1,
          sfxBurn2,
          sfxBurn3,
          sfxClick1,
          sfxClick2,
          sfxClick3,
          sfxDie1,
          sfxDie2,
          sfxDie3,
          sfxFreeze1,
          sfxFreeze2,
          sfxFreeze3,
          sfxJump1,
          sfxJump2,
          sfxJump3,
          sfxWin1,
          sfxWin2,
          sfxWin3,
        ]),
      ),
      PreloadPhase(
        'images',
        () => images.loadAll([
          'assets/images/$imgBg1',
          'assets/images/$imgTrophyBroze',
          'assets/images/$imgTrophySilver',
          'assets/images/$imgTrophyGold',
          'assets/images/$imgBg2Anim',
          'assets/images/$imgCarAnim',
          'assets/images/$imgCarBurnAnim',
          'assets/images/$imgCarFreezeAnim',
          'assets/images/$imgCoals',
          'assets/images/$imgEnding1',
          'assets/images/$imgEnding2',
          'assets/images/$imgEnding3',
          'assets/images/$imgFire',
          'assets/images/$imgGround1',
          'assets/images/$imgGround2',
          'assets/images/$imgIce',
          'assets/images/$imgLavaAnim',
          'assets/images/$imgSnowman1',
          'assets/images/$imgSnowman2',
          'assets/images/$imgStart',
          'assets/images/$imgVolcano',
          'assets/images/$imgWaterAnim',
          'assets/images/$imgWheel',
        ]),
      ),
    ];

    emit(state.copyWith(totalCount: phases.length));
    for (final phase in phases) {
      emit(state.copyWith(currentLabel: phase.label));
      // Throttle phases to take at least 1/5 seconds
      await Future.wait([
        Future.delayed(Duration.zero, phase.start),
        Future<void>.delayed(const Duration(milliseconds: 200)),
      ]);
      emit(state.copyWith(loadedCount: state.loadedCount + 1));
    }
  }
}

@immutable
class PreloadPhase {
  const PreloadPhase(this.label, this.start);

  final String label;
  final ValueGetter<Future<void>> start;
}
