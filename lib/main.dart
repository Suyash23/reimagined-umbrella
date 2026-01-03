import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

import 'player.dart';
import 'tube.dart';

void main() {
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame {
  // This is the background color of our game.
  // We're making it a dark grey so we can see our white tube rings.
  @override
  Color backgroundColor() => const Color(0xFF222222);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // We add the tube first, so it's in the background
    add(Tube());
    // Then we add the player, so it's in the foreground
    add(Player());
  }
}
