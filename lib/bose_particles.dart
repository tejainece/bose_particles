import 'dart:math';
import 'dart:ui';

import 'package:chandrasekhar/chandrasekhar.dart';
import 'package:flutter/material.dart';
import 'package:ramanujan/ramanujan.dart';
import 'package:vector_canvas/vector_canvas.dart';

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
       _particlePainter = particlePainter ?? CircularFairyDustParticlePainter();

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

class CircularFairyDustParticlePainter implements ParticlePainter {
  final P glow;
  final P glowScale;
  final P glowOffset;
  final NormalizedMapper? glimmer;

  CircularFairyDustParticlePainter({
    this.glow = const P(5, 5),
    this.glowScale = const P(1, 1),
    this.glowOffset = P.zero,
    this.glimmer,
  });

  @override
  void paintParticle(Canvas canvas, Particle particle) {
    double size = particle.size.x;
    if (size <= 0) return;
    {
      double glowSize = size + 1;
      if (glimmer != null) {
        glowSize += glimmer!(particle.lifePercentage);
        // glowXSize *= glimmer!(particle.lifePercentage);
        // glowYSize *= glimmer!(particle.lifePercentage);
      }
      canvas.drawCircle(
        particle.position.o + glowOffset.o,
        glowSize,
        Paint()
          ..color = Colors.orangeAccent.withAlpha(150)
          ..imageFilter = ImageFilter.blur(sigmaX: glow.x, sigmaY: glow.y),
      );
    }
    canvas.drawCircle(
      particle.position.o,
      size / 2,
      Paint()..color = Colors.orangeAccent,
    );
  }
}

class LineFairyDustParticlePainter implements ParticlePainter {
  final P glow;
  final P glowScale;
  final P glowOffset;
  final NormalizedMapper? glimmer;

  LineFairyDustParticlePainter({
    this.glow = const P(5, 5),
    this.glowScale = const P(1, 1),
    this.glowOffset = P.zero,
    this.glimmer,
  });

  @override
  void paintParticle(Canvas canvas, Particle particle) {
    if (particle.size.x == 0 || particle.size.y == 0) return;
    final angle = (Radian(particle.angle) - pi).value;
    {
      double glowSize = particle.size.y + 1;
      if (glimmer != null) {
        glowSize += glimmer!(particle.lifePercentage);
        // glowXSize *= glimmer!(particle.lifePercentage);
        // glowYSize *= glimmer!(particle.lifePercentage);
      }
      final line = LineSegment(
        particle.position,
        P.onCircle(angle, glowSize, particle.position),
      );
      LineComponent.paintLineSegment(
        canvas,
        line,
        strokePaint:
            Paint()
              ..color = Colors.orangeAccent.withAlpha(255)
              ..strokeWidth = particle.size.x + 1
              ..imageFilter = ImageFilter.blur(sigmaX: glow.x, sigmaY: glow.y),
      );
    }
    final line = LineSegment(
      particle.position,
      P.onCircle(angle, particle.size.y, particle.position),
    );
    LineComponent.paintLineSegment(
      canvas,
      line,
      stroke: Stroke(color: Colors.orangeAccent, strokeWidth: particle.size.x),
    );
  }
}
