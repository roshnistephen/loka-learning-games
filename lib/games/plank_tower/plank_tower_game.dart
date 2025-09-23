// lib/games/plank_tower/plank_tower_game.dart
import 'dart:math';
import 'dart:ui';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

class PlankTowerGame extends Forge2DGame with TapDetector, LongPressDetector {
  PlankTowerGame() : super(gravity: Vector2(0, 10));

  final Random _rnd = Random();
  final List<PlankBody> _planks = [];
  final List<BoulderBody> _boulders = [];
  final ValueNotifier<int> plankCount = ValueNotifier<int>(0);
  Body? _groundBody;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _createGround();
  }

  void _createGround() {
    final double groundY = size.y - 1.5;
    final EdgeShape edge = EdgeShape()
      ..set(Vector2(-1000, groundY), Vector2(1000, groundY));
    final BodyDef bd = BodyDef()..type = BodyType.static;
    final Body b = world.createBody(bd);
    b.createFixture(FixtureDef(edge));
    _groundBody = b;
  }

  /// Compute plank size relative to viewport and spawn a visible plank (optionally vertical)
  Future<void> _spawnPlank(
    Vector2 worldPos, {
    bool spawnVertical = false,
  }) async {
    // viewport-based sizing (works robustly across devices)
    // width: fraction of viewport width, minimum fallback
    double plankWidth = size.x * 0.28; // ~28% of world width
    if (plankWidth < 4.0)
      plankWidth = max(
        4.0,
        size.x * 0.5,
      ); // ensure visible on tiny world scales

    // height: fraction of viewport height, minimum fallback
    double plankHeight = size.y * 0.035; // ~3.5% of viewport height
    if (plankHeight < 0.4) plankHeight = 0.6;

    double angle = 0.0;
    if (spawnVertical) {
      angle = pi / 2; // vertical plank (90 degrees)
      // swap dims so the "width" and "height" still correspond visually
      final tmp = plankWidth;
      plankWidth = plankHeight * 1.8; // narrow but tall
      plankHeight = tmp * 0.15; // thin thickness
      // ensure reasonable sizes
      if (plankWidth < 1.2) plankWidth = 1.2;
      if (plankHeight < 0.4) plankHeight = 0.4;
    }

    final plank = PlankBody(
      worldPos,
      Vector2(plankWidth, plankHeight),
      angle: angle,
    );
    await add(plank);
    _planks.add(plank);
    plankCount.value = _planks.length + _boulders.length;
  }

  /// spawn a visible heavy boulder (size relative to viewport)
  Future<void> _spawnBoulder(Vector2 worldPos) async {
    double radius = max(
      1.2,
      size.x * 0.06,
    ); // radius scaled to viewport width with fallback
    final b = BoulderBody(worldPos, radius);
    await add(b);
    _boulders.add(b);
    plankCount.value = _planks.length + _boulders.length;
  }

  // Convert the screen tap to a world spawn location and spawn a plank.
  @override
  void onTapDown(TapDownInfo info) {
    // Using global because that worked in your environment.
    final sx = info.eventPosition.global.x;
    final sy = info.eventPosition.global.y;

    // Convert the screen pixels to a simple world mapping:
    // If you are not using any camera zoom/viewport transforms, screen->world roughly aligns.
    // We'll place spawn X proportionally and spawn Y well above the top so plank falls into view.
    final worldX = sx / size.x * size.x;
    final spawnY =
        -(size.y * 0.03); // spawn above the top (25% of viewport height above)
    _spawnPlank(Vector2(worldX, spawnY), spawnVertical: false);
  }

  // Long press spawns a slightly rotated plank (like a sloppy drop)
  @override
  void onLongPressStart(LongPressStartInfo info) {
    final sx = info.eventPosition.global.x;
    final worldX = sx / size.x * size.x;
    final spawnY = -(size.y * 0.03);
    final angle = (_rnd.nextDouble() - 0.5) * 0.9;
    // 25% chance to spawn a vertical plank on long-press
    final vertical = _rnd.nextDouble() < 0.25;
    if (vertical) {
      _spawnPlank(Vector2(worldX, spawnY), spawnVertical: true);
    } else {
      // spawn with small rotation
      _spawnPlank(Vector2(worldX, spawnY), spawnVertical: false).then((_) {
        // optionally rotate the very last plank a bit after creation
        if (_planks.isNotEmpty) {
          final last = _planks.last;
          try {
            last.body.setTransform(last.body.position, angle);
          } catch (_) {}
        }
      });
    }
  }

  // Public action to drop a boulder at center-top
  void dropBoulder() {
    final spawn = Vector2(
      size.x / 2,
      -(size.y * 0.4),
    ); // higher spawn for dramatic fall
    _spawnBoulder(spawn);
  }

  // Slight impulse "tilt" left
  void tiltLeft() {
    const double impulseStrength = 40.0;
    for (final p in _planks) {
      try {
        if (p.body.bodyType == BodyType.dynamic) {
          p.body.applyLinearImpulse(Vector2(-impulseStrength, -10));
        }
      } catch (_) {}
    }
    for (final b in _boulders) {
      try {
        if (b.body.bodyType == BodyType.dynamic) {
          b.body.applyLinearImpulse(Vector2(-impulseStrength, -10));
        }
      } catch (_) {}
    }
  }

  // Slight impulse "tilt" right
  void tiltRight() {
    const double impulseStrength = 40.0;
    for (final p in _planks) {
      try {
        if (p.body.bodyType == BodyType.dynamic) {
          p.body.applyLinearImpulse(Vector2(impulseStrength, -10));
        }
      } catch (_) {}
    }
    for (final b in _boulders) {
      try {
        if (b.body.bodyType == BodyType.dynamic) {
          b.body.applyLinearImpulse(Vector2(impulseStrength, -10));
        }
      } catch (_) {}
    }
  }

  void resetWorld() {
    for (final p in List<PlankBody>.from(_planks)) {
      try {
        remove(p);
      } catch (_) {}
    }
    _planks.clear();
    for (final b in List<BoulderBody>.from(_boulders)) {
      try {
        remove(b);
      } catch (_) {}
    }
    _boulders.clear();

    plankCount.value = 0;
    if (_groundBody == null) _createGround();
  }

  @override
  void update(double dt) {
    super.update(dt);
    final double removeY = size.y + 200; // generous off-screen cleanup
    final removedPlanks = <PlankBody>[];
    for (final p in _planks) {
      if (p.body.position.y > removeY) removedPlanks.add(p);
    }
    for (final p in removedPlanks) {
      remove(p);
      _planks.remove(p);
    }
    final removedB = <BoulderBody>[];
    for (final b in _boulders) {
      if (b.body.position.y > removeY) removedB.add(b);
    }
    for (final b in removedB) {
      remove(b);
      _boulders.remove(b);
    }
    final total = _planks.length + _boulders.length;
    if (plankCount.value != total) plankCount.value = total;
  }

  @override
  void onDetach() {
    plankCount.dispose();
    super.onDetach();
  }
}

