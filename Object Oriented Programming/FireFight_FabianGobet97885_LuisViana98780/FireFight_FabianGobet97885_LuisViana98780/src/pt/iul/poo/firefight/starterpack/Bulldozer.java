package pt.iul.poo.firefight.starterpack;


import pt.iul.ista.poo.utils.Direction;
import pt.iul.ista.poo.utils.Point2D;

public class Bulldozer extends Driveable{

	public Bulldozer(Point2D ponto) {
		super(ponto);
	}

	@Override
	public String getName() {
		String result="bulldozer";
		if(direcao!=null)
			result=result+"_"+direcao.name().toLowerCase();
		return result;
	}

	@Override
	public void behaviour(Point2D target) {
		if(!botGotOut()){
			if(Fire.getThat(target)==null && FuelBarrel.getThat(target)==null) {
				BurnableTerrain bt = BurnableTerrain.getThat(target);
				if(bt!=null) {
					ge.removeTile(bt);
					ge.addTile(new Land(target));
				}
				moveAndKill(target);
			}
		}
	}

	@Override
	public void setDirection(int key) {
		this.direcao=Direction.directionFor(key);
	}
	
	

}
