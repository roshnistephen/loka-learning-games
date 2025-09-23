import 'package:flutter/material.dart';
import 'games_list.dart';
import 'games/baloon_game/baloon_game_page.dart';
import 'main_welcome.dart';
import 'games/letter_screen_game/letter_screen_game_page.dart';

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
        '/baloon-game': (ctx) => BalloonGamePage(),
        '/letter-game': (ctx) => LetterScreen(),
      },
      initialRoute: '/',
    );
  }
}
