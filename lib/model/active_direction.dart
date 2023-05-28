enum Direction { up, down, right, left }

class ActiveDirection {
  Direction direction = Direction.right;
  Direction lastDirection = Direction.right;
  Map<String, int> getDelta() {
    switch (direction) {
      case Direction.down:
        return {
          'dx': 0,
          'dy': 1,
        };
      case Direction.up:
        return {
          'dx': 0,
          'dy': -1,
        };
      case Direction.right:
        return {
          'dx': 1,
          'dy': 0,
        };
      case Direction.left:
        return {
          'dx': -1,
          'dy': 0,
        };
    }
  }
}
