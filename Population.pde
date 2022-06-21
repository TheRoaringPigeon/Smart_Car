public class Population{
    //variables for the population
    Car[] cars;
    ArrayList<Car> matingPool;
    boolean done = false;
    Population(float cs, int cn, int dn){
        cars = new Car[cn];
        for (int i = 0; i < cn; i++){
            cars[i] = new Car(cs, dn);
        }
        matingPool = new ArrayList<Car>();
    }
    //functions for population listed alphabetically

    //Draws the cars and moves them. Also checks if all cars are finished. Learns and tries again afterwards.
    void drive(float i, float o){
        boolean finished = true;
        for (Car c : cars){
            c.update(i, o);
            c.show();
            if (c.stillGoing()){
                finished = false;
            }
        }
        if (finished){
            done = true;
        }
    }
    //Called by main sketch. Normalized all cars based on their score and asigns them their score
    void evaluate(){
        float maxFit = 1;
        //Find the highest scoring car
        for (Car c : cars){
            c.calcFitness();
            if (c.getFitness() > maxFit){
                maxFit = c.getFitness();
            }
        }
        //normalize all car scores
        for (Car c : cars){
            c.normFitness(maxFit);
        }
        //reset matingPool and populate the pool based on cars score. Best score gets its name in the hat more times.
        matingPool.clear();
        for (int i = 0; i < cars.length; i++){
            int n = floor(cars[i].getFitness() * 100);
            for (int j = 0; j < n; j++){
                matingPool.add(cars[i]);
            }
        }
    }
    //CHeck if every car is still driving
    boolean goodToGo(){
        return !done;
    }
    //It's time for natural selection
    void selection(float cs){
        Car[] newCars = new Car[cars.length];
        for (int i = 0; i < cars.length; i++){
            Directions parentA = matingPool.get(floor(random(matingPool.size()))).getDirections();
            Directions parentB = matingPool.get(floor(random(matingPool.size()))).getDirections();
            Directions child = parentA.crossover(parentB);
            child.mutation();
            newCars[i] = new Car(cs, child);
        }
        cars = newCars;
        done = false;
    }
}