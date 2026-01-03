
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

// This is our player, the character that runs.
class Player extends SpriteAnimationComponent with HasGameRef {
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

    // We put the player at the bottom-center of the screen.
    // The 'x' is the horizontal position, and 'y' is the vertical position.
    // 'size.x / 2' is the middle of the screen horizontally.
    // 'size.y * 0.8' is 80% of the way down the screen, which is near the bottom.
    position = Vector2(size.x / 2, size.y * 0.8);
  }
}
