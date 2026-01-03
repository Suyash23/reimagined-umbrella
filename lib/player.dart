import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Player extends PositionComponent {
  static const double playerSize = 50.0;

  Player() {
    size = Vector2.all(playerSize);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // This is the color of our player, a nice blue.
    // We are drawing a rectangle on the screen.
    final paint = Paint()..color = Colors.blue;
    canvas.drawRect(size.toRect(), paint);
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    // This keeps the player in the bottom-center of the screen.
    x = (gameSize.x - size.x) / 2;
    y = gameSize.y - size.y - 20; // 20 pixels from the bottom
  }
}
