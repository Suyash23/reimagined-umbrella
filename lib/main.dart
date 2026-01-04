import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

import 'tube.dart';

void main() {
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame {
  // This is the background color of our game.
  // We're making it black, like the inside of a dark tube.
  @override
  Color backgroundColor() => const Color(0xFF000000);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // We add the tube, which will be our main visual component.
    add(Tube());
  }
}
