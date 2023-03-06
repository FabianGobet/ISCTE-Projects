package pt.iul.poo.firefight.starterpack;

import java.awt.event.KeyEvent;

import pt.iul.ista.poo.utils.Direction;
import pt.iul.ista.poo.utils.Point2D;

public class Firetruck extends Driveable{

	public Firetruck(Point2D ponto) {
		super(ponto);
	}

	@Override
	public String getName() {
		if(this.direcao!=null) {
			return "firetruck_"+direcao.name().toLowerCase();
			
		}
		return "firetruck";
	}

	@Override
	public void behaviour(Point2D target) {
		if(!botGotOut()){
			if(Fire.getThat(target)!=null) {
				Direction d = Direction.directionFor(ge.gui.keyPressed());
				for(Point2D p : this.position.plus(d.asVector()).getFrontRect(d, 3, 2))
					if(Fire.getThat(p)!=null) {
						ge.addTile(new Water(p,d));
						ge.score.addPoints(3);
					}
			} else{
				moveAndKill(target);
			}
		}
	}

	@Override
	public void setDirection(int key) {
		if(key==KeyEvent.VK_LEFT || key==KeyEvent.VK_RIGHT)
		this.direcao=Direction.directionFor(key);
	}

}
