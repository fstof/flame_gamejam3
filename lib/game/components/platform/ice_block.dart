import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import '../../assets.dart';

class IceBlock extends BodyComponent {
  final Vector2 initialPosition;

  IceBlock({required this.initialPosition});

  @override
  Future<void> onLoad() async {
    final sprite = await game.loadSprite(imgIce);

    add(
      SpriteComponent(
        sprite: sprite,
        position: Vector2.zero(),
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
      ..setAsBox(halfTileSize, halfTileSize, Vector2.zero(), 0);

    final bodyDef = BodyDef(
      type: BodyType.static,
      userData: this,
      position: initialPosition,
    );
    final fixtureDef = FixtureDef(
      shape,
      friction: 0.05,
      density: 50,
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
