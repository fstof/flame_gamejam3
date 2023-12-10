import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import '../../assets.dart';

class VolcanoBlock extends BodyComponent {
  final Vector2 initialPosition;

  VolcanoBlock({required this.initialPosition});

  @override
  Future<void> onLoad() async {
    // final sprite = miniSprites['volcano'];
    final sprite = await game.loadSprite(imgVolcano);
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
