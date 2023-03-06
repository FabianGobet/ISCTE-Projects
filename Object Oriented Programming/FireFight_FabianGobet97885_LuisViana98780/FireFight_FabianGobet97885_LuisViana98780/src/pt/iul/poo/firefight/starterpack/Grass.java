package pt.iul.poo.firefight.starterpack;

import pt.iul.ista.poo.utils.Point2D;

public class Grass extends BurnableTerrain{

	public Grass(Point2D ponto) {
		super(ponto,7);
	}

	@Override
	public String getName() {
		return (this.isBurned?"burntgrass" : "grass");
	}


	@Override
	public boolean ignition() {
		return Math.random()<0.15;
	}



}
