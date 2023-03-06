package pt.iul.poo.firefight.starterpack;


import pt.iul.ista.poo.utils.Point2D;

public class Pine extends BurnableTerrain{


	public Pine(Point2D ponto) {
		super(ponto, 15);
	}

	@Override
	public String getName() {
		return (this.isBurned?"burntpine" : "pine");
	}


	@Override
	public boolean ignition() {
		return Math.random()<0.05; //5%
	}



}
