import 'package:flame_gamejam3/game_over/view/game_over_page.dart';
import 'package:flutter/material.dart';

import '../../game/assets.dart';
import '../../game/view/game_page.dart';
import '../../level_select/view/level_select_page.dart';
import '../../styles/styles.dart';

class TitlePage extends StatelessWidget {
  const TitlePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const TitlePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/$imgBackdrop',
            fit: BoxFit.cover,
          ),
          const SafeArea(child: TitleView()),
        ],
      ),
    );
  }
}

class TitleView extends StatelessWidget {
  const TitleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Text(
            'Heat-Chill Cruiser',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const Spacer(),
          SizedBox(
            height: 200,
            child: Image.asset(
              'assets/images/$imgIcon',
              fit: BoxFit.cover,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 250,
            // height: 64,
            child: FilledButton(
              onPressed: () {
                // Navigator.of(context).pushReplacement(GamePage.route(1));
                Navigator.of(context).pushReplacement(GamePage.route(1));
              },
              child: const Center(child: Text('Start')),
            ),
          ),
          spaceM,
          SizedBox(
            width: 250,
            // height: 64,
            child: FilledButton(
              onPressed: () {
                Navigator.of(context).push(LevelSelectPage.route());
              },
              child: const Center(child: Text('Level Select')),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
