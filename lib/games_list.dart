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
    _Game(
      title: 'Plank Game',
      route: '/plank-game',
      color: Color(0xFFFFD54F),
      icon: Icons.abc_sharp,
    ),
    _Game(
      title: 'Counting',
      route: '/counting-flashcard',
      color: Color(0xFFB39DDB),
      icon: Icons.calculate,
    ),
    _Game(
      title: 'Animal Families',
      route: '/animal-families',
      color: Color(0xFF81C784),
      icon: Icons.pets,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final horizontalPadding = 16.0;
    final spacing = 12.0;
    final crossAxisCount = width < 420
        ? 2
        : width < 800
        ? 3
        : 4;
    final childAspectRatio = 3 / 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Games'),
        backgroundColor: const Color(0xFF7CC6FF),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 16,
          ),
          child: GridView.builder(
            itemCount: _games.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              childAspectRatio: childAspectRatio,
            ),
            itemBuilder: (context, index) {
              final game = _games[index];
              return _GameTile(game: game);
            },
          ),
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
  const _GameTile({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
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
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(game.icon, size: 44, color: Colors.white),
                const SizedBox(height: 10),
                Text(
                  game.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
