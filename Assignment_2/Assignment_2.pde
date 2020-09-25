Boid barry;
ArrayList<Boid> boids;
ArrayList<Avoid> avoids;

float globalScale = .91;
float eraseRadius = 20;
String tool = "boids";

// boid control
float maxSpeed;
float friendRadius;
float crowdRadius;
float avoidRadius;
float coheseRadius;

boolean option_friend = true;
boolean option_crowd = true;
boolean option_avoid = true;
boolean option_noise = true;
boolean option_cohese = true;

// gui crap
int messageTimer = 0;
String messageText = "";

void setup () {
  size(1024, 576);
  textSize(16);
  recalculateConstants();
  boids = new ArrayList<Boid>();
  avoids = new ArrayList<Avoid>();
  for (int x = 100; x < width - 100; x+= 100) {
    for (int y = 100; y < height - 100; y+= 100) {
      // boids.add(new Boid(x + random(3), y + random(3)));
      //   boids.add(new Boid(x + random(3), y + random(3)));
    }
  }

  setupCircle();
}

// haha
void recalculateConstants () {
  maxSpeed = 2.1 * globalScale;
  friendRadius = 60 * globalScale;
  crowdRadius = (friendRadius / 1.3);
  avoidRadius = 90 * globalScale;
  coheseRadius = friendRadius;
}

void setupCircle() {
  avoids = new ArrayList<Avoid>();
  for (int x = 0; x < 50; x+= 1) {
    float dir = (x / 50.0) * TWO_PI;
    avoids.add(new Avoid(width * 0.5 + cos(dir) * height*.4, height * 0.5 + sin(dir)*height*.4));
  }
}


void draw () {
  noStroke();
  colorMode(HSB);
  fill(0, 100);
  rect(0, 0, width, height);

  for (int i = 0; i <boids.size(); i++) {
    Boid current = boids.get(i);
    barry = current;
    if (current.isDead) 
    {
      boids.remove(i);
    } 

    current.go();
    current.draw();
  }

  for (int i = 0; i <avoids.size(); i++) {
    Avoid current = avoids.get(i);
    current.go();
    current.draw();
  }

  if (messageTimer > 0) {
    messageTimer -= 1;
  }
  drawGUI();
}

void keyPressed () {
  recalculateConstants();
}

void drawGUI() {
  if (messageTimer > 0) {
    fill((min(30, messageTimer) / 30.0) * 255.0);

    text(messageText, 10, height - 20);
  }
}

String s(int count) {
  return (count != 1) ? "s" : "";
}

String on(boolean in) {
  return in ? "on" : "off";
}

void mousePressed () {
  // Adds boid on left, remove random on right
  switch (mouseButton) {
  case LEFT:
    boids.add(new Boid(mouseX, mouseY));
    message(boids.size() + " Total Boid" + s(boids.size()));
    break;
  case RIGHT:
    erase();
    break;
  }
}

// Sets a random boid to be deleted
void erase () {
  if (boids.size() > 0 ) {
    int index = int(random(boids.size()));
    if (boids.get(index).toBeRemoved == false)
      boids.get(index).toBeRemoved = true;
  }
}

void drawText (String s, float x, float y) {
  fill(0);
  text(s, x, y);
  fill(200);
  text(s, x-1, y-1);
}


void message (String in) {
  messageText = in;
  messageTimer = (int) frameRate * 3;
}
