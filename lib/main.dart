import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'game_level.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Loka Word Builder',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: false,
      ),
      home: const LevelsPage(),
    );
  }
}

class LevelsPage extends StatefulWidget {
  const LevelsPage({super.key});
  @override
  State<LevelsPage> createState() => _LevelsPageState();
}

class _LevelsPageState extends State<LevelsPage> {
  late Future<List<String>> _levelsFuture;
  @override
  void initState() {
    super.initState();
    _levelsFuture = _loadLevels();
  }

  Future<List<String>> _loadLevels() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/levels/levels.json',
      );
      final decoded = jsonDecode(jsonString);
      if (decoded is List) return decoded.map((e) => e.toString()).toList();
      if (decoded is Map && decoded['levels'] is List) {
        return (decoded['levels'] as List).map((e) => e.toString()).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Levels'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: FutureBuilder<List<String>>(
        future: _levelsFuture,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final levels = snap.data ?? [];
          if (levels.isEmpty) {
            return const Center(child: Text('No levels found.'));
          }
          return ListView.separated(
            itemCount: levels.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final name = levels[index];
              final assetPath = 'assets/levels/$name.jpg';
              return ListTile(
                leading: SizedBox(
                  width: 56,
                  height: 56,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      assetPath,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, st) => Container(
                        color: const Color(0xFFF0F0F0),
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                title: Text(name.toUpperCase()),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GameLevelPage(levelName: name),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
