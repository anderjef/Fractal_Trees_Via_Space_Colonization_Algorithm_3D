// Jeffrey Andersen

//future considerations: guarantee all leaves are deleted once the tree is finished growing, improve starting area shape

import peasy.*;

int numLeaves = 1500; //experimentally determined to be decent
int leafDiameter = 10;
int leafMinAttractionDistance = 8; //experimentally determined to be decent
int leafMaxAttractionDistance = 90; //experimentally determined to be decent
int minBranchLength = 10; //experimentally determined to be decent (balancing performance and quality)
int treeRadius = 250;
boolean showLeaves = true;  

Tree tree;
PeasyCam camera;

void setup() {
  size(800, 1200, P3D);
  tree = new Tree();
  camera = new PeasyCam(this, 800); //PeasyCam notably moves the origin to the center of the window
}

void draw() {
  background(0);
  tree.show();
  tree.grow();
}
