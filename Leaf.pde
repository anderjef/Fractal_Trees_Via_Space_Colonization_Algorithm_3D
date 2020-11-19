class Leaf {
  PVector position = PVector.random3D().mult(random(treeRadius));
  boolean isAttracting = false;
  
  void show() {
    point(position.x, position.y, position.z);
  }
}
