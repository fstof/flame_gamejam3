import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_gamejam3/game/components/platform/coals_block.dart';
import 'package:flame_gamejam3/game/components/platform/ice_block.dart';
import 'package:flutter/services.dart';

import '../../assets.dart';
import '../../audio/audio_controller.dart';
import '../../audio/sounds.dart';
import '../../forge_flame_gamejam3.dart';
import '../entities/finish_line.dart';
import '../entities/start_line.dart';
import '../hazards/lava_block.dart';
import '../hazards/water_block.dart';
import '../platform/ground_block.dart';
import 'wheel.dart';

class Car extends BodyComponent<VeryGoodForgeGame>
    with KeyboardHandler, ContactCallbacks {
  static const _jumpForce = 60.0;
  static const _coalTime = 2;
  AudioController audioController;

  late SpriteAnimation normalAnimation;
  late SpriteAnimation burnAnimation;
  late SpriteAnimation freezeAnimation;
  late SpriteAnimationComponent currentAnimation;

  final Vector2 initialPosition;
  late Wheel _wheel1;
  late Wheel _wheel2;
  final double width = tileSize;
  final double height = halfTileSize;
  var _canJump = true;
  var _airJump = 0;

  var _touchingGround = false;
  var _touchingIce = false;
  var _touchingCoals = false;

  var _done = false;

  double _timeOnCoals = 0;

  Car({required this.initialPosition, required this.audioController});

  @override
  Future<void> onLoad() async {
    normalAnimation = await game.loadSpriteAnimation(
      imgCarAnim,
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.2,
        textureSize: Vector2(32, 32),
      ),
    );
    burnAnimation = await game.loadSpriteAnimation(
      imgCarBurnAnim,
      SpriteAnimationData.sequenced(
        amount: 20,
        stepTime: 0.1,
        textureSize: Vector2(32, 32),
        loop: false,
      ),
    );
    freezeAnimation = await game.loadSpriteAnimation(
      imgCarFreezeAnim,
      SpriteAnimationData.sequenced(
        amount: 20,
        stepTime: 0.1,
        textureSize: Vector2(32, 32),
        loop: false,
      ),
    );

    await add(
      currentAnimation = SpriteAnimationComponent(
        animation: normalAnimation,
        size: Vector2.all(tileSize),
        anchor: Anchor.center,
        position: Vector2(0, -0.25),
      ),
    );

    // add(
    //   SpriteComponent(
    //     sprite: miniSprites['car'],
    //     position: Vector2.zero(),
    //     // size: Vector2.all(2),
    //     size: Vector2(width, height),
    //     anchor: Anchor.center,
    //   ),
    // );

    add(
      KeyboardListenerComponent(
        keyUp: {
          LogicalKeyboardKey.keyA: (keysPressed) => stop(),
          LogicalKeyboardKey.keyD: (keysPressed) => stop(),
          LogicalKeyboardKey.arrowLeft: (keysPressed) => stop(),
          LogicalKeyboardKey.arrowRight: (keysPressed) => stop(),
        },
        keyDown: {
          LogicalKeyboardKey.keyA: (keysPressed) => backward(),
          LogicalKeyboardKey.keyD: (keysPressed) => forward(),
          LogicalKeyboardKey.arrowLeft: (keysPressed) => backward(),
          LogicalKeyboardKey.arrowRight: (keysPressed) => forward(),
          LogicalKeyboardKey.space: (keysPressed) => jump(),
        },
      ),
    );

    return super.onLoad();
  }

  @override
  Body createBody() {
    renderBody = false;

    final halfWidth = width * 0.5;
    final halfHeight = width * 0.25;

    final verteces = <Vector2>[
      Vector2(-halfWidth * 0.25, -halfHeight),
      Vector2(halfWidth * 0.65, -halfHeight),
      Vector2(halfWidth, 0),
      Vector2(halfWidth, halfHeight),
      Vector2(-halfWidth, halfHeight),
      Vector2(-halfWidth, 0),
    ];

    final shape = PolygonShape()..set(verteces);

    // final shape = PolygonShape()
    //   ..setAsBox(width * 0.5, height * 0.5, Vector2.zero(), 0);

    // _groundBody = world.createBody(BodyDef());
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
        friction: 0.5,
        restitution: 0.1,
        density: 2,
      ),
    );

    world
      ..add(
        _wheel1 = Wheel(
          initialPosition:
              initialPosition + Vector2(-width * 0.3, height * 0.5),
          car: this,
          powered: true,
        ),
      )
      ..add(
        _wheel2 = Wheel(
          initialPosition: initialPosition + Vector2(width * 0.3, height * 0.5),
          car: this,
          powered: true,
        ),
      );

    print('body mass: ${body.mass}kg');

    return body;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (body.position.y > 50) {
      // print('off screen: ${body.position.y}');
      die();
    }

    if (_timeOnCoals > _coalTime) {
      die(burn: true);
    }

    if (_anythintTouchingGround()) {
      // print('touching Ground');
      _canJump = true;
      _airJump = 0;
    }
    if (_anythintTouchingIce()) {
      _canJump = true;
      _airJump = 0;
      // print('touching Ice for ${_timeOnIce}s');
    }
    if (_anythintTouchingCoals()) {
      _canJump = true;
      _airJump = 0;
      _timeOnCoals += dt;
      // print('touching Coals for ${_timeOnCoals}s');
    } else {
      _timeOnCoals = 0;
    }
    if (!_anythintTouchingGround() &&
        !_anythintTouchingIce() &&
        !_anythintTouchingCoals()) {
      // print('in the air');
      _canJump = false;
    }
  }

  @override
  void preSolve(Object other, Contact contact, Manifold oldManifold) {
    if (
        // other is FinishLine ||
        other is StartLine) {
      contact.isEnabled = false;
    }
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is GroundBlock) {
      updateTouches(touchingGround: true);
    } else if (other is IceBlock) {
      updateTouches(touchingIce: true);
    } else if (other is CoalsBlock) {
      updateTouches(touchingCoals: true);
    } else if (other is LavaBlock) {
      die(burn: true);
    } else if (other is WaterBlock) {
      die(burn: false);
    } else if (other is FinishLine) {
      win(other.ending);
    }
  }

  @override
  void endContact(Object other, Contact contact) {
    if (other is GroundBlock) {
      updateTouches(touchingGround: false);
    } else if (other is IceBlock) {
      updateTouches(touchingIce: false);
    } else if (other is CoalsBlock) {
      updateTouches(touchingCoals: false);
    }
  }

  void updateTouches({
    bool? touchingGround,
    bool? touchingIce,
    bool? touchingCoals,
    // bool? touchingWater,
    // bool? touchingLava,
  }) {
    _touchingGround = touchingGround ?? _touchingGround;
    _touchingIce = touchingIce ?? _touchingIce;
    _touchingCoals = touchingCoals ?? _touchingCoals;
    // _touchingWater = touchingWater ?? _touchingWater;
    // _touchingLava = touchingLava ?? _touchingLava;
  }

  bool _anythintTouchingIce() {
    return _touchingIce || _wheel1.touchingIce || _wheel2.touchingIce;
  }

  bool _anythintTouchingCoals() {
    return _touchingCoals || _wheel1.touchingCoals || _wheel2.touchingCoals;
  }

  bool _anythintTouchingGround() {
    return _touchingGround || _wheel1.touchingGround || _wheel2.touchingGround;
    // if (body.contacts.isEmpty &&
    //     _wheel1.body.contacts.isEmpty &&
    //     _wheel2.body.contacts.isEmpty) {
    //   return false;
    // } else {
    //   for (final contact in _wheel1.body.contacts) {
    //     if (contact.bodyA.userData is GroundBlock ||
    //         contact.bodyA.userData is IceBlock ||
    //         contact.bodyA.userData is CoalsBlock) {
    //       return true;
    //     }
    //   }
    //   for (final contact in _wheel2.body.contacts) {
    //     if (contact.bodyA.userData is GroundBlock ||
    //         contact.bodyA.userData is IceBlock ||
    //         contact.bodyA.userData is CoalsBlock) {
    //       return true;
    //     }
    //   }
    //   for (final contact in body.contacts) {
    //     if (contact.bodyA.userData is GroundBlock ||
    //         contact.bodyA.userData is IceBlock ||
    //         contact.bodyA.userData is CoalsBlock) {
    //       return true;
    //     }
    //   }
    // }
    // return false;
  }

  void die({bool? burn}) {
    if (_done) return;
    _done = true;
    remove(currentAnimation);
    late SpriteAnimation nextAnimation;
    if (burn == null) {
      audioController.playSfx(SoundType.die);
      nextAnimation = burnAnimation;
    } else if (burn) {
      audioController.playSfx(SoundType.burn);
      nextAnimation = burnAnimation;
    } else {
      audioController.playSfx(SoundType.freeze);
      nextAnimation = freezeAnimation;
    }
    add(
      currentAnimation = SpriteAnimationComponent(
        animation: nextAnimation,
        size: Vector2.all(tileSize),
        anchor: Anchor.center,
        position: Vector2(0, -0.25),
      ),
    );
    game.onLose();
  }

  void win(int ending) {
    if (_done) return;
    audioController.playSfx(SoundType.win);
    _done = true;
    game.onWin(ending);
  }

  bool jump() {
    if (_done) return false;
    if (_canJump || _airJump < 1) {
      _airJump++;

      audioController.playSfx(SoundType.jump);

      body.applyLinearImpulse(
        Vector2(0, -_jumpForce),
        // point: body.worldCenter + Vector2(-0.25, 0),
      );
    }
    return false;
  }

  bool forward() {
    if (_done) return false;
    audioController.playSfx(SoundType.drive);
    _wheel1.forward();
    _wheel2.forward();
    return false;
  }

  bool backward() {
    if (_done) return false;
    audioController.playSfx(SoundType.drive);
    _wheel1.backward();
    _wheel2.backward();
    return false;
  }

  bool stop() {
    audioController.stopSfx();
    _wheel1.stop();
    _wheel2.stop();
    return false;
  }
}
