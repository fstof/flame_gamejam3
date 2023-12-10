import 'package:flame_gamejam3/game/assets.dart';
import 'package:flame_gamejam3/level_select/view/level_select_page.dart';
import 'package:flame_gamejam3/scoring/cubit/scoring_cubit.dart';
import 'package:flame_gamejam3/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../game/view/game_page.dart';

class GameOverPage extends StatelessWidget {
  final int level;
  final int ending;
  const GameOverPage({required this.level, required this.ending, super.key});

  static Route<void> route({required int level, required int ending}) {
    return MaterialPageRoute<void>(
      builder: (_) => GameOverPage(level: level, ending: ending),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(ending == 0 ? 'You Lose' : 'You Win!')),
      body: GameOverView(
        level: level,
        ending: ending,
      ),
    );
  }
}

class GameOverView extends StatelessWidget {
  final int level;
  final int ending;

  const GameOverView({required this.level, required this.ending, super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ScoringCubit>(context).addScore(level, ending);
    return BlocConsumer<ScoringCubit, ScoringState>(
      listener: (context, state) {
        state.map(
          initial: (initial) {},
          loaded: (loaded) {
            BlocProvider.of<ScoringCubit>(context).addScore(level, ending);
          },
        );
      },
      builder: (context, state) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                'Level $level',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              spaceL,
              spaceL,
              spaceL,
              if (ending == 0)
                Text(
                  'You Lose!',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                )
              else ...[
                Text(
                  'You win!',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
                spaceL,
                Image.asset(
                  'assets/images/${ending == 1 ? imgTrophyBroze : ending == 2 ? imgTrophySilver : ending == 3 ? imgTrophyGold : ''}',
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: MediaQuery.of(context).size.width * 0.25,
                  fit: BoxFit.cover,
                ),
                spaceL,
              ],
              if (ending == 1)
                Text(
                  'But you can do better next time',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
              if (ending == 2)
                Text(
                  'Almost. I know you can do better',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
              if (ending == 3)
                Text(
                  'Good job. You got GOLD',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                          .pushReplacement(GamePage.route(level));
                    },
                    icon: const Icon(Icons.refresh),
                  ),
                  spaceL,
                  if (level < 9)
                    IconButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacement(GamePage.route(level + 1));
                      },
                      icon: const Icon(Icons.navigate_next),
                    ),
                ],
              ),
              const Spacer(),
            ],
          ),
        );
      },
    );
  }
}
