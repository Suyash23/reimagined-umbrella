import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

import 'player.dart';
import 'tube.dart';

void main() {
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // We add the tube first, so it's in the background
    add(Tube());
    // Then we add the player, so it's in the foreground
    add(Player());
  }
}
