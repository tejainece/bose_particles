import 'package:bose_particles/bose_particles.dart';
import 'package:chandrasekhar/chandrasekhar.dart';
import 'package:flutter/material.dart';
import 'package:ramanujan/ramanujan.dart';
import 'package:vector_canvas/vector_canvas.dart';

import 'template.dart';

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
    emissionInterval: Duration(milliseconds: 5000),
    lifetime: RandomScaledDuration(Duration(milliseconds: 5000)),
    /*lifetime: RandomScaledDuration(
      Duration(seconds: 3),
      randomize: NormalizedDoubleRange(0.4, 1.0),
    ),*/
    particlesPerInterval: RandomInt(1),
    useEmittedAngle: false,
    speedMultiplier: RandomDouble(1.5),
    angle: RandomDouble(
      45.toRadian,
      randomize: DoubleRange(-15.toRadian, 15.toRadian),
    ),
    // angleVelocity: RandomPoint(P(20 / 1e6, -20 / 1e6)),
    size: RandomPoint(P(5, 10)),
    curve: NewtonianDeterministicParticleCurve(
      gravity: -600,
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
    particlePainter: LineFairyDustParticlePainter(
      glow: P(3, 3),
      // glowOffset: P(-2, -2),
      glimmer: glimmer(3, max: 3),
    ),
  );
  late final Component _comp = _emitterComponent;

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

              color: Colors.white,
              component: LayerComponent([
                AxisComponent(viewport, yUp: yUp),
                _comp,
              ]),
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
