import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'physics_entities.dart';

class BallGame extends Forge2DGame with TapDetector {
  bool largeBalls = false;
  BallGame() : super(gravity: Vector2(0, 10), zoom: 10);

  int get dynamicCount => children.whereType<BodyComponent>().where((b) {
    try {
      return b.body.bodyType == BodyType.dynamic;
    } catch (_) {
      return false;
    }
  }).length;

  void toggleLargeBalls() => largeBalls = !largeBalls;

  void clearDynamic() {
    final toRemove = children.whereType<BodyComponent>().where((b) {
      try {
        return b.body.bodyType == BodyType.dynamic;
      } catch (_) {
        return false;
      }
    }).toList();
    for (var c in toRemove) c.removeFromParent();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final bottomY = size.y * 0.88;
    add(Ground(bottomY));
    final startX = size.x * 0.70;
    for (int i = 0; i < 3; i++)
      add(
        Box(
          Vector2(startX, bottomY - (i + 0.6) * 2.0),
          sizeVec: Vector2.all(2.0),
        ),
      );
  }

  void spawnBall(Vector2 worldTap) {
    final spawn = Vector2(size.x * 0.18, size.y * 0.28);
    final dir = (worldTap - spawn);
    if (dir.length > 0.001) {
      dir.normalize();
      dir.scale(18.0);
    }
    final radius = largeBalls ? 1.8 : 1.1;
    add(Ball(spawn, initialVelocity: dir, radius: radius));
  }

  @override
  void onTapDown(TapDownInfo info) {
    final widgetPos = info.eventPosition.widget;
    final cs = canvasSize;
    final worldX = widgetPos.x / cs.x * size.x;
    final worldY = widgetPos.y / cs.y * size.y;
    spawnBall(Vector2(worldX, worldY));
    super.onTapDown(info);
  }
}
