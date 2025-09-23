// lib/games/ball_physics_game/ball_game_page.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class BalloonGamePage extends StatefulWidget {
  const BalloonGamePage({super.key});

  @override
  State<BalloonGamePage> createState() => _BalloonGamePageState();
}

class _BalloonGamePageState extends State<BalloonGamePage>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _player = AudioPlayer();
  final Random _rnd = Random();

  int _index = 0; // 0 => 'A', 25 => 'Z'
  bool _visible = true;
  double _scale = 1.0;
  double _opacity = 1.0;
  Color _color = Colors.pinkAccent;

  static const double _balloonWidth = 92;
  static const double _balloonHeight = 112;

  @override
  void initState() {
    super.initState();
    _pickRandomColor();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String get _currentLetter => String.fromCharCode(65 + _index); // 'A' + index

  void _pickRandomColor() {
    _color = Colors.primaries[_rnd.nextInt(Colors.primaries.length)]
        .withOpacity(0.95);
  }

  Future<void> _playPopSound() async {
    try {
      await _player.play(AssetSource('sounds/success.mp3'));
    } catch (_) {
      // ignore: sometimes web/audio may not play; don't crash
    }
  }

  void _pop() {
    if (!_visible) return;
    setState(() {
      _scale = 1.6;
      _opacity = 0.0;
      _visible = false;
    });
    _playPopSound();

    // after the pop animation, advance to next letter (or finish)
    Future.delayed(const Duration(milliseconds: 320), () {
      setState(() {
        _index++;
        if (_index >= 26) {
          // Completed A-Z -> show a simple "Well done!" toast-like area
          // We'll keep index at 26 to show completion state
          _index = 26;
        } else {
          // next letter
          _pickRandomColor();
          _scale = 1.0;
          _opacity = 1.0;
          _visible = true;
        }
      });
    });
  }

  void _reset() {
    setState(() {
      _index = 0;
      _pickRandomColor();
      _scale = 1.0;
      _opacity = 1.0;
      _visible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final centerLeft = (screenW - _balloonWidth) / 2;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1), // warm pastel background
      appBar: AppBar(
        title: const Text('🎈 Balloon ABC'),
        backgroundColor: const Color.fromARGB(255, 64, 255, 150),
      ),
      body: Stack(
        children: [
          // Decorative clouds / shapes (very subtle)
          Positioned(
            left: 20,
            top: 40,
            child: Opacity(
              opacity: 0.08,
              child: Icon(Icons.cloud, size: 120, color: Colors.blue),
            ),
          ),
          Positioned(
            right: 16,
            top: 100,
            child: Opacity(
              opacity: 0.06,
              child: Icon(Icons.star, size: 100, color: Colors.yellow[700]),
            ),
          ),

          // Center area: one balloon at a time
          Positioned(
            left: centerLeft,
            top: MediaQuery.of(context).size.height * 0.18,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 220),
              opacity: _index < 26 ? _opacity : 1.0,
              child: AnimatedScale(
                scale: _scale,
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutBack,
                child: _index < 26 ? _buildBalloon() : _buildCompletionCard(),
              ),
            ),
          ),

          // Bottom controls: progress + reset
          Positioned(
            left: 16,
            right: 16,
            bottom: 28,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Progress text
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 6),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _index < 26
                            ? 'Letter: $_currentLetter'
                            : 'All done! 🎉',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${_index >= 26 ? 26 : _index + 1}/26',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _reset,
                      icon: const Icon(Icons.restart_alt),
                      label: const Text('Restart'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_index < 26 && !_visible) return;
                        if (_index < 26) {
                          // skip (simulate pop)
                          _pop();
                        } else {
                          // when completed, restart
                          _reset();
                        }
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: Text(_index < 26 ? 'Pop' : 'Play again'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------
  // ONLY CHANGED: improved balloon drawing (minimal CustomPainter)
  // ---------------------------
  Widget _buildBalloon() {
    // show a realistic-looking balloon with the letter in center
    return GestureDetector(
      onTap: _pop,
      child: SizedBox(
        width: _balloonWidth,
        height: _balloonHeight,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // string (curved)
            Positioned(
              top: _balloonHeight - 18,
              child: SizedBox(
                width: _balloonWidth,
                height: 60,
                child: CustomPaint(painter: _StringPainter()),
              ),
            ),

            // balloon body drawn by CustomPainter
            Positioned(
              top: 0,
              child: SizedBox(
                width: _balloonWidth,
                height: _balloonHeight * 0.85,
                child: CustomPaint(
                  painter: _SimpleBalloonPainter(color: _color),
                ),
              ),
            ),

            // knot overlay (small darker shape)
            Positioned(
              top: (_balloonHeight * 0.85) - 12,
              child: Container(
                width: _balloonWidth * 0.16,
                height: _balloonHeight * 0.07,
                decoration: BoxDecoration(
                  color: _color.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),

            // letter
            Text(
              _currentLetter,
              style: const TextStyle(
                fontSize: 40,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 6,
                    color: Colors.black26,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletionCard() {
    return Container(
      width: _balloonWidth + 10,
      height: _balloonHeight,
      decoration: BoxDecoration(
        color: Colors.yellow[600],
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black26)],
      ),
      child: const Center(
        child: Text(
          '🎉\nWell done!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

/// Minimal painter for a soft teardrop-shaped balloon (simple + lightweight)
class _SimpleBalloonPainter extends CustomPainter {
  final Color color;
  _SimpleBalloonPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Offset center = Offset(w / 2, h * 0.38);

    // simple teardrop shape using cubic path
    final Path body = Path();
    body.moveTo(center.dx, h * 0.05);
    body.cubicTo(w * 0.92, h * 0.02, w * 0.96, h * 0.55, center.dx, h * 0.92);
    body.cubicTo(w * 0.04, h * 0.55, w * 0.08, h * 0.02, center.dx, h * 0.05);
    body.close();

    // gradient fill for slight 3D feel
    final Rect shaderRect = Rect.fromLTWH(0, 0, w, h);
    final paint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.2, -0.6),
        colors: [
          color.withOpacity(1.0),
          color.withOpacity(0.75),
          Colors.white.withOpacity(0.18),
        ],
        stops: const [0.0, 0.7, 1.0],
      ).createShader(shaderRect);

    canvas.drawPath(body, paint);

    // soft glow
    final glow = Paint()
      ..color = color.withOpacity(0.18)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawPath(body, glow);

    // rim stroke for crisp edge
    final rim = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = max(1.0, w * 0.04)
      ..color = Colors.white.withOpacity(0.45);
    canvas.drawPath(body, rim);

    // highlight ellipse
    final highlightRect = Rect.fromCenter(
      center: Offset(center.dx - w * 0.22, center.dy - h * 0.28),
      width: w * 0.34,
      height: h * 0.18,
    );
    final highlight = Paint()..color = Colors.white.withOpacity(0.75);
    canvas.drawOval(highlightRect, highlight);
  }

  @override
  bool shouldRepaint(covariant _SimpleBalloonPainter old) => old.color != color;
}

/// Simple curved string painter
class _StringPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint p = Paint()
      ..color = Colors.grey[600]!.withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    final Path path = Path();
    final double w = size.width;
    final double topY = 6.0;
    path.moveTo(w / 2, topY);
    path.quadraticBezierTo(w * 0.58, topY + 18, w * 0.45, topY + 36);
    path.quadraticBezierTo(w * 0.32, topY + 54, w * 0.5, topY + 72);
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant _StringPainter oldDelegate) => false;
}
