part of 'scoring_cubit.dart';

@freezed
class ScoringState with _$ScoringState {
  const factory ScoringState.initial() = _Initial;
  const factory ScoringState.loaded({
    required Map<int, Map<int, bool>> scores,
  }) = Loaded;
}
