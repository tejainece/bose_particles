import 'package:bose_particles/bose_particles.dart';
import 'package:chandrasekhar/chandrasekhar.dart';
import 'package:flutter/material.dart';
import 'package:game_engine/game_engine.dart';
import 'package:ramanujan/ramanujan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Material(color: Colors.black, child: const MyHomePage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final emitter = DeterministicEmitter(
    surface: LineEmitterSurface(P(0, 0), P(100, 0)),
    interval: Duration(milliseconds: 200),
    curve: LinearDeterministicParticleCurve(
      velocityX: easeInNormalizedMapper,
      velocityY: easeInNormalizedMapper,
    ),
  );

  late final EmitterComponent _comp = EmitterComponent(emitter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(children: []),
          Expanded(child: GameWidget(color: Colors.black, component: _comp)),
        ],
      ),
    );
  }
}
