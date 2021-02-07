// Jeffrey Andersen

class Branch {
  Branch parent;
  PVector position;
  PVector direction;
  PVector originalDirection;
  int attractiveLeavesCount = 0;
  
  Branch(Branch _parent, PVector _position, PVector _direction) {
    parent = _parent;
    position = _position;
    direction = _direction;
    originalDirection = direction.copy();
  }

  Branch spawnChild() {
    PVector nextPosition = PVector.mult(this.direction, minBranchLength);
    return new Branch(this, PVector.add(this.position, nextPosition), this.direction.copy());
  }

  void reset() {
    this.direction = this.originalDirection.copy();
    this.attractiveLeavesCount = 0;
  }

  void show() {
    if (this.parent != null) {
      line(this.position.x, this.position.y, this.position.z, this.parent.position.x, this.parent.position.y, this.parent.position.z);
    }
  }
}
