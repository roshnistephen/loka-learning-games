import 'package:flutter/material.dart';

class GamesListPlaceholder extends StatelessWidget {
  const GamesListPlaceholder({super.key});
  @override
  Widget build(BuildContext c) => Scaffold(
    appBar: AppBar(
      title: const Text('Games'),
      backgroundColor: const Color(0xFF7CC6FF),
      elevation: 0,
    ),
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.videogame_asset, size: 86, color: Color(0xFF3B2E74)),
          const SizedBox(height: 20),
          const Text(
            'Games List',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text('Select a game to play', textAlign: TextAlign.center),
          const SizedBox(height: 18),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF87CEFA),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: () => Navigator.pushNamed(c, '/play-ball-game'),
            child: const Text('Play Ball Physics'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFA8D9),
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(c),
            child: const Text('Back'),
          ),
        ],
      ),
    ),
  );
}
