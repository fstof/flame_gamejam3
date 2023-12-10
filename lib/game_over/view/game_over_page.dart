import '../../game/assets.dart';
import '../../level_select/view/level_select_page.dart';
import '../../scoring/cubit/scoring_cubit.dart';
import '../../styles/styles.dart';
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
        return state.map(
          initial: (initial) => const Placeholder(),
          loaded: (loaded) {
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
                  ],
                  spaceL,
                  _buildTrophies(context, loaded),
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
                      if (level < 10)
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
      },
    );
  }

  Widget _buildTrophies(BuildContext context, Loaded loaded) {
    var trophyCount = 0;
    if (loaded.scores[level]?[1] ?? false) trophyCount++;
    if (loaded.scores[level]?[2] ?? false) trophyCount++;
    if (loaded.scores[level]?[3] ?? false) trophyCount++;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (loaded.scores[level]?[1] ?? false)
              Image.asset(
                'assets/images/$imgTrophyBroze',
                width: MediaQuery.of(context).size.width * 0.25,
                height: MediaQuery.of(context).size.width * 0.25,
                fit: BoxFit.cover,
              ),
            if (loaded.scores[level]?[2] ?? false)
              Image.asset(
                'assets/images/$imgTrophySilver',
                width: MediaQuery.of(context).size.width * 0.25,
                height: MediaQuery.of(context).size.width * 0.25,
                fit: BoxFit.cover,
              ),
            if (loaded.scores[level]?[3] ?? false)
              Image.asset(
                'assets/images/$imgTrophyGold',
                width: MediaQuery.of(context).size.width * 0.25,
                height: MediaQuery.of(context).size.width * 0.25,
                fit: BoxFit.cover,
              ),
          ],
        ),
        if (trophyCount == 0) ...[
          Text(
            '''You have no trophies!.''',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          Text(
            '''Try again and get them all!''',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
        ],
        if (trophyCount == 1) ...[
          Text(
            '''You've got a trophy!''',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          Text(
            '''Only two more to go. Try again!''',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
        ],
        if (trophyCount == 2) ...[
          Text(
            '''You've got 2 trophies. ''',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          Text(
            '''Don't forget the last one. You can do it!''',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
        ],
        if (trophyCount == 3) ...[
          Text(
            '''You've got all the trophies!''',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          Text(
            '''Good job!''',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
        ],
      ],
    );
  }
}
