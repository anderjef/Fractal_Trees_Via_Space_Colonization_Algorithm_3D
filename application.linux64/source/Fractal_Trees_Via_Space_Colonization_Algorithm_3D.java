import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import peasy.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Fractal_Trees_Via_Space_Colonization_Algorithm_3D extends PApplet {

//started 11/03/2020
//inspiration: https://www.youtube.com/watch?v=kKT0v3qhIQY, https://www.youtube.com/watch?v=JcopTKXt8L8

//future considerations: guarantee all leaves are deleted once the tree is finished growing, improve starting area



int numLeaves = 1500; //experimentally determined to be decent
int leafDiameter = 10;
int leafMinAttractionDistance = 8; //experimentally determined to be decent
int leafMaxAttractionDistance = 90; //experimentally determined to be decent
int minBranchLength = 10; //experimentally determined to be decent (balancing performance and quality)
int treeRadius = 250;
boolean showLeaves = true;  

Tree tree;
PeasyCam camera;

public void setup() {
  
  tree = new Tree();
  camera = new PeasyCam(this, 800); //PeasyCam notably moves the origin to the center of the window
}

public void draw() {
  background(0);
  tree.show();
  tree.grow();
}
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

  public Branch spawnChild() {
    PVector nextPosition = PVector.mult(this.direction, minBranchLength);
    return new Branch(this, PVector.add(this.position, nextPosition), this.direction.copy());
  }

  public void reset() {
    this.direction = this.originalDirection.copy();
    this.attractiveLeavesCount = 0;
  }

  public void show() {
    if (this.parent != null) {
      line(this.position.x, this.position.y, this.position.z, this.parent.position.x, this.parent.position.y, this.parent.position.z);
    }
  }
}
class Leaf {
  PVector position = PVector.random3D().mult(random(treeRadius));
  boolean isAttracting = false;
  
  public void show() {
    point(position.x, position.y, position.z);
  }
}
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

  public void grow() {
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
        PVector randomVector = PVector.random2D().setMag(0.3f); //a random vector (with magnitude set to a value experimentally determined to be decent) used to eliminate leaves that would otherwise survive
        branch.direction.div(branch.attractiveLeavesCount + 1).add(randomVector).normalize(); //average the force from leaves
        branches.add(branch.spawnChild());
        branch.reset();
      }
    }
  }


  public void show() {
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
  public void settings() {  size(800, 1200, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Fractal_Trees_Via_Space_Colonization_Algorithm_3D" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
