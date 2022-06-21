//Sketch variables for the cars
Population population;
float carSize;
int numDirections, numCars;
//Sketch variables for the track
float innerRing, outerRing;

void setup(){
    size(600, 600);
    carSize = 20;
    numDirections = 200;
    numCars = 100;
    population = new Population(carSize, numCars, numDirections);
    innerRing = width/5;
    outerRing = width - width/20;
}

void draw(){
    //Draw the cars
    background(255);
    if (population.goodToGo()){
        population.drive(innerRing, outerRing);
    }else{
        population.evaluate();
        population.selection(carSize);
    }

    //Draw the rings for the track
    ellipseMode(CENTER);
    noFill();
    ellipse(width/2, height/2, innerRing, innerRing);
    ellipse(width/2, height/2, outerRing, outerRing);
}