
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

// This is our player, the character that runs.
class Player extends SpriteAnimationComponent with HasGameRef {
  // This is the angle where the player is on the circle.
  // We measure it in radians, which is a way to measure angles.
  // 0 is at the top, and it goes around clockwise.
  double currentAngle = 0;

  // This is how far the player is from the center of the screen.
  // We make it public so the game can check for collisions.
  double get radius => _playerRadius;
  // We'll calculate this later when we know the screen size.
  double _playerRadius = 0;

  // We are going to make a new player.
  Player()
      : super(
          // The player will be in the middle of the screen horizontally.
          anchor: Anchor.center,
        );

  // This is a special function that Flame calls when it's ready to add our player to the game.
  @override
  Future<void> onLoad() async {
    // This tells Flame to wait until we are done loading our stuff before it continues.
    await super.onLoad();

    // We are loading the running animation from the image file.
    // It has 8 frames (pictures), each is 78 pixels wide and 128 pixels tall.
    // We tell it to play at 10 frames per second (1 frame every 0.1 seconds) and to loop.
    final spriteSheet = SpriteSheet(
      image: await game.images.load('runner.png'),
      srcSize: Vector2(78.0, 128.0),
    );

    animation = spriteSheet.createAnimation(
      row: 0,
      stepTime: 0.1,
      to: 8,
    );
  }

  // This is a special function that Flame calls whenever the screen size changes.
  @override
  void onGameResize(Vector2 size) {
    // We make sure to call the original function first.
    super.onGameResize(size);

    // We set the player's size. We want him to be 100 pixels wide,
    // and we calculate the height to keep the picture from looking stretched.
    width = 100;
    height = width * (128.0 / 78.0);

    // We calculate how far the player should be from the center of the screen.
    // This will be 3/4 of the way to the edge of the screen.
    _playerRadius = size.x / 4 * 3;

    // We update the player's position based on the new screen size and angle.
    _updatePosition();
  }

  // This function moves the player to the left around the circle.
  void moveLeft() {
    currentAngle -= 0.1;
    _updatePosition();
  }

  // This function moves the player to the right around the circle.
  void moveRight() {
    currentAngle += 0.1;
    _updatePosition();
  }

  // This is a helper function to put the player in the right spot.
  void _updatePosition() {
    // We use some math (sine and cosine) to figure out the x and y position
    // on a circle. We use game.size / 2 to make the center of the circle
    // the center of the screen.
    position = Vector2(
      cos(currentAngle) * _playerRadius + game.size.x / 2,
      sin(currentAngle) * _playerRadius + game.size.y / 2,
    );

    // We also rotate the player sprite so it looks like it's running
    // on the inside of the tube.
    angle = currentAngle + pi / 2;
  }
}
