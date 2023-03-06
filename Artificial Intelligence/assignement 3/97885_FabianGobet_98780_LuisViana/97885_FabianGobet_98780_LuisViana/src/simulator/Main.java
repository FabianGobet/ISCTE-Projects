package simulator;


public class Main {

	
	public static void main(String[] args) {
		
		MyTree tree = new MyTree("mushroom.arff");
		MyActions actions = new MyActions("decision.fcl");
		Simulator sim = new Simulator();	
		sim.setSimulationSpeed(5); 
			
		while(true) {
			sim.step();
			String[] attri = sim.getMushroomAttributes();
			double[] res = actions.evaluate(sim.getDistanceL(), sim.getDistanceC(), sim.getDistanceR(), (attri != null ? tree.evaluate(attri) : 0.5));
			sim.setRobotAngle(res[0]);
			sim.setAction(Action.values()[(int) Math.round(res[1])]);
		}
	}

}
