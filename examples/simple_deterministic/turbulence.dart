import 'package:bose_particles/bose_particles.dart';
import 'package:chandrasekhar/chandrasekhar.dart';
import 'package:flutter/material.dart';
import 'package:ramanujan/ramanujan.dart';
import 'package:vector_canvas/vector_canvas.dart';

import '../template.dart';

void main() {
  runApp(const MyApp(MyHomePage()));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final emitter = DeterministicEmitter(
    // surface: LineEmitterSurface(P(0, 0), P(100, 0)),
    surface: PointEmitterSurface(P(0, 0)),
    emissionInterval: Duration(milliseconds: 500),
    particlesPerInterval: RandomInt(1),
    lifetime: RandomScaledDuration(
      Duration(seconds: 3),
      randomize: NormalizedDoubleRange(0.4, 1.0),
    ),
    useEmittedAngle: false,
    angle: RandomDouble(
      90.toRadian,
      // randomize: DoubleRange(-15.toRadian, 15.toRadian),
    ),
    speedMultiplier: RandomDouble(1),
    size: RandomPoint(P(5, 10), randomizeX: DoubleRange(-3, 3)),
    turbulence: glimmer(5),
    turbulenceScale: RandomDouble(25),
    curve: SimpleDeterministicParticleCurve(
      // velocityX: easeInNormalizedMapper,
      // velocityY: easeInNormalizedMapper,
    ),
  );

  late final EmitterComponent _emitterComponent = EmitterComponent(
    emitter,
    /*particlePainter: CircularFairyDustParticlePainter(
      glow: P(3, 3),
      glowOffset: P(-2, -2),
      glimmer: glimmer(3),
    ),*/
    particlePainter: CircularFairyDustParticlePainter(
      glow: P(3, 3),
      // glowOffset: P(-2, -2),
      glimmer: glimmer(3, max: 3),
    ),
  );
  late final Component _comp = TransformComponent([
    _emitterComponent,
  ], Affine2d(translateX: 100, translateY: 100).matrix4dColMajor);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(children: []),
          Expanded(
            child: GameWidget(
              transformer:
                  yUp
                      ? centeredYUpWith(translate: viewport.center)
                      : centeredYDownWith(translate: viewport.center),

              color: Colors.black,
              component: _comp,
              onResize: (size) {
                setState(() {
                  viewport = R.centerAt(
                    viewport.center,
                    size.width,
                    size.height,
                  );
                });
              },
              onPan: _onPan,
            ),
          ),
        ],
      ),
    );
  }

  void _onPan(PanData data) {
    final offset = P(data.offsetDelta.dx, -data.offsetDelta.dy);
    viewport = viewport.shift(-offset);
    setState(() {});
  }

  bool yUp = true;
  R viewport = R(-200, -200, 400, 400);
}
