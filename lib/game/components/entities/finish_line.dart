import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import '../../assets.dart';

class FinishLine extends BodyComponent {
  final Vector2 initialPosition;
  final int ending;

  FinishLine({required this.initialPosition, required this.ending});

  @override
  Future<void> onLoad() async {
    //  final sprite = miniSprites['end'];
    late Sprite sprite;
    if (ending == 1) {
      sprite = await game.loadSprite(imgEnding1);
    } else if (ending == 2) {
      sprite = await game.loadSprite(imgEnding2);
    } else {
      sprite = await game.loadSprite(imgEnding3);
    }
    add(
      SpriteComponent(
        sprite: sprite,
        size: Vector2.all(tileSize),
        anchor: Anchor.center,
      ),
    );

    return super.onLoad();
  }

  @override
  Body createBody() {
    renderBody = false;
    final shape = PolygonShape()
      ..set([
        Vector2(-halfTileSize, -halfTileSize),
        Vector2(halfTileSize, -halfTileSize * 0.25),
        Vector2(halfTileSize, halfTileSize),
        Vector2(-halfTileSize, halfTileSize),
      ]);

    final bodyDef = BodyDef(
      type: BodyType.dynamic,
      userData: this,
      position: initialPosition,
    );

    final fixtureDef = FixtureDef(
      shape,
      // isSensor: true,
      friction: 1.0,
      density: 0.1,
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
