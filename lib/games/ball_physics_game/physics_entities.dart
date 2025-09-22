import 'dart:ui';
import 'package:flame_forge2d/flame_forge2d.dart';

class Ball extends BodyComponent {
  final Vector2 pos;
  final Vector2? initialVelocity;
  final double radius;
  Ball(this.pos, {this.initialVelocity, this.radius = 1.1});
  @override
  Body createBody() {
    final bd = BodyDef()
      ..type = BodyType.dynamic
      ..position = pos;
    final b = world.createBody(bd);
    final s = CircleShape()..radius = radius;
    final fd = FixtureDef(s)
      ..density = 1.0
      ..restitution = 0.35
      ..friction = 0.25;
    b.createFixture(fd);
    if (initialVelocity != null) b.linearVelocity = initialVelocity!;
    return b;
  }

  @override
  void render(Canvas c) {
    final p = Paint()..color = const Color(0xFFFFA8D9);
    c.drawCircle(Offset.zero, radius, p);
  }
}

class Box extends BodyComponent {
  final Vector2 pos;
  final Vector2 sizeVec;
  Box(this.pos, {Vector2? sizeVec}) : sizeVec = sizeVec ?? Vector2.all(2.0);
  @override
  Body createBody() {
    final bd = BodyDef()
      ..type = BodyType.dynamic
      ..position = pos;
    final b = world.createBody(bd);
    final s = PolygonShape()..setAsBoxXY(sizeVec.x / 2, sizeVec.y / 2);
    final fd = FixtureDef(s)
      ..density = 1.2
      ..friction = 0.6
      ..restitution = 0.03;
    b.createFixture(fd);
    return b;
  }

  @override
  void render(Canvas c) {
    final p = Paint()..color = const Color(0xFF8ED1FC);
    final rect = Rect.fromCenter(
      center: Offset.zero,
      width: sizeVec.x,
      height: sizeVec.y,
    );
    c.drawRect(rect, p);
  }
}

class Ground extends BodyComponent {
  final double yWorld;
  Ground(this.yWorld);
  @override
  Body createBody() {
    final bd = BodyDef()
      ..type = BodyType.static
      ..position = Vector2(0, yWorld);
    final b = world.createBody(bd);
    final s = PolygonShape()..setAsBoxXY(100.0, 1.0);
    final fd = FixtureDef(s)..friction = 1.0;
    b.createFixture(fd);
    return b;
  }

  @override
  void render(Canvas c) {
    final p = Paint()..color = const Color(0xFF6BCB77);
    final r = Rect.fromCenter(center: Offset.zero, width: 200.0, height: 2.0);
    c.drawRect(r, p);
  }
}