/// Visual plank that is also a physics body
class PlankBody extends BodyComponent {
  final Vector2 spawnPos;
  final Vector2 plankSize; // width, height in world units
  final double angle;
  final Paint _paint = Paint()..color = const Color(0xFF8B5A2B);

  PlankBody(this.spawnPos, this.plankSize, {this.angle = 0});

  @override
  Body createBody() {
    final shape = PolygonShape()
      ..setAsBox(plankSize.x / 2, plankSize.y / 2, Vector2.zero(), angle);
    final bd = BodyDef()
      ..type = BodyType.dynamic
      ..position = spawnPos
      ..angle = angle;
    final body = world.createBody(bd);
    body.createFixture(
      FixtureDef(shape)
        ..density = 1.2
        ..friction = 0.6
        ..restitution = 0.05,
    );
    return body;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // draw rectangle centered at body; convert world units into canvas units (BodyComponent handles transform)
    final rect = Rect.fromCenter(
      center: Offset.zero,
      width: plankSize.x,
      height: plankSize.y,
    );
    canvas.drawRect(rect, _paint);
  }
}

/// Visual boulder
class BoulderBody extends BodyComponent {
  final Vector2 spawnPos;
  final double radius;
  final Paint _paint = Paint()..color = const Color(0xFF444444);

  BoulderBody(this.spawnPos, this.radius);

  @override
  Body createBody() {
    final circle = CircleShape()..radius = radius;
    final bd = BodyDef()
      ..type = BodyType.dynamic
      ..position = spawnPos;
    final body = world.createBody(bd);
    body.createFixture(
      FixtureDef(circle)
        ..density = 10
        ..friction = 0.5
        ..restitution = 0.05,
    );
    return body;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(Offset.zero, radius, _paint);
  }
}
