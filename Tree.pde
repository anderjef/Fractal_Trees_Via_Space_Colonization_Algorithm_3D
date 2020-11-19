class Tree {
  ArrayList<Leaf> leaves = new ArrayList<Leaf>();
  ArrayList<Branch> branches = new ArrayList<Branch>();

  Tree() {
    for (int i = 0; i < numLeaves; ++i) {
      leaves.add(new Leaf());
    }
    branches.add(new Branch(null, new PVector(0, height / 2), new PVector(0, -1))); //add a root branch in the bottom middle of the canvas
    Branch current = branches.get(0);
    boolean foundAttractiveLeaf = false;
    while (!foundAttractiveLeaf) {
      for (int i = 0; i < leaves.size(); ++i) {
        if (PVector.dist(current.position, leaves.get(i).position) < leafMaxAttractionDistance) {
          foundAttractiveLeaf = true;
        }
      }
      if (!foundAttractiveLeaf) {
        current = current.spawnChild();
        branches.add(current);
      }
    }
  }

  void grow() {
    for (int i = leaves.size() - 1; i >= 0; --i) {
      Leaf leaf = leaves.get(i);
      Branch closestBranch = branches.get(0);
      float minDistance = width + height; //initialized to an arbitrary distance that's greater than anything possible
      boolean leafIsReached = false;
      for (int j = 0; j < branches.size(); ++j) {
        Branch branch = branches.get(j);
        float distanceToBranch = PVector.dist(leaf.position, branch.position);
        if (distanceToBranch < leafMinAttractionDistance) {
          leafIsReached = true;
          closestBranch = null;
          break;
        } else if (distanceToBranch > leafMaxAttractionDistance) {
          continue;
        } else if (distanceToBranch < minDistance) {
          closestBranch = branch;
          minDistance = distanceToBranch;
        }
      }
      if (closestBranch != null) {
        PVector attractionVector = PVector.sub(leaf.position, closestBranch.position).normalize();
        closestBranch.direction.add(attractionVector);
        closestBranch.attractiveLeavesCount++;
      }
      if (leafIsReached) { //delete leaves that have attracted
        leaves.remove(i); //delete one element from the array at the provided index
      }
    }

    for (int i = branches.size() - 1; i >= 0; --i) {
      Branch branch = branches.get(i);
      if (branch.attractiveLeavesCount > 0) {
        PVector randomVector = PVector.random2D().setMag(0.3); //a random vector (with magnitude set to a value experimentally determined to be decent) used to eliminate leaves that would otherwise survive
        branch.direction.div(branch.attractiveLeavesCount + 1).add(randomVector).normalize(); //average the force from leaves
        branches.add(branch.spawnChild());
        branch.reset();
      }
    }
  }


  void show() {
    if (showLeaves) {
      stroke(255);
      strokeWeight(leafDiameter);
      for (int i = 0; i < leaves.size(); ++i) {
        leaves.get(i).show();
      }
    }
    for (int i = 0; i < branches.size(); ++i) {
      stroke(map(i, 0, branches.size(), 100, 1), 70, 30); //the further the branch from the root, the more green (less brown) it appears
      strokeWeight(map(i, 0, branches.size(), 12, 1)); //the further the branch from the root, the thinner it appears
      branches.get(i).show();
    }
  }
}
