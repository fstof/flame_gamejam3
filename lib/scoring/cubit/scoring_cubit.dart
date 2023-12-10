import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../scoring/storage/storage.dart';

part 'scoring_cubit.freezed.dart';
part 'scoring_state.dart';

class ScoringCubit extends Cubit<ScoringState> {
  final Storage storage;

  ScoringCubit({required this.storage}) : super(const ScoringState.initial());

  void loadScores() {
    final scores = <int, Map<int, bool>>{};

    for (var k = 0; k < 10; k++) {
      final level = k + 1;
      scores[level] = storage.endingsForLevel(level);
    }

    emit(ScoringState.loaded(scores: scores));
  }

  void addScore(int level, int ending) {
    state.map(
      initial: (initial) {},
      loaded: (loaded) {
        final scores = Map<int, Map<int, bool>>.from(loaded.scores);
        final currentScore = scores[level] ?? {1: false, 2: false, 3: false};

        currentScore[ending] = true;
        storage.saveEnding(level, ending);

        scores[level] = currentScore;
        emit(ScoringState.loaded(scores: scores));
      },
    );
  }
}
