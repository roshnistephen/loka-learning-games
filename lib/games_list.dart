import 'package:flutter/material.dart';

class GamesListPlaceholder extends StatelessWidget {
  const GamesListPlaceholder({super.key});

  static const List<_Game> _games = [
    _Game(
      title: 'Balloon Game',
      route: '/baloon-game',
      color: Color(0xFF87CEFA),
      icon: Icons.videogame_asset,
    ),
    _Game(
      title: 'Letters Game',
      route: '/letter-game',
      color: Color(0xFFFFA8D9),
      icon: Icons.abc,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final tileWidth = (width * 0.46) > 160 ? 160.0 : (width * 0.46);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Games'),
        backgroundColor: const Color(0xFF7CC6FF),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            SizedBox(
              height: 160,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _games.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final game = _games[index];
                  return _GameTile(game: game, width: tileWidth);
                },
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Choose a game and have fun!',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Game {
  final String title;
  final String route;
  final Color color;
  final IconData icon;
  const _Game({
    required this.title,
    required this.route,
    required this.color,
    required this.icon,
  });
}

class _GameTile extends StatelessWidget {
  final _Game game;
  final double width;
  const _GameTile({required this.game, required this.width, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => Navigator.of(context).pushNamed(game.route),
          child: Ink(
            decoration: BoxDecoration(
              color: game.color,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(game.icon, size: 44, color: Colors.white),
                  const SizedBox(height: 12),
                  Text(
                    game.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
