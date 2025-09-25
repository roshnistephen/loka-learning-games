import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class CountingFlashcardPage extends StatefulWidget {
  const CountingFlashcardPage({super.key});

  @override
  State<CountingFlashcardPage> createState() => _CountingFlashcardPageState();
}

class _CountingFlashcardPageState extends State<CountingFlashcardPage> {
  late int answer;
  late List<String> objects;
  int? dropped;
  final random = Random();

  final FlutterTts flutterTts = FlutterTts();

  final List<List<Color>> levelBackgrounds = [
    [Colors.lightBlue, Colors.blueAccent],
    [Colors.yellowAccent, Colors.orange],
    [Colors.greenAccent, Colors.green],
    [Colors.pinkAccent, Colors.pink],
    [Colors.purpleAccent, Colors.deepPurple],
  ];
  late List<Color> currentBackground;

  final List<String> objectPool = [
    "🍎",
    "🍌",
    "🍓",
    "🍇",
    "🍊",
    "🍉",
    "🍒",
    "🍍",
    "🥕",
    "🌽",
    "🚗",
    "🚙",
    "🚲",
    "✈️",
    "🚀",
    "🐶",
    "🐱",
    "🐰",
    "🐻",
    "🐸",
  ];

  @override
  void initState() {
    super.initState();
    _generateNewQuestion();
  }

  void _generateNewQuestion() {
    int count = random.nextInt(5) + 1; // 1–5 objects
    String chosen = objectPool[random.nextInt(objectPool.length)];
    objects = List.generate(count, (_) => chosen);
    answer = count;
    dropped = null;

    currentBackground =
        levelBackgrounds[random.nextInt(levelBackgrounds.length)];

    setState(() {});
  }

  Future<void> _speakResult() async {
    if (objects.isEmpty) return;
    String word = objects.first;
    await flutterTts.speak(
      "${_numberToWord(answer)} ${_getWordForEmoji(word)}",
    );
  }

  String _getWordForEmoji(String emoji) {
    switch (emoji) {
      case "🍎":
        return "apples";
      case "🍌":
        return "bananas";
      case "🍓":
        return "strawberries";
      case "🍇":
        return "grapes";
      case "🍊":
        return "oranges";
      case "🍉":
        return "watermelons";
      case "🍒":
        return "cherries";
      case "🍍":
        return "pineapples";
      case "🥕":
        return "carrots";
      case "🌽":
        return "corns";
      case "🚗":
        return "cars";
      case "🚙":
        return "cars";
      case "🚲":
        return "bicycles";
      case "✈️":
        return "airplanes";
      case "🚀":
        return "rockets";
      case "🐶":
        return "dogs";
      case "🐱":
        return "cats";
      case "🐰":
        return "rabbits";
      case "🐻":
        return "bears";
      case "🐸":
        return "frogs";
      default:
        return "items";
    }
  }

  String _numberToWord(int number) {
    const words = [
      "zero",
      "one",
      "two",
      "three",
      "four",
      "five",
      "six",
      "seven",
      "eight",
      "nine",
      "ten",
    ];
    if (number >= 0 && number <= 10) {
      return words[number];
    }
    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Counting Flashcards")),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: currentBackground,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: objects
                      .map(
                        (o) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(o, style: const TextStyle(fontSize: 50)),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Drag the correct number here:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DragTarget<int>(
              builder: (context, candidate, rejected) {
                return Container(
                  height: 100,
                  width: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: dropped == null
                        ? Colors.white
                        : (dropped == answer ? Colors.green : Colors.red),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Text(
                    dropped == null ? "?" : "$dropped",
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
              onAccept: (value) {
                setState(() => dropped = value);
                if (value == answer) {
                  _speakResult();
                  Future.delayed(
                    const Duration(seconds: 2),
                    _generateNewQuestion,
                  );
                }
              },
            ),
            const SizedBox(height: 40),
            Wrap(
              spacing: 20,
              children: _getOptions().map((num) {
                return Draggable<int>(
                  data: num,
                  feedback: numberBox(num, Colors.orange),
                  childWhenDragging: numberBox(num, Colors.grey),
                  child: numberBox(num, Colors.orange),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  List<int> _getOptions() {
    final opts = {answer};
    while (opts.length < 3) {
      opts.add(random.nextInt(5) + 1); // 1–5 range
    }
    return opts.toList()..shuffle();
  }

  Widget numberBox(int num, Color color) {
    return Container(
      height: 70,
      width: 70,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        "$num",
        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
    );
  }
}
