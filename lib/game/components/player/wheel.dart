import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import '../../assets.dart';
import '../../forge_flame_gamejam3.dart';
import '../entities/finish_line.dart';
import '../entities/start_line.dart';
import '../hazards/lava_block.dart';
import '../hazards/water_block.dart';
import '../platform/coals_block.dart';
import '../platform/ground_block.dart';
import '../platform/ice_block.dart';
import 'car.dart';

class Wheel extends BodyComponent<VeryGoodForgeGame> with ContactCallbacks {
  static const _torque = 20.0;
  static const _speed = 20.0;

  final Vector2 initialPosition;
  MouseJoint? mouseJoint;
  late Body groundBody;
  late Component drawing;
  final bool powered;
  final Car car;
  late WheelJoint wheelJoint;

  // final size = 0.3;
  late double size;

  bool touchingGround = false;
  bool touchingIce = false;
  bool touchingCoals = false;

  Wheel({
    required this.initialPosition,
    required this.car,
    this.powered = false,
  }) {
    size = car.width * 0.4;
  }

  @override
  Future<void> onLoad() async {
    groundBody = world.createBody(BodyDef());

    // final sprite = miniSprites['wheel'];
    final sprite = await game.loadSprite(imgWheel);

    add(
      SpriteComponent(
        sprite: sprite,
        position: Vector2.zero(),
        size: Vector2.all(size),
        anchor: Anchor.center,
      ),
    );
    return super.onLoad();
  }

  @override
  Body createBody() {
    renderBody = false;

    final shape = CircleShape()..radius = size * 0.5;

    body = world.createBody(
      BodyDef(
        type: BodyType.dynamic,
        userData: this,
        position: initialPosition,
      ),
    );
    body.createFixture(
      FixtureDef(
        shape,
        friction: 1.0,
        restitution: 0.1,
        density: 1.0,
      ),
    );

    final dummyGroundBody = world.createBody(BodyDef());
    world
      ..createJoint(
        FrictionJoint(
          FrictionJointDef()
            ..initialize(body, dummyGroundBody, body.worldCenter)
            ..maxTorque = 1.0,
        ),
      )
      ..createJoint(
        wheelJoint = WheelJoint(
          WheelJointDef()
            ..initialize(car.body, body, body.position, Vector2(0, 1))
            ..dampingRatio = 0.0
            ..frequencyHz = 20
            ..enableMotor = false
            ..motorSpeed = 0.0
            ..maxMotorTorque = _torque,
        ),
      );

    print('wheel mass: ${body.mass}kg');

    return body;
  }

  @override
  void preSolve(Object other, Contact contact, Manifold oldManifold) {
    if (other is StartLine) {
      contact.isEnabled = false;
    }
  }

  // @override
  // void beginContact(Object other, Contact contact) {
  //   if (other is GroundBlock) {
  //   } else if (other is LavaBlock || other is WaterBlock) {
  //     car.die();
  //   } else if (other is FinishLine) {
  //     car.win();
  //   }
  // }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is GroundBlock) {
      updateTouches(newTouchingGround: true);
    } else if (other is IceBlock) {
      updateTouches(newTouchingIce: true);
    } else if (other is CoalsBlock) {
      updateTouches(newTouchingCoals: true);
    } else if (other is LavaBlock) {
      car.die(burn: true);
    } else if (other is WaterBlock) {
      car.die(burn: false);
    } else if (other is FinishLine) {
      car.win(other.ending);
    }
  }

  @override
  void endContact(Object other, Contact contact) {
    if (other is GroundBlock) {
      updateTouches(newTouchingGround: false);
    } else if (other is IceBlock) {
      updateTouches(newTouchingIce: false);
    } else if (other is CoalsBlock) {
      updateTouches(newTouchingCoals: false);
    }
  }

  void updateTouches({
    bool? newTouchingGround,
    bool? newTouchingIce,
    bool? newTouchingCoals,
    // bool? touchingWater,
    // bool? touchingLava,
  }) {
    touchingGround = newTouchingGround ?? touchingGround;
    touchingIce = newTouchingIce ?? touchingIce;
    touchingCoals = newTouchingCoals ?? touchingCoals;
    // _touchingWater = touchingWater ?? _touchingWater;
    // _touchingLava = touchingLava ?? _touchingLava;
  }

  bool forward() {
    if (!powered) return true;

    wheelJoint
      ..enableMotor(true)
      ..motorSpeed = _speed;
    return false;
  }

  bool backward() {
    if (!powered) return true;
    wheelJoint
      ..enableMotor(true)
      ..motorSpeed = -_speed;
    return false;
  }

  bool stop() {
    if (!powered) return true;
    wheelJoint
      ..enableMotor(false)
      ..motorSpeed = 0;
    return false;
  }
}
