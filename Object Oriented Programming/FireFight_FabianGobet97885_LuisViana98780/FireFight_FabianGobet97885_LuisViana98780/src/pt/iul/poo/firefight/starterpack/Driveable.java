package pt.iul.poo.firefight.starterpack;

import java.awt.event.KeyEvent;

import pt.iul.ista.poo.utils.Direction;
import pt.iul.ista.poo.utils.Point2D;

public abstract class Driveable extends GameElement implements Movable,Interactable,Activatable,Updatable{
	
	private boolean active=false;
	public Direction direcao;
	public boolean bloody=false;
	private int count=0;
	private boolean on;
	public Fireman bombeiro;

	public Driveable(Point2D ponto) {
		super(ponto);

	}


	@Override
	public int getLayer() {
		return 2;
	}
//	
	
	public void ride(Fireman ff) {
		this.bombeiro = ff;
		ge.removeTile(ff);
	}
	

	@Override
	public void interact() {
		this.on=true;	
	}

	@Override
	public void activate() {
		this.active=true;
		
	}

	@Override
	public void deactivate() {
		this.active=false;
		
	}

	@Override
	public boolean isActive() {
		return active;
	}
	
	public boolean isOn() {
		return on;
	}
	
	
	private void getOutOfBulldozer() {
		ge.addTile(bombeiro);
		this.deactivate();
		this.on=false;
		bombeiro=null;
	}
	
	public void killFireman(Fireman f) {
		f.interact();
		this.bloody=true;
	}
	
	public boolean botGotOut() {
		if(this.bombeiro!=null)
			if(!this.bombeiro.active) {
				getOutOfBulldozer();
				return true;
			}
		return false;
	}
	
	public static Driveable getThat(Point2D target) {
		return GameEngine.getInstance().getObject(o-> (o instanceof Driveable) && o.getPosition().equals(target));
	}
	
	public abstract void behaviour(Point2D target);
	
	public abstract void setDirection(int key);
	
	
	public void moveAndKill(Point2D target) {
		Fireman f = Fireman.firemanOnPosition(target);
		bombeiro.riding(target);
		setDirection(ge.gui.keyPressed());
		this.position=target;
		if(bloody)
			ge.addTile(new Blood(this.position, this.direcao));
		if(f!=null) {
			killFireman(f);
		}
	}

	@Override
	public void move() {
		if(on && active) {
			int key = ge.gui.keyPressed();
			if(Direction.isDirection(key)) {
				Point2D target = getPosition().plus(Direction.directionFor(key).asVector());
				Driveable other = Driveable.getThat(target);
				if(ge.gui.isWithinBounds(target) && other==null) {
					behaviour(target);
				}	
			} else if(key==KeyEvent.VK_ENTER) 
				getOutOfBulldozer();
			else if (key==KeyEvent.VK_L) {
				bombeiro.changePlayer();
				getOutOfBulldozer();
			}
		}
	}

	@Override
	public void update() {
		if(this.bombeiro!=null && !on)
			this.on=true;
		else if(this.bombeiro==null && on)
			this.on=false;
		if(bloody) {
			if(this.count>5) {
				this.count=0;
				this.bloody=false;
			} else
				count++;
		}
	}


}
