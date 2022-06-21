public class Directions{
    //Variables for directions
    PVector[] list;
    boolean outOfDirections = false;
    //Constructor without PVectors supplied. Takes an int to let us know how many directions to generate.
    Directions(int n){
        list = new PVector[n];
        for (int i = 0; i < n; i++){
            list[i] = PVector.random2D();
        }
    }
    //COnstructor with PVectors supplied
    Directions(PVector[] l){
        list = l;
    }
    //Functions for directions listed alphabetically

    //called by population selection() and uses the Directions parameter to mix/match PVectors from this list and parameter's list
    Directions crossover(Directions partner){
        PVector[] newInstructions = new PVector[list.length];
        int mid = floor(random(list.length));
        for (int i = 0; i < list.length; i++){
            if (i > mid){
                newInstructions[i] = list[i];
            }else{
                newInstructions[i] = partner.list[i];
            }
        }
        return new Directions(newInstructions);
    }
    //Takes an int and returns the PVector at that index
    PVector getNextDirection(int i){
        if (i == list.length-1){
            outOfDirections = true;
        }
        return list[i];
    }
    //Called by the car to see if it can keep going.
    boolean isOutOfDirections(){
        return outOfDirections;
    }
    //Chance to make a random PVector so that we don't get stuck repeating the same thing forever
    void mutation(){
        for (int i = 0; i < list.length; i++){
            if (random(1) < 0.01){
                list[i] = PVector.random2D();
            }
        }
    }
}