/*  Ira Winder, jiw@mit.edu
 *
 *  An environment for testing natural selection processing on some digital "bugs"
 */

/*  Key Parameters:
 *  
 *    W, width of canvas [pixels]
 *    H, height of canvas [pixels]
 *
 *    D_f, diameter of food [pixels]
 *    P_f, period of food generation [ticks]
 *
 *    D_b, diameter of bug [pixels]
 *    V_b, maximum velocity of a "bug" [pixels/frame]
 *    S_b, number of bugs "spawned" when food eaten [bugs]
 *    H_b, number of ticks a bug can go without food before death [ticks]
 *
 *  Key Behaviors
 *
 *    - Bug acceleration is "random" in 2D space but velocity never exceeds V_b
 *    - Upon encountering food, a bug will eat it.  The polygon representing the bug and the food must intersect.
 *    - If a bug goes length of time H_b without eating food it will disappear from simulation
 *    - Upon eating food, the bug will become completely "full,"  and will instantly generate offspring of amount S_b
 *    - Every amount of time P_f, a unit of food is placed randomly on the canvas
 *
 */

ArrayList<Bug> population;
ArrayList<Food> noms;
Arena arena;

int FOOD_TIMER = 20;
int SPAWN_COUNT = 5;
int counter;

boolean run;

void setup() {
  size(1280, 764);
  arena = new Arena(600, 600);
  population = new ArrayList<Bug>();
  noms = new ArrayList<Food>();
  
  PVector randomLocation;
  float randomX, randomY;
  
  // Random Bugs
  Bug randomBug;
  for (int i=0; i<10; i++) {
    randomX = random(0, arena.w);
    randomY = random(0, arena.h);
    randomLocation = new PVector(randomX, randomY);
    randomBug = new Bug(30, 1, randomLocation, 500, SPAWN_COUNT);
    population.add(randomBug);
  }
  
  // Random Food
  Food randomFood;
  for (int i=0; i<10; i++) {
    randomX = random(0, arena.w);
    randomY = random(0, arena.h);
    randomLocation = new PVector(randomX, randomY);
    randomFood = new Food(randomLocation);
    noms.add(randomFood);
  }
  
  counter = 0;
  run = false;
}

Food nom, newFood;
Bug bug, newBug;

void draw() {
  background(0);
  
  translate(width/2 - arena.w/2, height/2 - arena.h/2);
  arena.draw();
  
  if (run) {
  
    // Random Food
    if (counter >= FOOD_TIMER) {
      PVector randomLocation;
      float randomX, randomY;
      randomX = random(0, arena.w);
      randomY = random(0, arena.h);
      randomLocation = new PVector(randomX, randomY);
      newFood = new Food(randomLocation);
      noms.add(newFood);
      
      counter = 0;
    }
    
    // Update Food
    for (int b=population.size()-1; b>=0; b--) {
      bug = population.get(b);
      for (int f=noms.size()-1; f>=0; f--) {
        nom = noms.get(f);
        if (nom.eat(bug.location)) {
          bug.full();
          noms.remove(f);
        }
      }
      
      // Random Bugs
      PVector newLocation;
      if (bug.spawn) {
        for (int j=0; j<bug.spawnSize; j++) {
          newLocation = new PVector(bug.location.x, bug.location.y);
          newBug = new Bug(30, 1, newLocation, 500, SPAWN_COUNT);
          population.add(newBug);
        }
        bug.spawn = false;
      }
    }
    
    // Update Bugs
    for (int i=population.size()-1; i>=0; i--) {
      bug = population.get(i);
      if (bug.starved) {
        population.remove(i);
      }
      bug.update(arena);
    }
    
    counter++;
  }
  
  // Draw Food
  for (Food f : noms) {
    f.draw();
  }
  
  // Draw Bugs
  for (Bug b : population) {
    b.draw();
  }
  
  println(population.size());
}

class Arena {
  int w, h;
  
  Arena(int w, int h) {
   this.w = w;
   this.h = h; 
  }
  
  void draw() {
    fill(50); noStroke();
    rect(0, 0, w, h);
  }
}

class Bug {
  float sightRange, maxSpeed;
  PVector location, velocity, acceleration;
  int hunger, maxHunger, spawnSize;
  boolean starved, spawn;
  
  Bug(float sightRange, float maxSpeed, PVector location, int maxHunger, int spawnSize) {
    this.sightRange = sightRange;
    this.maxSpeed = maxSpeed;
    this.location = location;
    this.maxHunger = maxHunger;
    this.spawnSize = spawnSize;
    
    velocity = new PVector(0,0,0);
    acceleration = new PVector(0,0,0);
    
    hunger = 0;
    starved = false;
    spawn = false;
  }
  
  void update(Arena a) {
    acceleration.x += random(-1.0, 1.0);
    acceleration.y += random(-1.0, 1.0);
    velocity.add(acceleration);
    
    if (velocity.mag() > maxSpeed) {
      velocity.setMag(maxSpeed);
    }
    
    location.add(velocity);
    
    if (location.x < 0) {
      location.x = arena.w + location.x;
    } else if (location.x > a.w) {
      location.x = location.x - arena.w;
    }
    
    if (location.y < 0) {
      location.y = arena.h + location.y;
    } else if (location.y > a.h) {
      location.y = location.y - arena.h;
    }
    
    hunger++;
    if (hunger >= maxHunger) {
      starved = true;
    }
    
  }
  
  void full() {
    hunger = 0;
    spawn = true;
  }
  
  void draw() {
    if (starved) {
      noFill();
    } else {
      fill(255, 255.0 * (maxHunger - hunger) / maxHunger);
    }
    ellipse(location.x, location.y, 5*(maxHunger - hunger) / maxHunger, 5*(maxHunger - hunger) / maxHunger);
  }
}

class Food {
  PVector location;
  
  int FOOD_SIZE = 15;
  
  Food(PVector location) {
    this.location = location;
  }
  
  boolean eat(PVector bugLocation) {
    PVector distance = new PVector(bugLocation.x, bugLocation.y);
    distance.sub(location);
    if (distance.mag() < FOOD_SIZE/2) {
      return true;
    } else {
      return false;
    }
  }
  
  void draw() {
    fill(#00FF00, 100);
    ellipse(location.x, location.y, FOOD_SIZE, FOOD_SIZE);
  }
}

void keyPressed() {
  switch(key) {
    case ' ':
      if (run) {
        run = false;
      } else {
        run = true;
      }
      break;
  }
}
