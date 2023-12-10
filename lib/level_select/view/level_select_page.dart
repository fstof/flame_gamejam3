import 'package:flame_gamejam3/game/assets.dart';
import 'package:flame_gamejam3/scoring/cubit/scoring_cubit.dart';
import 'package:flame_gamejam3/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../game/view/game_page.dart';

class LevelSelectPage extends StatelessWidget {
  const LevelSelectPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const LevelSelectPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select a level')),
      body: const LevelSelectView(),
    );
  }
}

class LevelSelectView extends StatelessWidget {
  const LevelSelectView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScoringCubit, ScoringState>(
      builder: (context, state) {
        return state.map(
          initial: (initial) {
            return const Placeholder();
          },
          loaded: (loaded) {
            return Center(
              child: GridView.count(
                // scrollDirection: Axis.horizontal,
                padding: edgeAllM,
                crossAxisCount: 5,
                children: List.generate(10, (index) => index)
                    .map(
                      (e) => _buildMapTile(
                        context,
                        e + 1,
                        loaded.scores[e + 1] ?? 0,
                      ),
                    )
                    .toList(),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMapTile(BuildContext context, int level, int ending) {
    return Padding(
      padding: edgeAllM,
      child: SizedBox(
        width: 20,
        height: 20,
        child: FilledButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(GamePage.route(level));
          },
          // child: Center(child: Text('Level $level - $ending')),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Level $level'),
                if (ending > 0)
                  Image.asset(
                    'assets/images/${ending == 1 ? imgTrophyBroze : ending == 2 ? imgTrophySilver : ending == 3 ? imgTrophyGold : ''}',
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
