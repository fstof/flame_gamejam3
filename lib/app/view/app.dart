import 'package:audioplayers/audioplayers.dart';
import 'package:flame/cache.dart';
import 'package:flame_gamejam3/scoring/cubit/scoring_cubit.dart';
import 'package:flame_gamejam3/scoring/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../loading/loading.dart';
import '../../styles/styles.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => PreloadCubit(
            Images(prefix: ''),
            AudioCache(prefix: ''),
          )..loadSequentially(),
        ),
        BlocProvider(
          create: (context) => ScoringCubit(
            storage: Storage.instance,
          )..loadScores(),
        ),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const LoadingPage(),
    );
  }
}
