import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'plank_tower_game.dart';

class PlankTowerPage extends StatefulWidget {
  const PlankTowerPage({super.key});

  @override
  State<PlankTowerPage> createState() => _PlankTowerPageState();
}

class _PlankTowerPageState extends State<PlankTowerPage> {
  late final PlankTowerGame game;

  @override
  void initState() {
    super.initState();
    game = PlankTowerGame();
  }

  @override
  void dispose() {
    // Don't call game.dispose() — GameWidget manages the game's lifecycle.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plank Balance Tower')),
      body: Stack(
        children: [
          GameWidget(game: game),
          Positioned(
            right: 12,
            top: 12,
            child: ValueListenableBuilder<int>(
              valueListenable: game.plankCount,
              builder: (_, count, __) => Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Text('Planks: $count'),
                ),
              ),
            ),
          ),
          Positioned(
            left: 12,
            bottom: 12,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => game.dropBoulder(),
                    icon: const Icon(Icons.sports_handball),
                    label: const Text('Destroy'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => game.tiltLeft(),
                    icon: const Icon(Icons.arrow_left),
                    label: const Text('Tilt L'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => game.tiltRight(),
                    icon: const Icon(Icons.arrow_right),
                    label: const Text('Tilt R'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => game.resetWorld(),
                    icon: const Icon(Icons.restart_alt),
                    label: const Text('Reset'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
