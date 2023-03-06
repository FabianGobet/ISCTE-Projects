package pt.iul.poo.firefight.starterpack;

import java.util.List;

import pt.iul.ista.poo.utils.Point2D;

public class FuelBarrel extends BurnableTerrain{
	
	public FuelBarrel(Point2D ponto) {
		super(ponto,3);
	}

	@Override
	public String getName() {
		return (this.isBurned? "explosion" : "fuelbarrel");
	}


	@Override
	public boolean ignition() {
		return Math.random()<0.90; //90%
	}
	
	
	public static FuelBarrel getThat(Point2D target) {
		FuelBarrel element = GameEngine.getInstance().getObject(o->(o instanceof FuelBarrel) && o.getPosition().equals(target));
		return element;
	}

	
	@Override
	public void burnt() {
		if(isBurned) {
			ge.removeTile(this);
		}
		if(count == limit && isOnFire) {
			fireFromBarrel();
			isBurned = true;
			ge.removeTile(Fire.getThat(this.position));
			ge.addTile(new Land(this.position));
			isOnFire=false;
			ge.score.addPoints(-10);
		}
	}

	private void fireFromBarrel() {
		List<Point2D> lista = this.position.getWideNeighbourhoodPoints();
		for(Point2D p : lista) {
			if(Fire.validPointSpreadNoChance(p))
				ge.addTile(new Fire(p));
		}
	}

}
