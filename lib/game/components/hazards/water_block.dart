import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import '../../assets.dart';

class WaterBlock extends BodyComponent {
  final Vector2 initialPosition;

  WaterBlock({required this.initialPosition});

  @override
  Future<void> onLoad() async {
    final animation = await game.loadSpriteAnimation(
      imgWaterAnim,
      SpriteAnimationData.sequenced(
        amount: 3,
        stepTime: 0.2,
        textureSize: Vector2.all(32),
      ),
    );

    await add(
      SpriteAnimationComponent(
        animation: animation,
        size: Vector2.all(tileSize),
        anchor: Anchor.center,
      ),
    );
    // add(
    //   SpriteComponent(
    //     sprite: miniSprites['water'],
    //     size: Vector2.all(tileSize),
    //     anchor: Anchor.center,
    //   ),
    // );

    return super.onLoad();
  }

  @override
  Body createBody() {
    renderBody = false;
    final shape = PolygonShape()
      ..setAsBox(
        halfTileSize,
        halfTileSize * 0.1,
        Vector2.zero(),
        0,
      );

    final bodyDef = BodyDef(
      type: BodyType.static,
      userData: this,
      position: initialPosition,
    );

    final fixtureDef = FixtureDef(
      shape,
      friction: 1.0,
      density: 0.1,
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
