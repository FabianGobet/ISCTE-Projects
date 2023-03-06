package pt.iul.poo.firefight.starterpack;

import pt.iul.ista.poo.utils.Direction;
import pt.iul.ista.poo.utils.Point2D;


public class Plane extends GameElement implements Movable,Updatable{
	

	public Plane() {
		super(new Point2D(Fire.maxFireColumn(),Level.getWidth()-1));
	}

	@Override
	public String getName() {
		return "plane";
	}

	@Override
	public int getLayer() {
		return 4;
	}

	@Override
	public void move() {
		for(int i=0; i<2;i++) {
			ge.addTile(new Water(getPosition(),Direction.DOWN));
			this.position=getPosition().plus(Direction.UP.asVector());
				
		}
	}
		

	@Override
	public void update() {
		if(!ge.gui.isWithinBounds(this.position))
			ge.removeTile(this);
		
	}
	
	public static void invoquePlane() {
		GameEngine.getInstance().addTile(new Plane());
	}


	

}
