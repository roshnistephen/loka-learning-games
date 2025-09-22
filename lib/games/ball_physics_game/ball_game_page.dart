import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'ball_game.dart';

class BallGamePage extends StatefulWidget {
  const BallGamePage({super.key});
  @override
  State<BallGamePage> createState() => _BallGamePageState();
}

class _BallGamePageState extends State<BallGamePage> {
  final BallGame _game = BallGame();
  @override
  void dispose() {
    _game.pauseEngine();
    super.dispose();
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Physics Game'),
        backgroundColor: const Color(0xFF7CC6FF),
      ),
      body: Stack(
        children: [
          GameWidget(game: _game),
          Positioned(top: 12, right: 12, child: _statusBox()),
          Positioned(bottom: 18, left: 16, right: 16, child: _controls()),
        ],
      ),
    );
  }

  Widget _statusBox() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white70,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      'Balls: ${_game.dynamicCount}    Size: ${_game.largeBalls ? "Large" : "Small"}',
    ),
  );

  Widget _controls() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        onPressed: () {
          _game.clearDynamic();
          setState(() {});
        },
        child: const Text('Clear'),
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
        onPressed: () {
          _game.toggleLargeBalls();
          setState(() {});
        },
        child: Text(_game.largeBalls ? 'Small Balls' : 'Large Balls'),
      ),
    ],
  );
}
