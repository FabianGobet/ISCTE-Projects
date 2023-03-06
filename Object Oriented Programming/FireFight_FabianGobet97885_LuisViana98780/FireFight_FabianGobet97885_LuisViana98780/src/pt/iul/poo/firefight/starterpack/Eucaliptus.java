package pt.iul.poo.firefight.starterpack;


import pt.iul.ista.poo.utils.Point2D;

public class Eucaliptus extends BurnableTerrain{

	public Eucaliptus(Point2D ponto) {
		super(ponto,10);
	}

	@Override
	public String getName() {
		return (this.isBurned?"burnteucaliptus" : "eucaliptus");
	}


	@Override
	public boolean ignition() {
		return Math.random()<0.10; //10%
	}



}
