import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import '../../assets.dart';

class StartLine extends BodyComponent {
  final Vector2 initialPosition;

  StartLine({required this.initialPosition});

  @override
  Future<void> onLoad() async {
    final sprite = await game.loadSprite(imgStart);
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
      ..setAsBox(
        halfTileSize,
        halfTileSize,
        Vector2.zero(),
        0,
      );

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
