import 'package:flame/game.dart' hide Route;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../game_over/view/game_over_page.dart';
import '../../level_select/view/level_select_page.dart';
import '../../loading/cubit/cubit.dart';
import '../../scoring/storage/storage.dart';
import '../../styles/styles.dart';
import '../audio/audio_controller.dart';
import '../cubit/audio/audio_cubit.dart';
import '../forge_flame_gamejam3.dart';

class GamePage extends StatelessWidget {
  final int level;

  const GamePage({required this.level, super.key});

  static Route<void> route(int level) {
    return MaterialPageRoute<void>(
      builder: (_) => GamePage(level: level),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return AudioCubit(
          audioCache: context.read<PreloadCubit>().audio,
          storage: Storage.instance,
        )..loadState();
      },
      child: Scaffold(
        body: SafeArea(
          child: GameView(
            level: level,
          ),
        ),
      ),
    );
  }
}

class GameView extends StatefulWidget {
  const GameView({required this.level, super.key});

  final int level;

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  FlameGame? _game;

  late final AudioController audioController;

  @override
  void initState() {
    super.initState();
    audioController = context.read<AudioCubit>().audioController;
    if (Storage.instance.musicOn()) {}
    audioController.startMusic();
  }

  @override
  void dispose() {
    audioController.stopAllSound();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _game = VeryGoodForgeGame(
      level: widget.level,
      audioController: context.read<AudioCubit>().audioController,
      onLose: () async {
        print('YOU LOSE!');
        await Future.delayed(const Duration(seconds: 1));
        _game?.pauseEngine();
        await Navigator.of(context).pushReplacement(
          GameOverPage.route(level: widget.level, ending: 0),
        );
      },
      onWin: (int ending) async {
        print('YOU WIN!!!');
        await Future.delayed(const Duration(seconds: 1));
        _game?.pauseEngine();
        await Navigator.of(context).pushReplacement(
          GameOverPage.route(level: widget.level, ending: ending),
        );
      },
    );

    return Stack(
      children: [
        Positioned.fill(child: GameWidget(game: _game!)),
        Align(
          alignment: Alignment.topRight,
          child: BlocBuilder<AudioCubit, AudioState>(
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacement(LevelSelectPage.route());
                    },
                    icon: const Icon(Icons.eject),
                  ),
                  spaceL,
                  IconButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacement(GamePage.route(widget.level));
                    },
                    icon: const Icon(Icons.refresh),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      state.effectsOn ? Icons.music_note : Icons.music_off,
                    ),
                    onPressed: () => context.read<AudioCubit>().toggleEffects(),
                  ),
                  IconButton(
                    icon: Icon(
                      state.musicOn ? Icons.volume_up : Icons.volume_off,
                    ),
                    onPressed: () => context.read<AudioCubit>().toggleMusic(),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
