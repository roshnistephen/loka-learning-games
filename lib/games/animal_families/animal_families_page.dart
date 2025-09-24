import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AnimalFamiliesPage extends StatefulWidget {
  const AnimalFamiliesPage({super.key});

  @override
  State<AnimalFamiliesPage> createState() => _AnimalFamiliesPageState();
}

class _AnimalFamiliesPageState extends State<AnimalFamiliesPage> {
  final FlutterTts flutterTts = FlutterTts();
  final random = Random();

  // Baby–Mother pairs
  final List<Map<String, String>> pairs = [
    {
      "baby": "assets/animals/puppy.png",
      "mother": "assets/animals/dog.png",
      "name": "Puppy",
    },
    {
      "baby": "assets/animals/kitten.png",
      "mother": "assets/animals/cat.png",
      "name": "Kitten",
    },
    {
      "baby": "assets/animals/chick.png",
      "mother": "assets/animals/hen.png",
      "name": "Chick",
    },
    {
      "baby": "assets/animals/calf.png",
      "mother": "assets/animals/cow.png",
      "name": "Calf",
    },
  ];

  late List<Map<String, String>> babies;
  late List<Map<String, String>> mothers;

  Map<String, String>? selectedBaby;
  Map<String, String>? selectedMother;

  @override
  void initState() {
    super.initState();
    _shuffleAnimals();
  }

  void _shuffleAnimals() {
    babies = List.from(pairs)..shuffle(random);
    mothers = List.from(pairs)..shuffle(random);
    selectedBaby = null;
    selectedMother = null;
    setState(() {});
  }

  void _checkMatch() async {
    if (selectedBaby != null && selectedMother != null) {
      if (selectedBaby!["mother"] == selectedMother!["mother"]) {
        await flutterTts.speak(
          "Correct! ${selectedBaby!['name']} belongs to its mother.",
        );
        Future.delayed(const Duration(seconds: 2), _shuffleAnimals);
      } else {
        await flutterTts.speak("Oops! Try again.");
        setState(() {
          selectedBaby = null;
          selectedMother = null;
        });
      }
    }
  }

  Widget _animalTile(
    String imgPath,
    String label, {
    bool selected = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: selected ? Colors.orangeAccent : Colors.white,
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Image.asset(imgPath, height: 60),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Animal Families")),
      body: Row(
        children: [
          // Left side (babies)
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: babies.map((baby) {
                return _animalTile(
                  baby["baby"]!,
                  baby["name"]!,
                  selected: selectedBaby == baby,
                  onTap: () async {
                    setState(() => selectedBaby = baby);
                    await flutterTts.speak(baby["name"]!);
                    _checkMatch();
                  },
                );
              }).toList(),
            ),
          ),
          const VerticalDivider(width: 1, color: Colors.black26),
          // Right side (mothers)
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: mothers.map((mom) {
                return _animalTile(
                  mom["mother"]!,
                  "Mother",
                  selected: selectedMother == mom,
                  onTap: () {
                    setState(() => selectedMother = mom);
                    _checkMatch();
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
