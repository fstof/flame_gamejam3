import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../scoring/storage/storage.dart';

part 'scoring_cubit.freezed.dart';
part 'scoring_state.dart';

class ScoringCubit extends Cubit<ScoringState> {
  final Storage storage;

  ScoringCubit({required this.storage}) : super(const ScoringState.initial());

  void loadScores() {
    final scores = <int, int>{};

    for (var k = 0; k < 10; k++) {
      final level = k + 1;
      scores[level] = storage.endingForLevel(level);
    }

    emit(ScoringState.loaded(scores: scores));
  }

  void addScore(int level, int ending) {
    state.map(
      initial: (initial) {},
      loaded: (loaded) {
        final scores = Map<int, int>.from(loaded.scores);
        final currentScore = scores[level] ?? 0;

        if (ending > currentScore) {
          storage.saveEnding(level, ending);
          scores[level] = ending;
          emit(ScoringState.loaded(scores: scores));
        }
      },
    );
  }
}
