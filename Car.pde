public class Car{
    //Variables for the car
    PVector pos, vel, acc;
    boolean crashed, completed = false;
    float size, fitness;
    int step = 0;
    Directions directions;
    int total;
    int collected = 1;
    PVector[] checkpoints;
    
    //Constructor without directions
    Car(float s, int i){
        size = s;
        pos = new PVector(width/2, height - height/3);
        vel = new PVector();
        acc = new PVector();
        directions = new Directions(i);
        fitness = 1;
        setupCheckpoints();
    }
    //Constructor with directions supplied
    Car(float s, Directions d){
        size = s;
        pos = new PVector(width/2, height - height/3);
        vel = new PVector();
        acc = new PVector();
        directions = d;
        fitness = 1;
        setupCheckpoints();
    }
    //Functions for the car are listed alphabetically


    //Called by update() of this object. Takes a PVector input and applies it to acc.
    void applyForce(PVector force){
        acc.add(force);
    }
    //Called by population and makes a score for the car. Will be used for natural selection
    void calcFitness(){
        if (collected == total){
            fitness = 10000000;
            return;
        }
        PVector goal = new PVector(width/2, height - height/3);
        float d = dist(pos.x, pos.y, goal.x, goal.y);
        fitness = map(d, 1, width, width, 1);
        fitness *= collected;
        if (crashed){
            fitness /= 10;
        }
    }
    //Recieve int as parameter and use it to remake the checkpoints array;
    void collectCP(int i){
        collected++;
        if (checkpoints.length == 1){
            completed = true;
            return;
        }
        PVector[] newCPs = new PVector[checkpoints.length-1];
        for (int x = 0; x < newCPs.length; x++){
            if (x == i){
                newCPs[x] = checkpoints[checkpoints.length-1];
            }else{
                newCPs[x] = checkpoints[x];
            }
        }
        checkpoints = newCPs;
    }
    //Called by population selection() and returns directions
    Directions getDirections(){
        return directions;
    }
    //Returns fitness
    float getFitness(){
        return fitness;
    }
    //Parameter supplied by Population in evaluate() and used to normalize fitness based on the best scoring car
    void normFitness(float m){
        fitness /= m;
    }
    //Setup the checkpoints that will be used for scoring
    void setupCheckpoints(){
        total = 8;
        checkpoints = new PVector[7];
        checkpoints[0] = new PVector(width/3, height/2);
        checkpoints[1] = new PVector(width/2, height/3);
        checkpoints[2] = new PVector(width - width/3, height/2);
        checkpoints[3] = new PVector(width/3, height-height/3);
        checkpoints[4] = new PVector(width/3, height/3);
        checkpoints[5] = new PVector(width-width/3, height/3);
        checkpoints[6] = new PVector(width-width/3, height - height/3);
    }
    //Called by population and moves the car
    void update(float i, float o){
        //Only move if the car isn't crashed or completed with its directions
        if (completed || crashed){
            return;
        }
        //Use parameters to check if car has crashed.
        //If car's pos is closer to the center of the course than the inner ring or farther than the outer ring, we've crashed.
        if (dist(width/2, height/2, pos.x, pos.y) < i/2 || dist(width/2, height/2, pos.x, pos.y) > o/2){
            crashed = true;
            return;
        }
        //Check to see if we are out of directions
        if (directions.isOutOfDirections()){
            completed = true;
            return;
        }
        //See if we've collected a checkpoint
        for (int c = checkpoints.length-1; c >= 0; c--){
            if (dist(pos.x, pos.y, checkpoints[c].x, checkpoints[c].y) < size *3){
                collectCP(c);
                break;
            }
        }
        applyForce(directions.getNextDirection(step));
        vel.add(acc);
        pos.add(vel);
        acc.mult(0);
        step++;
    }
    //Called by population and draws the car
    void show(){
        push();
        translate(pos.x, pos.y);
        rotate(vel.heading() - radians(90));
        fill(150);
        triangle(0, size * 2.5, -size/2, size, size/2, size);
        pop();
    }
    //Called by population and returns true if car is NOT crashed or completed
    boolean stillGoing(){
        return !completed && !crashed;
    }
}