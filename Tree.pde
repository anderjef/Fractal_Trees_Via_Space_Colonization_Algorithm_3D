//Jeffrey Andersen


class Tree {
  ArrayList<Leaf> leaves = new ArrayList<Leaf>();
  ArrayList<Branch> branches = new ArrayList<Branch>();
  boolean stillGrowing;


  Tree() {
    for (int i = 0; i < numLeaves; i++) {
      leaves.add(new Leaf(PVector.random3D().mult(random(treeRadius))));
    }
    branches.add(new Branch(null, new PVector(0, height / 2), new PVector(0, -1))); //set tree starting position (doesn't actually get displayed as branch has no parent) and initial direction (currently toward leaves group)

    Branch currentBranch = branches.get(0);
    boolean foundAttractiveLeaf = false;
    while (!foundAttractiveLeaf) { //grow trunk of tree until leaves area is encountered
      for (Leaf l : leaves) {
        if (currentBranch.pos.dist(l.pos) < leafMaxAttractionDistance) {
          foundAttractiveLeaf = true;
          break;
        }
      }
      if (!foundAttractiveLeaf) {
        currentBranch = currentBranch.spawnChild();
        branches.add(currentBranch);
      }
    }
    stillGrowing = true;
  }


  void grow() {
    if (!stillGrowing) {
      return;
    }
    
    for (int i = leaves.size() - 1; i >= 0; i--) { //remove expended leaves and update branch direction vectors
      Leaf leaf = leaves.get(i);
      Branch closestBranch = null;
      float minDistance = Float.MAX_VALUE; //initialized to an arbitrary value that's greater than the furthest permitted distance
      boolean leafIsReached = false;
      for (Branch b : branches) {
        float distanceToBranch = leaf.pos.dist(b.pos);
        if (distanceToBranch < leafMinAttractionDistance) {
          leafIsReached = true;
          closestBranch = null;
          break;
        } else if (distanceToBranch <= leafMaxAttractionDistance && distanceToBranch < minDistance) {
          minDistance = distanceToBranch;
          closestBranch = b;
        }
      }
      if (closestBranch != null) {
        closestBranch.direction.add(PVector.sub(leaf.pos, closestBranch.pos)).mult(leaf.biasFactor); //adjust closest branch's direction to tend toward this leaf according to the leaf's bias factor
        closestBranch.numAttractingLeaves++;
      }
      if (leafIsReached) { //delete leaves that have been reached
        leaves.remove(i);
      }
    }

    for (int i = branches.size() - 1; i >= 0; i--) { //grow/split/spawn branches
      Branch branch = branches.get(i);
      if (branch.numAttractingLeaves > 0) {
        PVector randomVector = PVector.random3D().mult(branchDirectionRandomComponentWeightAddend + pow(leavesCountMultiplierInRandomizedBranchPathComponent * branch.numAttractingLeaves, leavesCountExponentInRandomizedBranchPathComponent)); //a random vector used to help eliminate/reach leaves that might not be otherwise by helping to tighten turning radiuses and minimize repeat child branches; the weight of the random vector (the magnitude via mult()) can be set to a constant and/or to depend on any single power of the number of attracting leaves (the only variable deemed potentially worth changing with)
        branch.direction.normalize().add(randomVector).normalize(); //average the force from the leaves attracting this branch with the branch's prior direction
        branches.add(branch.spawnChild());
        branch.reset();
      }
    }

    if (leaves.size() == 0) {
      stillGrowing = false;
    } else if (iterationNum >= maxIterations) { //future consideration: instead of relying on a set number of iterations, stop growth if no closest branch's direction could possibly take it into the attraction sphere around any (remaining) leaf
      stillGrowing = false;
      leaves.clear();
    }
  }


  void show() {
    if (showLeaves) {
      stroke(255);
      strokeWeight(leafDiameter);
      for (Leaf l : leaves) {
        l.show();
      }
    }
    for (int i = 0; i < branches.size(); i++) {
      stroke(map(i, 0, branches.size() - 1, coreBranchRedness, fringeBranchRedness), 70, 30); //the further the branch from the trunk, the more green (less brown) it appears //future consideration: allow branch color customization beyond just the red value
      strokeWeight(map(i, 0, branches.size() - 1, coreBranchWidth, fringeBranchWidth)); //the further the branch from the trunk, the thinner it appears
      branches.get(i).show();
    }
  }
}
