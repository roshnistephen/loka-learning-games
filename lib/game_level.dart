import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:audioplayers/audioplayers.dart';

class GameLevelPage extends StatefulWidget {
  final String levelName;
  const GameLevelPage({super.key, required this.levelName});
  @override
  State<GameLevelPage> createState() => _GameLevelPageState();
}

class _GameLevelPageState extends State<GameLevelPage> {
  final AudioPlayer _player = AudioPlayer();
  late final List<String> letters;
  late List<String?> slots;
  late List<String> available;
  late List<bool> slotWrong;
  int _dragFromSlotIndex = -1;
  List<String> _levels = [];

  @override
  void initState() {
    super.initState();
    letters = widget.levelName.toUpperCase().split('');
    slots = List<String?>.filled(letters.length, null);
    available = List<String>.from(letters)..shuffle(Random());
    slotWrong = List<bool>.filled(letters.length, false);
    _player.play(AssetSource('levels/${widget.levelName}.mp3'));
    _loadLevels();
  }

  Future<void> _loadLevels() async {
    try {
      final s = await rootBundle.loadString('assets/levels/levels.json');
      final d = jsonDecode(s);
      if (d is List) _levels = d.map((e) => e.toString()).toList();
      if (d is Map && d['levels'] is List)
        _levels = (d['levels'] as List).map((e) => e.toString()).toList();
    } catch (_) {}
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _onAccept(int slotIndex, String data) {
    final wasFromSlot = _dragFromSlotIndex != -1;
    if (data == letters[slotIndex]) {
      setState(() {
        slots[slotIndex] = data;
        if (!wasFromSlot) available.remove(data);
        slotWrong[slotIndex] = false;
        _dragFromSlotIndex = -1;
      });
      _checkComplete();
    } else {
      setState(() => slotWrong[slotIndex] = true);
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => slotWrong[slotIndex] = false);
      });
      if (wasFromSlot) {
        final origin = _dragFromSlotIndex;
        _dragFromSlotIndex = -1;
        if (mounted) setState(() => slots[origin] = data);
      }
    }
  }

  void _checkComplete() {
    for (int i = 0; i < letters.length; i++) {
      if (slots[i] != letters[i]) return;
    }
    Future.delayed(const Duration(milliseconds: 800), () async {
      await _player.stop();
      if (!mounted) return;
      final idx = _levels.indexOf(widget.levelName);
      if (idx == -1 || _levels.isEmpty) {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (_) => AlertDialog(content: const Text('Great Job!')),
        );
        return;
      }
      final next = _levels[(idx + 1) % _levels.length];
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => GameLevelPage(levelName: next)),
      );
    });
  }

  Widget _tile(String text, Color color) {
    return Container(
      width: 64,
      height: 64,
      alignment: Alignment.center,
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = 'assets/levels/${widget.levelName}.jpg';
    final media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.levelName.toUpperCase()),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up, color: Colors.black87),
            onPressed: () =>
                _player.play(AssetSource('levels/${widget.levelName}.mp3')),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: media.height * 0.34,
            width: double.infinity,
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.center,
            children: available.map((letter) {
              return Draggable<String>(
                data: letter,
                feedback: _tile(letter, Colors.blueAccent),
                childWhenDragging: Opacity(
                  opacity: 0.25,
                  child: _tile(letter, Colors.deepOrange),
                ),
                child: _tile(letter, Colors.deepOrange),
                onDragStarted: () => _dragFromSlotIndex = -1,
              );
            }).toList(),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(letters.length, (i) {
                return DragTarget<String>(
                  builder: (context, incoming, rejected) {
                    final occupied = slots[i];
                    final color = occupied != null
                        ? Colors.green
                        : (slotWrong[i] ? Colors.red : Colors.grey.shade200);
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 72,
                      height: 72,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black12),
                      ),
                      alignment: Alignment.center,
                      child: occupied == null
                          ? const SizedBox.shrink()
                          : Draggable<String>(
                              data: occupied,
                              feedback: _tile(occupied, Colors.green),
                              childWhenDragging: const SizedBox.shrink(),
                              child: _tile(occupied, Colors.green),
                              onDragStarted: () {
                                _dragFromSlotIndex = i;
                                setState(() => slots[i] = null);
                              },
                              onDragCompleted: () => _dragFromSlotIndex = -1,
                              onDraggableCanceled: (_, __) {
                                if (mounted)
                                  setState(() {
                                    slots[i] = occupied;
                                    _dragFromSlotIndex = -1;
                                  });
                              },
                            ),
                    );
                  },
                  onWillAccept: (d) => slots[i] == null,
                  onAccept: (data) => setState(() => _onAccept(i, data)),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
