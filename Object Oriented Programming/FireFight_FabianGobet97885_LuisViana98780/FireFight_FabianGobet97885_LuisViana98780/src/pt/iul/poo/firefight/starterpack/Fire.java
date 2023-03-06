package pt.iul.poo.firefight.starterpack;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import pt.iul.ista.poo.gui.ImageTile;
import pt.iul.ista.poo.utils.Point2D;

public class Fire extends GameElement implements Interactable{

	public Fire(Point2D ponto) {
		super(ponto);
	}

	@Override
	public String getName() {
		return "fire";
	}

	@Override
	public int getLayer() {
		return 2;
	}

	public int distanceTo(Point2D target) {
		return Math.abs(target.getX()-this.position.getX()) + Math.abs(target.getY()-this.position.getY());
	}
	
	
	public static Fire getThat(Point2D target) {
		Fire f = null;
		f=GameEngine.getInstance().getObject(o-> (o instanceof Fire) && o.getPosition().equals(target));
		return f;
	}

	@Override
	public void interact() {
		ge.removeTile(this);
	}
	
	public static int maxFireColumn() {
		List<Fire> lista = GameEngine.getInstance().getAllObjects(o-> o instanceof Fire);
		lista.sort((a,b) -> a.getPosition().getX()-b.getPosition().getX());
		int maxCol=0; 
		int count=0; 
		int col = 0; 
		int maxVal = 0;
		for(ImageTile f : lista) {
			if(f.getPosition().getX()==col)
				count++;
			else {
				if(count>maxVal) {
					maxVal=count;
					maxCol=col;
				}
				count=1;
				col=f.getPosition().getX();
			}
		}
		if(count>maxVal) {
			maxVal=count;
			maxCol=col;
		}
		return maxCol;
	}

	
	public static void spreadFire() {
		Set<Point2D> pontos = new HashSet<>();
		List<Fire> fogos = GameEngine.getInstance().getAllObjects(o-> o instanceof Fire);
		for(Fire f : fogos) {
			for(Point2D p : f.getPosition().getNeighbourhoodPoints()) 
				if(Fire.validPointSpread(p))
					pontos.add(p);
		}
		for(Point2D p : pontos)
			GameEngine.getInstance().addTile(new Fire(p));
	}
	
	private static boolean validPointSpread(Point2D p) {
		BurnableTerrain bt = BurnableTerrain.getThat(p);
		return validPointSpreadNoChance(p) && bt.ignition();
	}

	public static boolean validPointSpreadNoChance(Point2D p) {
		BurnableTerrain bt = BurnableTerrain.getThat(p);
		return GameEngine.getInstance().gui.isWithinBounds(p) && Fire.getThat(p)==null && Fireman.firemanOnPosition(p)==null && !Water.isWet(p) && Driveable.getThat(p)==null && bt!=null && !bt.isBurned;
				
	}
	
		
	public static boolean AreThereFires() {
		List<Fire> lista = GameEngine.getInstance().getAllObjects(o-> o instanceof Fire);
		return !lista.isEmpty();	
	}
	

}
