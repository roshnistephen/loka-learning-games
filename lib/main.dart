import 'package:flutter/material.dart';
import 'games_list.dart';
import 'games/ball_physics_game/ball_game_page.dart';
import 'main_welcome.dart';

void main() => runApp(const LokaApp());

class LokaApp extends StatelessWidget {
  const LokaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loka Word Builder',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (ctx) => const WelcomePage(),
        '/games': (ctx) => const GamesListPlaceholder(),
        '/play-ball-game': (ctx) => BalloonGamePage(), // ✅ fixed
      },
      initialRoute: '/',
    );
  }
}
