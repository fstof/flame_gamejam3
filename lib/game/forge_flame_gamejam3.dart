import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'audio/audio_controller.dart';
import 'components/hazards/snowman_block.dart';
import 'components/hazards/volcano_block.dart';
import 'components/platform/coals_block.dart';
import 'components/platform/ice_block.dart';
import 'package:flame_mini_sprite/flame_mini_sprite.dart';
import 'package:flutter/material.dart';
import 'package:mini_sprite/mini_sprite.dart';

import 'assets.dart';
import 'components/entities/finish_line.dart';
import 'components/entities/start_line.dart';
import 'components/hazards/lava_block.dart';
import 'components/hazards/water_block.dart';
import 'components/platform/ground_block.dart';
import 'components/player/car.dart';

class VeryGoodForgeGame extends Forge2DGame with HasKeyboardHandlerComponents {
  VeryGoodForgeGame({
    required this.level,
    required this.audioController,
    required this.onLose,
    required this.onWin,
  }) : super(
          zoom: 30,
          gravity: Vector2(0, 20),
        );
  final int level;
  final AudioController audioController;

  void Function(int ending) onWin;
  void Function() onLose;

  @override
  Color backgroundColor() => const Color(0xFF2A48DF);

  @override
  Future<void> onLoad() async {
    await _addBackground();

    final map = MiniMap.fromDataString(maps['map$level']!);

    miniSprites = await miniLibrary.toSprites(
      pixelSize: 1,
      palette: [Colors.white],
    );

    BodyComponent? player;

    for (final entity in map.objects.entries) {
      final pos =
          Vector2(entity.key.x.toDouble() * 2, entity.key.y.toDouble() * 2);
      // final pos = Vector2((entity.key.x + 1) * 2, entity.key.y * 2);
      // final pos = Vector2((entity.key.x + 1) * 32, entity.key.y * 32);

      if (entity.value['sprite'] == 'ground' ||
          entity.value['sprite'] == 'ground2') {
        world.add(
          GroundBlock(
            initialPosition: pos,
            type: entity.value['sprite'].toString(),
          ),
        );
      } else if (entity.value['sprite'] == 'ice') {
        world.add(IceBlock(initialPosition: pos));
      } else if (entity.value['sprite'] == 'coals') {
        world.add(CoalsBlock(initialPosition: pos));
      } else if (entity.value['sprite'] == 'water') {
        world.add(WaterBlock(initialPosition: pos));
      } else if (entity.value['sprite'] == 'lava') {
        world.add(LavaBlock(initialPosition: pos));
      } else if (entity.value['sprite'] == 'snowman') {
        world.add(SnowmanBlock(initialPosition: pos));
      } else if (entity.value['sprite'] == 'volcano') {
        world.add(VolcanoBlock(initialPosition: pos));
      } else if (entity.value['sprite'] == 'start') {
        world.add(StartLine(initialPosition: pos));
      } else if (entity.value['sprite'] == 'end') {
        final ending = int.parse(entity.value['ending'].toString());
        world.add(FinishLine(initialPosition: pos, ending: ending));
      } else if (entity.value['sprite'] == 'player') {
        world.add(
          player = Car(initialPosition: pos, audioController: audioController),
        );
      }
    }

    unawaited(
      player?.mounted.whenComplete(() => camera.follow(player!)),
    );

    super.onLoad();
  }

  Future<void> _addBackground() async {
    final mountainsLayer = await loadParallaxLayer(
      ParallaxImageData(imgBg1),
      filterQuality: FilterQuality.none,
    );

    final skyLayer = await loadParallaxLayer(
      ParallaxAnimationData(
        imgBg2Anim,
        SpriteAnimationData.sequenced(
          amount: 14,
          stepTime: 0.1,
          textureSize: Vector2(1152, 320),
        ),
      ),
      velocityMultiplier: Vector2(2, 0),
      filterQuality: FilterQuality.none,
    );

    // final cloudsLayer = await loadParallaxLayer(
    //   ParallaxImageData('parallax/heavy_clouded.png'),
    //   velocityMultiplier: Vector2(4, 0),
    //   fill: LayerFill.none,
    //   alignment: Alignment.topLeft,
    //   filterQuality: FilterQuality.none,
    // );

    final parallax = Parallax(
      [
        skyLayer,
        mountainsLayer,
      ],
      baseVelocity: Vector2(20, 0),
    );

    final parallaxComponent = ParallaxComponent(parallax: parallax);
    add(parallaxComponent);
  }
}
