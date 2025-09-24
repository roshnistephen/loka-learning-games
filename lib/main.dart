import 'package:flutter/material.dart';
import 'games_list.dart';
import 'games/baloon_game/baloon_game_page.dart';
import 'games/letter_screen_game/letter_screen_game_page.dart';
import 'games/plank_tower/plank_tower_page.dart';
import 'games/counting_flashcard/counting_flashcard_page.dart';
import 'games/animal_families/animal_families_page.dart';
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
        '/baloon-game': (ctx) => const BalloonGamePage(),
        '/letter-game': (ctx) => LetterScreen(),
        '/plank-game': (ctx) => const PlankTowerPage(),
        '/counting-flashcard': (ctx) => const CountingFlashcardPage(),
        '/animal-families': (ctx) => const AnimalFamiliesPage(),
      },
      initialRoute: '/',
    );
  }
}
