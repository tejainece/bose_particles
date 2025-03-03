import 'dart:ui';

import 'package:chandrasekhar/chandrasekhar.dart';
import 'package:flutter/material.dart';
import 'package:game_engine/game_engine.dart';

class EmitterComponent extends Component implements NeedsTick {
  ComponentContext? _ctx;
  final DeterministicEmitter emitter;
  ParticlePainter _particlePainter;
  double _speed = 1;

  EmitterComponent(
    this.emitter, {
    double speed = 1,
    ParticlePainter? particlePainter,
  }) : _speed = speed,
       _particlePainter = FairyDustParticlePainter();

  @override
  void render(Canvas canvas) {
    for (final particle in emitter.at(_time)) {
      _particlePainter.paintParticle(canvas, particle);
    }
  }

  Duration _time = Duration();

  void set({Duration? time, double? speed, ParticlePainter? particlePainter}) {
    if (speed != null) {
      _speed = speed;
    }
    if (particlePainter != null) {
      _particlePainter = particlePainter;
    }
    if (time != null) {
      _time = time;
      _ctx?.requestRender(this);
    }
  }

  @override
  void tick(TickContext ctx) {
    _ctx?.requestRender(this);
    _time += ctx.dt * _speed;
  }

  @override
  void onAttach(ComponentContext ctx) {
    _ctx = ctx;
  }
}

// typedef ParticlePainter = void Function(Canvas canvas, Particle particle);
abstract class ParticlePainter {
  void paintParticle(Canvas canvas, Particle particle);
}

class FairyDustParticlePainter implements ParticlePainter {
  double _size = 5;

  @override
  void paintParticle(Canvas canvas, Particle particle) {
    /*canvas.drawCircle(
      particle.position.o,
      3,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.8)
        ..imageFilter = ImageFilter.blur(sigmaX: 2, sigmaY: 2),
    );*/
    canvas.drawCircle(
      particle.position.o,
      _size + 1 * ((particle.lifePercentage * 100) % 10) / 10,
      Paint()
        ..color = Colors.yellowAccent
        ..imageFilter = ImageFilter.blur(sigmaX: 3, sigmaY: 3),
    );
    canvas.drawCircle(
      particle.position.o,
      _size / 2,
      Paint()
        ..color = Colors.yellowAccent
        // ..imageFilter = ImageFilter.blur(sigmaX: 1, sigmaY: 1),
    );
  }
}
