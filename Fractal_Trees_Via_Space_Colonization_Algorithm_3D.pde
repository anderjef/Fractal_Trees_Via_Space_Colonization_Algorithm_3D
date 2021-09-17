//Jeffrey Andersen

//future consideration: improve starting area shape

import peasy.*;

int numLeaves = 1500; //experimentally determined to be decent
int leafDiameter = 10;
int leafMinAttractionDistance = 8; //experimentally determined to be decent
int leafMaxAttractionDistance = 90; //experimentally determined to be decent
float minBranchLength = 10; //experimentally determined to be decent (balancing performance and quality); enforced when child branch is spawned (for performance reasons)
int treeRadius = 275;
boolean showLeaves = true;
float branchDirectionRandomComponentWeightAddend = 0.3; //experimentally determined to be decent; how much to add to the random 3D vector's magnitude before adding that vector to the given branch's direction vector (which dictates the origin of the branch's next child branch)
float leavesCountMultiplierInRandomizedBranchPathComponent = 0.3; //how much to multiply the count of leaves attracting a given branch before exponentiating with respect to exponent leavesCountExponentInRandomizedBranchPathComponent whose result then gets added to the random 3D vector's magnitude before adding that vector to the given branch's direction vector (which dictates the origin of the branch's next child branch)
float leavesCountExponentInRandomizedBranchPathComponent = 1; //the exponent applied to the product of leavesCountMultiplierInRandomizedBranchPathComponent and the count of leaves attracting a given branch; the result of exponentiation gets added to the random 3D vector's magnitude before adding that vector to the given branch's direction vector (which dictates the origin of the branch's next child branch)
float coreBranchRedness = 100, fringeBranchRedness = 1; //branch redness values are linearly mapped to the range from coreBranchRedness to fringeBranchRedness
float coreBranchWidth = 12, fringeBranchWidth = 1; //branch widths are linearly mapped to the range from coreBranchWidth to fringeBranchWidth
int maxIterations = numLeaves; //how many iterations to grow before terminating all growth

Tree tree;
PeasyCam camera;
int iterationNum = 0;

void setup() {
  size(800, 1200, P3D);
  tree = new Tree(); //(because tree starts in the middle of the screen) have to wait for canvas dimensions to be specified before constructing
  camera = new PeasyCam(this, 800); //PeasyCam notably moves the origin to the center of the window
}

void draw() {
  background(0);
  tree.show();
  tree.grow();
  iterationNum++;
}
