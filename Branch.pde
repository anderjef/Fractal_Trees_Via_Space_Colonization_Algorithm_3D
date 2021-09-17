//Jeffrey Andersen

class Branch {
  Branch parent;
  PVector pos; //position
  PVector direction;
  PVector originalDirection;
  int numAttractingLeaves = 0;

  Branch(Branch _parent, PVector _pos, PVector _direction) {
    parent = _parent;
    pos = _pos; //note that input _pos PVector is not copied (because currently, this method occupies fewer lines of code)
    direction = _direction; //note that input _direction PVector is not copied (because currently, this method is slightly more optimized)
    originalDirection = direction.copy();
  }

  Branch spawnChild() {
    return new Branch(this, direction.copy().mult(minBranchLength).add(pos), direction.copy());
  }

  void reset() {
    direction = originalDirection.copy();
    numAttractingLeaves = 0;
  }

  void show() {
    if (parent != null) {
      line(pos.x, pos.y, pos.z, parent.pos.x, parent.pos.y, parent.pos.z);
    }
  }
}
