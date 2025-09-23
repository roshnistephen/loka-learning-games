import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class BalloonGamePage extends StatefulWidget {
  const BalloonGamePage({super.key});

  @override
  State<BalloonGamePage> createState() => _BalloonGamePageState();
}

class _BalloonGamePageState extends State<BalloonGamePage> {
  final Random _random = Random();
  final AudioPlayer _player = AudioPlayer();
  List<int> _balloons = List.generate(10, (i) => i); // 10 balloons

  Future<void> _playPopSound() async {
    try {
      await _player.play(
        AssetSource('sounds/success.mp3'),
      ); // ✅ ensure file exists
    } catch (_) {}
  }

  void _popBalloon(int id) {
    setState(() {
      _balloons.remove(id);
    });
    _playPopSound();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      appBar: AppBar(
        title: const Text("🎈 Balloon Pop!"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Stack(
        children: _balloons.map((id) {
          // Random position for each balloon
          final left =
              _random.nextDouble() * (MediaQuery.of(context).size.width - 80);
          final top =
              _random.nextDouble() * (MediaQuery.of(context).size.height - 200);
          final color =
              Colors.primaries[_random.nextInt(Colors.primaries.length)];

          return Positioned(
            left: left,
            top: top,
            child: GestureDetector(
              onTap: () => _popBalloon(id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 60,
                height: 80,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.8),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text("🎈", style: TextStyle(fontSize: 24)),
                ),
              ),
            ),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _balloons = List.generate(10, (i) => i); // Reset balloons
          });
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
