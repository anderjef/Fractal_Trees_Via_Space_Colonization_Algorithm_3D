//Jeffrey Andersen

class Leaf {
  PVector pos; //position
  float biasFactor; //the multiplier for a closest (in-range) branch's attraction to this leaf; default is one meaning leaf's attraction is weighted the same as the branch's pre-attraction direction
  
  Leaf(PVector _pos) {
    pos = _pos; //note that input _pos PVector is not copied (because currently, this method is slightly more optimized)
    biasFactor = 1;
  }
  
  Leaf(PVector _pos, float _biasFactor) {
    pos = _pos; //note that input _pos PVector is not copied (because currently, this method is slightly more optimized)
    biasFactor = _biasFactor;
  }

  void show() {
    point(pos.x, pos.y, pos.z);
  }
}
