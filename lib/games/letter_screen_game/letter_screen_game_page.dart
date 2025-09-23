import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class LetterScreen extends StatefulWidget {
  const LetterScreen({super.key});

  @override
  State<LetterScreen> createState() => _LetterScreenState();
}

class _LetterScreenState extends State<LetterScreen>
    with TickerProviderStateMixin {
  final AudioPlayer _player = AudioPlayer();
  final Random _rnd = Random();

  // A–Z letters with emoji + example word
  static const List<Map<String, String>> _letters = [
    {'letter': 'A', 'emoji': '🍎', 'word': 'Apple'},
    {'letter': 'B', 'emoji': '🧸', 'word': 'Ball'},
    {'letter': 'C', 'emoji': '🐱', 'word': 'Cat'},
    {'letter': 'D', 'emoji': '🐶', 'word': 'Dog'},
    {'letter': 'E', 'emoji': '🥚', 'word': 'Egg'},
    {'letter': 'F', 'emoji': '🐸', 'word': 'Frog'},
    {'letter': 'G', 'emoji': '🍇', 'word': 'Grapes'},
    {'letter': 'H', 'emoji': '🏠', 'word': 'House'},
    {'letter': 'I', 'emoji': '🍦', 'word': 'Ice Cream'},
    {'letter': 'J', 'emoji': '🤹‍♂️', 'word': 'Juggle'},
    {'letter': 'K', 'emoji': '🔑', 'word': 'Key'},
    {'letter': 'L', 'emoji': '🦁', 'word': 'Lion'},
    {'letter': 'M', 'emoji': '🌝', 'word': 'Moon'},
    {'letter': 'N', 'emoji': '🐦', 'word': 'Nest'},
    {'letter': 'O', 'emoji': '🐙', 'word': 'Octopus'},
    {'letter': 'P', 'emoji': '🍍', 'word': 'Pineapple'},
    {'letter': 'Q', 'emoji': '👑', 'word': 'Queen'},
    {'letter': 'R', 'emoji': '🚗', 'word': 'Road'},
    {'letter': 'S', 'emoji': '🐍', 'word': 'Snake'},
    {'letter': 'T', 'emoji': '🚂', 'word': 'Train'},
    {'letter': 'U', 'emoji': '☂️', 'word': 'Umbrella'},
    {'letter': 'V', 'emoji': '🎻', 'word': 'Violin'},
    {'letter': 'W', 'emoji': '🌊', 'word': 'Wave'},
    {'letter': 'X', 'emoji': '❌', 'word': 'X (Cross)'},
    {'letter': 'Y', 'emoji': '🌱', 'word': 'Yam'},
    {'letter': 'Z', 'emoji': '🦓', 'word': 'Zebra'},
  ];

  int _index = 0;
  double _scale = 1.0;
  Color _accent = Colors.pinkAccent;

  // animate pop effect
  Future<void> _tapAnimate() async {
    setState(() {
      _accent = Colors.primaries[_rnd.nextInt(Colors.primaries.length)];
      _scale = 1.25;
    });
    await Future.delayed(const Duration(milliseconds: 180));
    setState(() => _scale = 1.0);
  }

  // optional: play A.mp3, B.mp3 … from assets/sounds/
  Future<void> _playLetterAudio(String letter) async {
    final assetPath = 'sounds/${letter.toUpperCase()}.mp3';
    try {
      await _player.play(AssetSource(assetPath));
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No audio file for $letter (optional).')),
      );
    }
  }

  void _next() {
    setState(() {
      if (_index < _letters.length - 1) _index++;
    });
  }

  void _prev() {
    setState(() {
      if (_index > 0) _index--;
    });
  }

  void _restart() {
    setState(() => _index = 0);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = _letters[_index];
    final letter = data['letter']!;
    final emoji = data['emoji']!;
    final word = data['word']!;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        title: const Text('Learn Letters'),
        backgroundColor: _accent,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 18),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Tap the letter!',
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                  const SizedBox(height: 12),

                  GestureDetector(
                    onTap: () {
                      _tapAnimate();
                      _playLetterAudio(letter);
                    },
                    child: AnimatedScale(
                      scale: _scale,
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOutBack,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: const Alignment(-0.2, -0.3),
                            colors: [
                              _accent.withOpacity(0.95),
                              _accent.withOpacity(0.7),
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _accent.withOpacity(0.35),
                              blurRadius: 20,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            letter,
                            style: const TextStyle(
                              fontSize: 110,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  Text(emoji, style: const TextStyle(fontSize: 48)),
                  const SizedBox(height: 8),
                  Text(
                    word,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Letter ${_index + 1} of ${_letters.length}',
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 12,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _prev,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Prev'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _playLetterAudio(letter),
                      icon: const Icon(Icons.volume_up),
                      label: const Text('Hear'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _next,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Next'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 14.0, left: 18, right: 18),
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: _restart,
                    icon: const Icon(Icons.restart_alt),
                    label: const Text('Restart'),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Done'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
