package pt.iul.poo.firefight.starterpack;

import pt.iul.ista.poo.utils.Direction;
import pt.iul.ista.poo.utils.Point2D;

public class Water extends GameElement implements Updatable{
	
	
	
	private Direction direcao;
	private boolean done=false;
	
	public Water(Point2D ponto, Direction direcao) {
		super(ponto);
		this.direcao=direcao;
		Fire fogo = Fire.getThat(ponto);
		if(fogo!=null)
			fogo.interact();
		BurnableTerrain bt = BurnableTerrain.getThat(ponto);
		if(bt!=null) {
			bt.isOnFire=false;
			bt.resetCount();
		}
	}
	
	
	
	@Override
	public String getName() {
		String result="water";
		if(direcao!=null)
			result=result+"_"+direcao.name().toLowerCase();
		return result;
	}

	@Override
	public int getLayer() {
		return 3;
	}



	@Override
	public void update() {
		if(done)
			ge.removeTile(this);
		else
			done=true;
	}
	
	public static boolean isWet(Point2D target) {
		Water water = GameEngine.getInstance().getObject(o->(o instanceof Water) && o.getPosition().equals(target)); 
		return water!=null;
	}



}
