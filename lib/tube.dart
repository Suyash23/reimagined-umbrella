import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math';

// This will represent a single ring of our heaven tube
class TubeRing extends PositionComponent {
  // We use a Paint to say what our ring will look like
  final Paint paint;
  // This is how big the ring is right now
  double radius;
  // This is the angle where the gap in the ring starts.
  final double startAngle;
  // This is how big the gap in the ring is.
  final double sweepAngle;

  // When we make a new ring, we give it its properties
  TubeRing({
    required this.radius,
    required Color color,
    required this.startAngle,
    required this.sweepAngle,
  }) : paint = Paint()
          ..color = color
          // This makes the ring an outline, not a filled circle
          ..style = PaintingStyle.stroke
          // This is how thick the line of the ring is
          ..strokeWidth = 20.0;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // This is where we actually draw the arc on the screen.
    // An arc is a part of a circle.
    canvas.drawArc(
      // We define a rectangle that the arc will be drawn inside of.
      Rect.fromCircle(center: Offset(size.x / 2, size.y / 2), radius: radius),
      startAngle,
      sweepAngle,
      false, // This means we don't connect the ends of the arc to the center
      paint,
    );
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    // We make the ring component take up the whole screen
    size = gameSize;
    // We position the ring at the top-left corner of the screen
    position = Vector2(0, 0);
  }
}

// This is the main component for our tube. It will manage all the rings.
class Tube extends PositionComponent {
  // A list to hold all the rings that are currently on the screen
  List<TubeRing> get rings => _rings;
  final List<TubeRing> _rings = [];
  // A timer to control how often we add a new ring
  final Timer _spawnTimer = Timer(0.5, repeat: true);
  // A random number generator to make the rings have slightly different colors
  final Random _random = Random();

  // This is a special function that runs when the component is first added to the game
  @override
  Future<void> onLoad() async {
    super.onLoad();
    // We start the timer when the component loads
    _spawnTimer.start();
  }

  // This function is called for every frame of the game. It's where we update things.
  @override
  void update(double dt) {
    super.update(dt);
    // We update our timer
    _spawnTimer.update(dt);

    // If the timer has finished a cycle, it's time to add a new ring!
    if (_spawnTimer.finished) {
      _spawnRing();
    }

    // We create a list of rings that we need to remove
    // (the ones that have grown too big)
    final List<TubeRing> ringsToRemove = [];
    // We go through each ring in our list
    for (final ring in _rings) {
      // We make the ring bigger. 'dt' helps us make the growth smooth
      // no matter how fast the phone is.
      ring.radius += 200 * dt;

      // If a ring is bigger than the screen, we get ready to remove it
      if (ring.radius > size.x) {
        ringsToRemove.add(ring);
      }
    }

    // We remove all the rings that are too big
    for (final ring in ringsToRemove) {
      _rings.remove(ring);
      remove(ring);
    }
  }

  // This function creates a new ring and adds it to our game
  void _spawnRing() {
    // We make the ring have a slightly different shade of white/grey
    final color = Color.fromARGB(
      255,
      200 + _random.nextInt(56),
      200 + _random.nextInt(56),
      200 + _random.nextInt(56),
    );

    // We create the new ring with a random start angle for the gap.
    // `_random.nextDouble()` gives us a number between 0.0 and 1.0.
    // We multiply that by 2 * pi to get a full circle of possible angles.
    final startAngle = _random.nextDouble() * 2 * pi;

    final newRing = TubeRing(
      radius: 1,
      color: color,
      startAngle: startAngle,
      sweepAngle: pi * 1.8, // Almost a full circle
    );
    // We add the new ring to our list of rings
    _rings.add(newRing);
    // We add the new ring to the game so it gets drawn
    add(newRing);
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    // Make the tube component take up the whole screen
    size = gameSize;
  }
}
