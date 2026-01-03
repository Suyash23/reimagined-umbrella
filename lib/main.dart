import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'player.dart';
import 'tube.dart';

void main() {
  runApp(GameWidget(game: MyGame()));
}

// We add the `HasKeyboardHandlerComponents` mixin to our game
// so it can listen for keyboard events.
class MyGame extends FlameGame with HasKeyboardHandlerComponents {
  // We need to keep a reference to our player and tube so we can interact with them.
  late final Player _player;
  late final Tube _tube;

  // This is the background color of our game.
  // We're making it a dark grey so we can see our white tube rings.
  @override
  Color backgroundColor() => const Color(0xFF222222);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // We add the tube first, so it's in the background
    add(_tube = Tube());
    // Then we create and add the player
    add(_player = Player());

    // We add a keyboard listener to the game.
    // This will listen for when we press the left and right arrow keys.
    add(
      KeyboardListenerComponent(
        keyUp: {
          LogicalKeyboardKey.arrowLeft: (keys) {
            _player.moveLeft();
            return true;
          },
          LogicalKeyboardKey.arrowRight: (keys) {
            _player.moveRight();
            return true;
          },
        },
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    // We check every ring in the tube
    for (final ring in _tube.rings) {
      // We check if the ring is at the same depth as the player.
      // We also check if the game isn't already paused.
      if (!paused && (ring.radius - _player.radius).abs() < 5.0) {
        // We normalize all angles to be between 0 and 2*pi.
        final playerAngle = (_player.currentAngle % (2 * pi) + 2 * pi) % (2 * pi);

        // The solid part of the ring starts at startAngle and goes for sweepAngle.
        // The gap starts where the solid part ends.
        final gapStart = ((ring.startAngle + ring.sweepAngle) % (2 * pi) + 2 * pi) % (2 * pi);
        // The gap ends where the solid part begins again.
        final gapEnd = (ring.startAngle % (2 * pi) + 2 * pi) % (2 * pi);

        // We check if the player's angle is inside the gap of the ring.
        // This is tricky because the gap can wrap around the 0 degree mark.
        if (gapStart < gapEnd) {
          // This is the easy case, where the gap doesn't wrap around.
          // e.g., gap is from 10 degrees to 40 degrees.
          if (playerAngle > gapStart && playerAngle < gapEnd) {
            paused = true; // Player is in the gap.
          }
        } else {
          // This is the hard case, where the gap does wrap around.
          // e.g., gap is from 350 degrees to 20 degrees.
          // We need to check if the player is in the first part of the gap
          // (e.g., > 350) OR in the second part of the gap (e.g., < 20).
          if (playerAngle > gapStart || playerAngle < gapEnd) {
            paused = true; // Player is in the gap.
          }
        }
      }
    }
  }
}
