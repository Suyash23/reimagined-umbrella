import 'dart:ui';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

// This is the main component for our tube.
// It will draw a static, 3D-looking tube on the screen.
class Tube extends PositionComponent {
  // This is the brush we will use to paint our tube.
  // We'll make it a nice cement-grey color.
  final Paint tubePaint = Paint()..color = const Color(0xFF888888);

  // This is a special function that Flame calls to draw things on the screen.
  // We will tell it how to draw our tube here.
  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // We find the center of the screen to draw our tube there.
    final center = size / 2;

    // This is the size of the tube's opening right in front of you.
    final startRadius = size.x / 2.5;
    // This is the size of the tube's opening at the very end.
    final endRadius = startRadius / 5.0;

    // This is how many rings we'll draw to make the tube look solid.
    // More rings make it look smoother, like a real tube.
    const numSegments = 100;

    // This is the angle you are looking down into the tube.
    // We need to turn 17 degrees into a number computers understand (radians).
    final angle = 17 * (pi / 180);

    // We'll draw the tube from the back to the front.
    // This is like stacking smaller pieces of paper behind bigger ones.
    for (int i = numSegments; i >= 0; i--) {
      // 't' is a number from 0 (the far end) to 1 (the near end).
      final t = i / numSegments;

      // We figure out how big this piece of the tube is.
      // We use 'pow(t, 2)' to make the tube seem to get smaller faster
      // as it goes into the distance, which looks more realistic.
      final radius = endRadius + (startRadius - endRadius) * pow(t, 2);

      // We figure out where to draw this piece of the tube.
      // The 'y' position is moved up to create the 17-degree angle effect.
      // This lets you see the bottom of the tube's inside.
      final yOffset = (size.y / 2) * tan(angle) * (1 - t);
      final tubeCenter = Offset(center.x, center.y - yOffset);

      // A tube opening looks like a stretched circle (an ellipse) when you look at it from an angle.
      // We'll make it a bit wider than it is tall.
      final rect = Rect.fromCenter(
        center: tubeCenter,
        width: radius * 2,
        height: radius * 1.8, // This makes it an ellipse
      );

      // We finally draw the ellipse on the screen!
      canvas.drawOval(rect, tubePaint);
    }
  }

  // This function is called when the screen size changes.
  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    // We make our tube component take up the whole screen.
    size = gameSize;
  }
}
