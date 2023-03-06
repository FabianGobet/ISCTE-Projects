package pt.iul.poo.firefight.starterpack;

import pt.iul.ista.poo.utils.Point2D;

public class Abies extends BurnableTerrain{
	
	public Abies(Point2D ponto) {
		super(ponto,20);
	}

	@Override
	public String getName() {
		return (this.isBurned?"burntabies" : "abies");
	}


	@Override
	public boolean ignition() {
		return Math.random()<0.05; //5%
	}



}
