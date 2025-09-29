import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class PlankTowerPage extends StatelessWidget {
  const PlankTowerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plank Balance Tower')),
      body: Center(
        child: SizedBox(
          width: 320,
          height: 320,
          child: RiveAnimation.asset(
            'characters/2.riv',
            controllers: [SimpleAnimation('Timeline 1')],
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
